// src/middleware/replayGuard.js
import crypto from 'crypto';
import { createClient } from 'redis';
import { env } from '../config/env.js';
import { fail } from '../utils/respond.js';

let redis;

/**
 * HMAC replay guard.
 * NOTE: If a request is authenticated via a service token (req.isService === true),
 * we SKIP HMAC to ease inter-service reads on a trusted network.
 */
export function replayGuard() {
    return async (req, res, next) => {
        try {
            if (req.isService) return next();

            const ts = req.header('X-Ts');
            const nonce = req.header('X-Nonce');
            const sig = req.header('X-Sig');

            if (!ts || !nonce || !sig) {
                return fail(req, res, 'UNAUTHENTICATED', 'Missing HMAC headers');
            }

            const skew = Math.abs(Math.floor(Date.now() / 1000) - parseInt(ts, 10));
            if (skew > env.REPLAY_ALLOWED_SKEW_SECONDS) {
                return fail(req, res, 'UNAUTHENTICATED', 'Timestamp skew');
            }

            const method = req.method.toUpperCase();
            const path = req.originalUrl.split('?')[0];
            const canonical = `${ts}\n${nonce}\n${method}\n${path}\n${req.rawBody || ''}`;
            const calc = crypto.createHmac('sha256', env.API_TOKEN)
                .update(canonical, 'utf8')
                .digest('hex');

            if (calc !== sig) {
                return fail(req, res, 'UNAUTHENTICATED', 'BAD_SIG');
            }

            if (env.REDIS_URL) {
                if (!redis) {
                    redis = createClient({ url: env.REDIS_URL });
                    await redis.connect();
                }
                const key = `replay:${nonce}:${ts}`;
                const nx = await redis.set(key, '1', {
                    NX: true,
                    EX: env.REPLAY_ALLOWED_SKEW_SECONDS
                });
                if (!nx) {
                    return fail(req, res, 'UNAUTHENTICATED', 'REPLAY');
                }
            }

            return next();
        } catch (e) {
            return next(e);
        }
    };
}