const hits = new Map();
const WINDOW = 60_000;
const LIMIT = 100;

/**
 * Simple token bucket rate limiter keyed by IP.
 */
export function rateLimit(req, res, next) {
  const ip = req.ip || req.socket.remoteAddress || 'unknown';
  const now = Date.now();
  let record = hits.get(ip);
  if (!record || now > record.reset) {
    record = { count: 0, reset: now + WINDOW };
    hits.set(ip, record);
  }
  record.count++;
  if (record.count > LIMIT) {
    const err = new Error('rate_limit');
    err.status = 429;
    err.retryAfter = Math.ceil((record.reset - now) / 1000);
    return next(err);
  }
  next();
}
