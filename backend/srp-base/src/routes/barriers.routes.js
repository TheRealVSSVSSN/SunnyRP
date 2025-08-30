const express = require('express');
const barriersRepo = require('../repositories/barriersRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/barriers - list all barriers
router.get('/v1/barriers', async (req, res) => {
  try {
    const barriers = await barriersRepo.getAll();
    sendOk(res, { barriers }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to fetch barriers' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/barriers - create a barrier
router.post('/v1/barriers', express.json(), async (req, res) => {
  const { model, position, heading } = req.body || {};
  if (!model || !position) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'model and position are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const barrier = await barriersRepo.create({ model, position, heading, placedBy: res.locals.characterId });
    websocket.broadcast('barriers', 'created', { barrier });
    hooks.dispatch('barriers.created', barrier);
    sendOk(res, { barrier }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to create barrier' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// PATCH /v1/barriers/:barrierId/state - set barrier state
router.patch('/v1/barriers/:barrierId/state', express.json(), async (req, res) => {
  const { barrierId } = req.params;
  const { state, ttl } = req.body || {};
  if (typeof state !== 'boolean') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'state boolean is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const barrier = await barriersRepo.setState(barrierId, state, ttl);
    websocket.broadcast('barriers', 'state', { barrier });
    hooks.dispatch('barriers.state', barrier);
    sendOk(res, { barrier }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to update barrier state' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
