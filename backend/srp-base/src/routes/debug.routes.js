const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { getSystemInfo } = require('../repositories/debugRepository');
const { createRateLimiter } = require('../middleware/rateLimit');

const router = express.Router();

// Limit debug info requests to 30 per minute per IP
const debugLimiter = createRateLimiter({ windowMs: 60_000, max: 30 });
router.use('/v1/debug', debugLimiter);

// GET /v1/debug/status
router.get('/v1/debug/status', async (req, res) => {
  try {
    const info = await getSystemInfo();
    sendOk(res, { info }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'DEBUG_STATUS_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
