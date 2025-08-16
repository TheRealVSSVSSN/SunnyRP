// src/workers/outbox.worker.js
/**
 * SRP Base Outbox Worker
 * - Periodically claims pending outbox rows with a DB lock token
 * - Delivers via HTTP POST (OUTBOX_DELIVERY_URL) and/or Redis pub/sub (OUTBOX_REDIS_CHANNEL_PREFIX)
 * - Marks delivered/failed
 */

import { env } from '../config/env.js';
import { logger } from '../utils/logger.js';
import { claimPendingBatch, markDelivered, markFailed } from '../repositories/outbox.repo.js';
import { createClient } from 'redis';
import { httpPostJson } from '../utils/httpClient.js';

let redis = null;

async function ensureRedis() {
    if (!env.REDIS_URL) return null;
    if (!redis) {
        redis = createClient({ url: env.REDIS_URL });
        await redis.connect();
    }
    return redis;
}

async function deliverMessage(msg) {
    const deliveries = [];

    // HTTP delivery (optional)
    if (env.OUTBOX_DELIVERY_URL) {
        deliveries.push(
            (async () => {
                await httpPostJson(env.OUTBOX_DELIVERY_URL, {
                    id: msg.id,
                    topic: msg.topic,
                    payload: msg.payload
                });
            })()
        );
    }

    // Redis pub/sub delivery (optional)
    if (env.REDIS_URL && env.OUTBOX_REDIS_CHANNEL_PREFIX) {
        const client = await ensureRedis();
        const channel = `${env.OUTBOX_REDIS_CHANNEL_PREFIX}${msg.topic}`;
        deliveries.push(client.publish(channel, JSON.stringify({ id: msg.id, payload: msg.payload })));
    }

    // No target configured -> treat as delivered (noop) to avoid clogging the table
    if (deliveries.length === 0) {
        return;
    }

    await Promise.all(deliveries);
}

async function tick() {
    try {
        const batch = await claimPendingBatch(env.OUTBOX_BATCH_SIZE);
        if (batch.length === 0) return;

        for (const msg of batch) {
            try {
                await deliverMessage(msg);
                await markDelivered(msg.id);
            } catch (err) {
                await markFailed(msg.id, err?.message || 'delivery_failed');
                logger.warn({ id: msg.id, err: String(err) }, 'outbox delivery failed');
            }
        }
    } catch (err) {
        logger.error({ err: String(err) }, 'outbox tick error');
    }
}

async function main() {
    if (!env.ENABLE_OUTBOX_WORKER) {
        logger.info('outbox worker disabled (ENABLE_OUTBOX_WORKER=false)');
        process.exit(0);
    }

    logger.info({
        batch: env.OUTBOX_BATCH_SIZE,
        intervalMs: env.OUTBOX_INTERVAL_MS,
        http: !!env.OUTBOX_DELIVERY_URL,
        redis: !!env.REDIS_URL
    }, 'outbox worker starting');

    setInterval(tick, env.OUTBOX_INTERVAL_MS).unref();
}

main().catch((err) => {
    // eslint-disable-next-line no-console
    console.error('worker fatal:', err);
    process.exit(1);
});