const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/wiseWheelsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/wise-wheels/spins/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const spins = await repo.listSpinsByCharacter(characterId);
    sendOk(res, { spins }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'WISE_WHEELS_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

router.post('/v1/wise-wheels/spins', async (req, res) => {
  const { characterId, prize } = req.body || {};
  if (!characterId || !prize) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and prize are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const spin = await repo.createSpin({ characterId, prize });
    websocket.broadcast('wise-wheels', 'spin-created', { spin });
    hooks.dispatch('wise-wheels.spin.created', spin);
    sendOk(res, { spin }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'WISE_WHEELS_CREATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
