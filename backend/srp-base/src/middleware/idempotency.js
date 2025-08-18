const { sendOk } = require('../utils/respond');
const logger = require('../utils/logger');

// In-memory store of idempotency keys mapped to responses.
// The value stored is the full JSON body and status code from a
// previous request.  In production this should be backed by
// persistent storage (e.g. Redis) to survive restarts and across
// multiple instances.
const idempotencyStore = new Map();

/**
 * Express middleware for idempotent operations.  Clients supply a
 * unique X-Idempotency-Key header on mutating requests (POST, PUT,
 * PATCH, DELETE).  The middleware checks if a response has already
 * been recorded under that key.  If present it immediately returns
 * the previous result, otherwise it records the outcome.  Only
 * successful 2xx responses are stored; failures will always be
 * processed fresh to allow clients to retry.
 */
function idempotencyMiddleware(req, res, next) {
  // Only apply to writes
  if (!/^(POST|PUT|PATCH|DELETE)$/i.test(req.method)) {
    return next();
  }
  const key = req.get('X-Idempotency-Key');
  if (!key) {
    return next();
  }
  const existing = idempotencyStore.get(key);
  if (existing) {
    // Respond with stored result
    res.status(existing.statusCode);
    return res.json(existing.body);
  }
  // Hook into res.json to capture the response
  const originalJson = res.json.bind(res);
  res.json = (body) => {
    // Only store successful responses (status < 300)
    if (res.statusCode >= 200 && res.statusCode < 300) {
      idempotencyStore.set(key, {
        statusCode: res.statusCode,
        body,
      });
    }
    return originalJson(body);
  };
  next();
}

module.exports = idempotencyMiddleware;