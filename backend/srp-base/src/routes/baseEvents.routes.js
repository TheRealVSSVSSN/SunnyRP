const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { logEvent, listEvents } = require('../repositories/baseEventsRepository');
const websocket = require('../realtime/websocket');

const router = express.Router();

// GET /v1/base-events - list recent events
router.get('/v1/base-events', async (req, res) => {
  const limitParam = req.query.limit;
  const limit = Number.parseInt(limitParam, 10) || 50;
  const { eventType } = req.query;
  try {
    const events = await listEvents({ limit, eventType });
    sendOk(res, { events }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'BASE_EVENTS_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/base-events - log an event
router.post('/v1/base-events', async (req, res) => {
  const { accountId, characterId, eventType, metadata } = req.body || {};
  if (!accountId || !characterId || !eventType) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'accountId, characterId and eventType are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const charNum = Number(characterId);
  if (Number.isNaN(charNum)) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'characterId must be a number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const event = await logEvent({ accountId, characterId: charNum, eventType, metadata: metadata || null });
    websocket.broadcast('base-events', 'base-events.logged', event);
    sendOk(res, { event }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'BASE_EVENT_LOG_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
