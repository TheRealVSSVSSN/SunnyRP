/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const store = new Map();
const ttl = 10 * 60 * 1000;

module.exports = function idempotency() {
  return (req, res, next) => {
    const key = req.headers['idempotency-key'];
    if (!key) return next();
    const cached = store.get(key);
    if (cached && Date.now() - cached.ts < ttl) {
      for (const [k, v] of Object.entries(cached.headers)) {
        res.setHeader(k, v);
      }
      res.status(cached.status).send(cached.body);
      return;
    }
    const originalSend = res.send.bind(res);
    res.send = (body) => {
      store.set(key, { status: res.statusCode, headers: res.getHeaders(), body, ts: Date.now() });
      originalSend(body);
    };
    next();
  };
};
