const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const heliRepo = require('../repositories/heliRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

// Start helicopter flight
router.post('/v1/heli/flights', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { characterId, purpose } = req.body || {};
  if (typeof characterId !== 'number' || typeof purpose !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be number and purpose string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const flight = await heliRepo.createFlight({ characterId, purpose });
    websocket.broadcast('heli', 'heli.flightStarted', flight);
    dispatcher.dispatch('heli.flightStarted', flight);
    sendOk(res, { flight }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HELI_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// End helicopter flight
router.post('/v1/heli/flights/:id/end', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const flightId = parseInt(req.params.id, 10);
  if (Number.isNaN(flightId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id must be a number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const flight = await heliRepo.endFlight({ flightId });
    if (!flight) {
      return sendError(
        res,
        { code: 'HELI_END_FAILED', message: 'flight not found or already ended' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('heli', 'heli.flightEnded', flight);
    dispatcher.dispatch('heli.flightEnded', flight);
    sendOk(res, { flight }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HELI_END_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// List flights for a character
router.get('/v1/characters/:characterId/heli/flights', async (req, res) => {
  const characterId = parseInt(req.params.characterId, 10);
  if (Number.isNaN(characterId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const flights = await heliRepo.listFlightsByCharacter(characterId);
    sendOk(res, { flights }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'HELI_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
