const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const taxiRepo = require('../repositories/taxiRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

// List taxi requests by status
router.get('/v1/taxi/requests', async (req, res) => {
  const { status = 'requested' } = req.query;
  if (!['requested', 'accepted', 'completed', 'cancelled'].includes(status)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'invalid status' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const requests = await taxiRepo.listRequestsByStatus(status);
    sendOk(res, { requests }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TAXI_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create taxi request
router.post('/v1/taxi/requests', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { passengerCharacterId, pickupX, pickupY, pickupZ } = req.body || {};
  if ([passengerCharacterId, pickupX, pickupY, pickupZ].some((v) => typeof v !== 'number')) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'passengerCharacterId, pickupX, pickupY and pickupZ are required numbers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const request = await taxiRepo.createRequest({
      passengerId: passengerCharacterId,
      pickupX,
      pickupY,
      pickupZ,
    });
    websocket.broadcast('taxi', 'request.created', request);
    dispatcher.dispatch('taxi.request.created', request);
    sendOk(res, { request }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TAXI_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Accept taxi request
router.post('/v1/taxi/requests/:id/accept', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const requestId = parseInt(req.params.id, 10);
  const { driverCharacterId } = req.body || {};
  if (Number.isNaN(requestId) || typeof driverCharacterId !== 'number') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id and driverCharacterId must be numbers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const request = await taxiRepo.acceptRequest({ requestId, driverId: driverCharacterId });
    if (!request) {
      return sendError(
        res,
        { code: 'TAXI_ACCEPT_FAILED', message: 'request not found or already accepted' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('taxi', 'request.accepted', request);
    dispatcher.dispatch('taxi.request.accepted', request);
    sendOk(res, { request }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TAXI_ACCEPT_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Complete taxi request
router.post('/v1/taxi/requests/:id/complete', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const requestId = parseInt(req.params.id, 10);
  const { driverCharacterId, dropoffX, dropoffY, dropoffZ, fare } = req.body || {};
  if (
    Number.isNaN(requestId) ||
    typeof driverCharacterId !== 'number' ||
    [dropoffX, dropoffY, dropoffZ, fare].some((v) => typeof v !== 'number')
  ) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'invalid input' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const request = await taxiRepo.completeRequest({
      requestId,
      driverId: driverCharacterId,
      dropoffX,
      dropoffY,
      dropoffZ,
      fare,
    });
    if (!request) {
      return sendError(
        res,
        { code: 'TAXI_COMPLETE_FAILED', message: 'request not found or not accepted by driver' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('taxi', 'request.completed', request);
    dispatcher.dispatch('taxi.request.completed', request);
    sendOk(res, { request }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TAXI_COMPLETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// List completed rides for a character
router.get('/v1/characters/:characterId/taxi/rides', async (req, res) => {
  const characterId = parseInt(req.params.characterId, 10);
  const { role = 'passenger' } = req.query;
  if (Number.isNaN(characterId) || !['driver', 'passenger'].includes(role)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a number and role must be driver or passenger' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const rides = await taxiRepo.listRidesByCharacter(characterId, role);
    sendOk(res, { rides }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TAXI_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
