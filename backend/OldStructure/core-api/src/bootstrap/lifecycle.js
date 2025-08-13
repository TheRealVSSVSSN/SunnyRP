// src/bootstrap/lifecycle.js
import { logger } from '../utils/logger.js';
import metrics from '../utils/metrics.js';
import { db } from '../repositories/db.js';
import { redisReady } from './redis.js';

/**
 * Mount liveness/readiness/metrics endpoints.
 * - /health : always OK if the process is up
 * - /ready  : DB ping, Redis (if configured), and outbox lag gate
 * - /metrics: Prometheus metrics
 */
export function mountLifecycle(app) {
    app.get('/health', (_req, res) => res.json({ ok: true }));

    app.get('/ready', async (_req, res) => {
        // 1) DB connectivity
        try {
            await db.raw('select 1');
        } catch (e) {
            logger.warn({ err: e?.message || e }, 'ready: db ping failed');
            return res.status(500).json({ ok: false, reason: 'db' });
        }

        // 2) Redis (only if URL provided)
        if (process.env.REDIS_URL && !redisReady()) {
            return res.status(503).json({ ok: false, reason: 'redis' });
        }

        // 3) Outbox lag guard (optional; defaults to 120s)
        const lagMax = Number(process.env.OUTBOX_READY_LAG_MAX_S || 120);
        try {
            const row = await db('outbox_events')
                .where({ status: 'pending' })
                .orderBy('id', 'desc')
                .first();

            if (row) {
                const lagSec = Math.max(
                    0,
                    Math.round((Date.now() - new Date(row.created_at).getTime()) / 1000)
                );
                if (lagSec > lagMax) {
                    return res
                        .status(503)
                        .json({ ok: false, reason: `outbox_lag_${lagSec}` });
                }
            }
        } catch (e) {
            // If outbox table is missing in early boot, don't hard-fail readiness
            logger.warn({ err: e?.message || e }, 'ready: outbox check failed');
        }

        return res.json({ ok: true });
    });

    app.get('/metrics', async (_req, res) => {
        res.set('Content-Type', metrics.register.contentType);
        res.end(await metrics.register.metrics());
    });
}

/**
 * Graceful shutdown for HTTP server (SIGINT/SIGTERM)
 */
export function setupLifecycle(server) {
    const shutdown =
        (sig) =>
            () => {
                logger.info({ sig }, 'Shutting down...');
                server.close(() => {
                    logger.info('HTTP server closed');
                    process.exit(0);
                });
                setTimeout(() => process.exit(1), 5000).unref();
            };

    ['SIGINT', 'SIGTERM'].forEach((sig) => process.on(sig, shutdown(sig)));
}