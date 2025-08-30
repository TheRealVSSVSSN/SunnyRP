const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listAnimations,
  createAnimation,
  disableAnimation,
} = require('../repositories/dancesRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List dance animations
router.get('/v1/dances/animations', async (req, res) => {
  try {
    const animations = await listAnimations();
    sendOk(res, { animations }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'DANCE_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// Create a dance animation
router.post('/v1/dances/animations', async (req, res) => {
  const { name, dict, animation } = req.body;
  if (!name || typeof name !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'name is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!dict || typeof dict !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'dict is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!animation || typeof animation !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'animation is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const record = await createAnimation({ name, dict, animation });
    websocket.broadcast('dances', 'animationAdded', record);
    hooks.dispatch('dances.animationAdded', record);
    sendOk(res, { animation: record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'DANCE_CREATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// Disable a dance animation
router.delete('/v1/dances/animations/:id', async (req, res) => {
  const { id } = req.params;
  const idNum = parseInt(id, 10);
  if (Number.isNaN(idNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await disableAnimation(idNum);
    websocket.broadcast('dances', 'animationRemoved', { id: idNum });
    hooks.dispatch('dances.animationRemoved', { id: idNum });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'DANCE_DELETE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
