const express = require('express');
const errorRepo = require('../repositories/errorRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Routes for logging client or server errors.  These endpoints
 * allow services and clients to persist error information to
 * the database for later inspection.  Use POST /v1/error to
 * submit an error.  Optionally, GET /v1/error can list the
 * most recent errors.
 */

const router = express.Router();

// POST /v1/error - log an error
router.post('/v1/error', express.json(), async (req, res) => {
  const { source, level, message, stack } = req.body || {};
  if (!message) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'message is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    await errorRepo.log({ source, level, message, stack });
    sendOk(res, { logged: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to log error' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/error - list recent errors (optional)
router.get('/v1/error', async (req, res) => {
  const { limit, level } = req.query;
  try {
    const errors = await errorRepo.list({ limit, level });
    sendOk(res, { errors }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch errors' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;