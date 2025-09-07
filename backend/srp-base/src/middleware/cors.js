/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

module.exports = (req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-Request-Id, Idempotency-Key, X-SRP-Internal-Key');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,DELETE,OPTIONS');
  if (req.method === 'OPTIONS') {
    res.status(204).end();
    return;
  }
  next();
};
