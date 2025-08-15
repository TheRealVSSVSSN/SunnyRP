// src/middleware/idempotency.js
import { createClient } from 'redis';
import { env } from '../config/env.js';
import { fail } from '../utils/respond.js';

let redis;
const memory = new Map(); // fallback per-process

async function getStore(key) {
    if (env.REDIS_URL) {
        if (!redis) {
            redis = createClient({ url: env.REDIS_URL });
            await redis.connect();
        }
        const val = await redis.get(`idem:${key}`);
        return val ? JSON.parse(val) : null;
    }
    const entry = memory.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expires) {
        memory.delete(key);
        return null;
    }
    return entry.value;
}

async function setStore(key, payload) {
    const ttl = env.IDEMPOTENCY_TTL_SEC;
    if (env.REDIS_URL) {
        await redis.set(`idem:${key}`, JSON.stringify(payload), { EX: ttl, NX: true });
        return;
    }
    memory.set(key, { value: payload, expires: Date.now() + ttl * 1000 });
}

/**
 * Wrap a route handler with idempotency support.
 * Reads "Idempotency-Key" header; if a stored response exists, returns it.
 * Otherwise executes handler and stores the first JSON response.
 */
export function idempotentRoute(handler) {
    return async (req, res, next) => {
        const key = req.header('Idempotency-Key');
        if (!key) {
            // no key provided, proceed normally
            return handler(req, res, next);
        }

        try {
            const cached = await getStore(key);
            if (cached) {
                res.status(cached.status);
                return res.json(cached.body);
            }

            const originalStatus = res.status.bind(res);
            const originalJson = res.json.bind(res);
            let statusCode = res.statusCode;

            res.status = (code) => {
                statusCode = code;
                return originalStatus(code);
            };

            res.json = async (body) => {
                try {
                    await setStore(key, { status: statusCode || 200, body });
                } catch (_) {
                    // ignore storage failures
                }
                return originalJson(body);
            };

            return handler(req, res, next);
        } catch (err) {
            return next(err);
        }
    };
}