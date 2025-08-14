// src/middleware/replayGuard.js
import crypto from 'crypto';
import { createClient } from 'redis';
import { env } from '../config/env.js';
import { fail } from '../utils/respond.js';

let redis;

/**
 * Verifies HMAC headers and prevents replay using Redis (optional).
 * Canonical string: `${ts}\n${nonce}\n${METHOD}\n${path}\n${rawBody}`
 */
export function replayGuard() {
    return async (req, res, next) => {
        try {
            const ts = req.header('X-Ts');
            const nonce = req.header('X-Nonce');
            const sig = req.header('X-Sig');

            if (!ts || !nonce || !sig) {
                return fail(req, res, 'UNAUTHENTICATED', 'Missing HMAC headers');
            }

            const nowSec = Math.floor(Date.now() / 1000);
            const skew = Math.abs(nowSec - parseInt(ts, 10));
            if (skew > env.REPLAY_ALLOWED_SKEW_SECONDS) {
                return fail(req, res, 'UNAUTHENTICATED', 'Timestamp skew');
            }

            const method = req.method.toUpperCase();
            const path = req.originalUrl.split('?')[0];
            const canonical = `${ts}\n${nonce}\n${method}\n${path}\n${req.rawBody || ''}`;

            const calc = crypto
                .createHmac('sha256', env.API_TOKEN)
                .update(canonical, 'utf8')
                .digest('hex');

            if (calc !== sig) {
                return fail(req, res, 'UNAUTHENTICATED', 'BAD_SIG');
            }

            // Optional Redis replay dedupe
            if (env.REDIS_URL) {
                if (!redis) {
                    redis = createClient({ url: env.REDIS_URL });
                    await redis.connect();
                }
                const key = `replay:${nonce}:${ts}`;
                const ok = await redis.set(key, '1', {
                    NX: true,
                    EX: env.REPLAY_ALLOWED_SKEW_SECONDS
                });
                if (!ok) {
                    return fail(req, res, 'UNAUTHENTICATED', 'REPLAY');
                }
            }

            return next();
        } catch (err) {
            return next(err);
        }
    };
}