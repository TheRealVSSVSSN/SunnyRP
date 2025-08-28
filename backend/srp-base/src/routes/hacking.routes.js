const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const hackingRepo = require('../repositories/hackingRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/hacking/attempts', async (req, res) => {
  const characterId = parseInt(req.query.characterId, 10);
  const limit = parseInt(req.query.limit || '10', 10);
  if (Number.isNaN(characterId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId query param required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const attempts = await hackingRepo.listRecent(characterId, limit);
    sendOk(res, { attempts }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HACKING_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/hacking/attempts', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { characterId, target, success } = req.body || {};
  if (typeof characterId !== 'number' || typeof target !== 'string' || typeof success !== 'boolean') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId (number), target (string), success (boolean) required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const attempt = await hackingRepo.createAttempt({ characterId, target, success });
    websocket.broadcast('hacking', 'attempt.created', attempt);
    dispatcher.dispatch('hacking.attempt.created', attempt);
    sendOk(res, { attempt }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HACKING_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
