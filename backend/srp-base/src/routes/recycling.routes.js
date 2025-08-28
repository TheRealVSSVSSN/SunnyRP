const express = require('express');
const { sendOk } = require('../utils/respond');
const recyclingRepo = require('../repositories/recyclingRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List recycling deliveries for a character.
router.get('/v1/recycling/deliveries/:characterId', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const runs = await recyclingRepo.listRunsByCharacter(parseInt(characterId, 10));
    sendOk(res, { deliveries: runs }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Record a recycling delivery.
router.post('/v1/recycling/deliveries', async (req, res, next) => {
  try {
    const { characterId, materials } = req.body || {};
    const run = await recyclingRepo.createRun({ characterId, materials });
    const payload = { id: run.id, characterId, materials };
    websocket.broadcast('recycling', 'delivery.created', payload);
    hooks.dispatch('recycling.delivery.created', payload);
    sendOk(res, payload, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
