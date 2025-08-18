const { v4: uuidv4 } = require('uuid');

/**
 * Express middleware that attaches a unique requestId and traceId to
 * each incoming request.  The requestId is a UUID v4 used for
 * idempotency and correlation.  The traceId can be propagated
 * upstream (e.g. if the caller supplies an X‑Trace‑Id header) or
 * falls back to a new UUID.  Both identifiers are stored on
 * res.locals for access in routes and logged via pino.
 */
function requestId(req, res, next) {
  const incomingTraceId = req.get('X-Trace-Id');
  res.locals.requestId = uuidv4();
  res.locals.traceId = incomingTraceId || uuidv4();
  next();
}

module.exports = requestId;