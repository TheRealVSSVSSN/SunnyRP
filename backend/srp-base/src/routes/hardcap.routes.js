const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { getStatus, updateConfig, createSession, endSession } = require('../repositories/hardcapRepository');
const { createRateLimiter } = require('../middleware/rateLimit');

const router = express.Router();

// Limit hardcap operations to 30 requests per minute per IP
const hardcapLimiter = createRateLimiter({ windowMs: 60_000, max: 30 });
router.use('/v1/hardcap', hardcapLimiter);

// GET /v1/hardcap/status
router.get('/v1/hardcap/status', async (req, res) => {
  try {
    const status = await getStatus();
    sendOk(res, { status }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HARDCAP_STATUS_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/hardcap/config
router.post('/v1/hardcap/config', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { maxPlayers, reservedSlots } = req.body || {};
  const maxNum = parseInt(maxPlayers, 10);
  const reserveNum = reservedSlots !== undefined ? parseInt(reservedSlots, 10) : 0;
  if (Number.isNaN(maxNum) || maxNum < 1 || Number.isNaN(reserveNum) || reserveNum < 0) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'maxPlayers must be positive and reservedSlots non-negative integers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const cfg = await updateConfig({ maxPlayers: maxNum, reservedSlots: reserveNum });
    sendOk(res, { config: cfg }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HARDCAP_CONFIG_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/hardcap/sessions
router.post('/v1/hardcap/sessions', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { accountId, characterId } = req.body || {};
  const accountNum = parseInt(accountId, 10);
  const charNum = parseInt(characterId, 10);
  if (Number.isNaN(accountNum) || Number.isNaN(charNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'accountId and characterId must be integers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const session = await createSession({ accountId: accountNum, characterId: charNum });
    sendOk(res, { session }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    let code = 'HARDCAP_SESSION_CREATE_FAILED';
    let status = 500;
    if (err.message === 'CHARACTER_NOT_FOUND') {
      code = 'CHARACTER_NOT_FOUND';
      status = 404;
    }
    sendError(res, { code, message: err.message }, status, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/hardcap/sessions/:id
router.delete('/v1/hardcap/sessions/:id', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { id } = req.params;
  const sessionId = parseInt(id, 10);
  if (Number.isNaN(sessionId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const deleted = await endSession(sessionId);
    sendOk(res, { deleted }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HARDCAP_SESSION_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
