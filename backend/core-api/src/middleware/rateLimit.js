import { RateLimiterMemory } from 'rate-limiter-flexible';
import { config } from '../config/index.js';

const limiter = new RateLimiterMemory({
    points: config.rate.max,
    duration: Math.ceil(config.rate.windowMs / 1000)
});

export default function rateLimit() {
    return async (req, res, next) => {
        try {
            await limiter.consume(req.ip || 'unknown');
            next();
        } catch {
            res.status(429).json({ ok: false, error: { code: 'RATE_LIMIT', message: 'Too many requests' } });
        }
    };
}