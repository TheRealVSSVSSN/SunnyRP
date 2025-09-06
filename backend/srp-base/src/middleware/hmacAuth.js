const crypto = require('crypto');

module.exports = function hmacAuth(req, res, next) {
  const key = process.env.SRP_INTERNAL_KEY || 'change_me';
  const header = req.headers['x-srp-internal-key'] || '';
  const a = Buffer.from(header);
  const b = Buffer.from(key);
  if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) {
    return res.status(401).json({ error: 'unauthorized' });
  }
  next();
};
