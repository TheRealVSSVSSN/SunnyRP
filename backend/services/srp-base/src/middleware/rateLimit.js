// src/middleware/rateLimit.js
import { createClient } from 'redis';
import { env } from '../config/env.js';
import { fail } from '../utils/respond.js';

let redis;
const memory = new Map(); // key -> { count, resetAtMs }

async function ensureRedis() {
    if (!env.REDIS_URL) return null;
    if (!redis) {
        redis = createClient({ url: env.REDIS_URL });
        await redis.connect();
    }
    return redis;
}

/**
 * rateLimit({ key, windowSec, limit })
 * - key: string | (req)=>string
 * - windowSec: seconds for window
 * - limit: max number of requests allowed in the window
 */
export function rateLimit({ key, windowSec = 60, limit = 30 }) {
    return async (req, res, next) => {
        try {
            const k = typeof key === 'function' ? key(req) : key;
            if (!k) return next(); // no key -> pass

            const bucket = `rl:${k}`;
            const now = Date.now();

            if (env.REDIS_URL) {
                const client = await ensureRedis();
                const multi = client.multi();
                multi.incr(bucket);
                multi.ttl(bucket);
                const [count, ttl] = await multi.exec().then(arr => [arr[0], arr[1]]);
                if (count === 1) {
                    await client.expire(bucket, windowSec);
                }
                if (count > limit) {
                    const retryAfter = ttl > 0 ? ttl : windowSec;
                    res.setHeader('Retry-After', String(retryAfter));
                    return fail(req, res, 'RATE_LIMITED', 'Too many requests');
                }
                return next();
            }

            // memory fallback
            let entry = memory.get(bucket);
            if (!entry || now >= entry.resetAtMs) {
                entry = { count: 0, resetAtMs: now + windowSec * 1000 };
            }
            entry.count += 1;
            memory.set(bucket, entry);

            if (entry.count > limit) {
                const retryAfter = Math.max(1, Math.ceil((entry.resetAtMs - now) / 1000));
                res.setHeader('Retry-After', String(retryAfter));
                return fail(req, res, 'RATE_LIMITED', 'Too many requests');
            }

            return next();
        } catch (err) {
            // On limiter failure, don't block the request
            return next();
        }
    };
}