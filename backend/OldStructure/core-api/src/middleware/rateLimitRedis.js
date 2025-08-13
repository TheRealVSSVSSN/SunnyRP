import { getRedis } from '../bootstrap/redis.js';

export default function rateLimitRedis({ windowMs = 10000, max = 120 } = {}) {
    return async (req, res, next) => {
        const r = getRedis();
        if (!r) return next(); // fallback to your existing limiter
        const u = req.header('X-SRP-UserId') || '0';
        const c = req.header('X-SRP-CharId') || '0';
        const k = `srp:ratelimit:${req.path}:${u}:${c}`;
        const now = Date.now();

        // Use a simple fixed window counter
        const ttlSec = Math.ceil(windowMs / 1000);
        const cnt = await r.incr(k);
        if (cnt === 1) await r.expire(k, ttlSec);
        if (cnt > max) return res.status(429).json({ ok: false, error: 'RATE_LIMITED' });
        next();
    };
}