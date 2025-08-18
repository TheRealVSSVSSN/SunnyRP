const rateLimit = require('express-rate-limit');
const { sendError } = require('../utils/respond');

/**
 * Factory for creating a rate limiting middleware.  Uses the
 * express-rate-limit package under the hood.  When the limit is
 * exceeded the middleware responds with a 429 status and a standard
 * error envelope.  Each limiter can be configured independently by
 * passing the window (in ms), the max number of requests and an
 * error code/message pair.
 *
 * Note: the limiter stores counts in memory.  For distributed
 * deployments a central store (e.g. Redis) should be used instead.
 */
function createRateLimiter({ windowMs, max, errorCode = 'RATE_LIMITED', message = 'Too many requests' }) {
  return rateLimit({
    windowMs,
    max,
    standardHeaders: true,
    legacyHeaders: false,
    handler: (req, res) => {
      // Use the requestId and traceId from res.locals if present
      sendError(res, { code: errorCode, message }, 429, res.locals.requestId, res.locals.traceId);
    },
  });
}

module.exports = { createRateLimiter };