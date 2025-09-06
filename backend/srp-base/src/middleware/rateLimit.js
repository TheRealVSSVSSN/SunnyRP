const buckets = new Map();

module.exports = function rateLimit({ windowMs = 1000, limit = 60 } = {}) {
  return (req, res, next) => {
    const ip = req.ip || req.connection.remoteAddress || 'global';
    const now = Date.now();
    let bucket = buckets.get(ip);
    if (!bucket || now - bucket.start >= windowMs) {
      bucket = { start: now, count: 0 };
      buckets.set(ip, bucket);
    }
    bucket.count += 1;
    if (bucket.count > limit) {
      const retry = Math.ceil((bucket.start + windowMs - now) / 1000);
      res.setHeader('Retry-After', retry);
      return res.status(429).json({ error: 'rate_limited' });
    }
    next();
  };
};
