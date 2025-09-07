/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const buckets = new Map();

module.exports = function rateLimit(options = {}) {
  const windowMs = options.windowMs || 60 * 1000;
  const max = options.max || 60;
  return (req, res, next) => {
    const now = Date.now();
    const ip = req.ip;
    let bucket = buckets.get(ip);
    if (!bucket || now - bucket.ts >= windowMs) {
      bucket = { tokens: max - 1, ts: now };
      buckets.set(ip, bucket);
      return next();
    }
    if (bucket.tokens <= 0) {
      res.status(429).json({ error: 'rate_limit_exceeded' });
      return;
    }
    bucket.tokens--;
    next();
  };
};
