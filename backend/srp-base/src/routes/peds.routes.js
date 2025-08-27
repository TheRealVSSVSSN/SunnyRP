const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { getCharacterPed, upsertCharacterPed } = require('../repositories/pedsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// Get ped state for a character
router.get('/v1/characters/:characterId/ped', async (req, res, next) => {
  try {
    const id = parseInt(req.params.characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const ped = await getCharacterPed(id);
    sendOk(res, { ped }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Upsert ped state for a character
router.put('/v1/characters/:characterId/ped', async (req, res, next) => {
  try {
    const id = parseInt(req.params.characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { model, health, armor } = req.body || {};
    if (!model || typeof model !== 'string') {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'model is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const h = parseInt(health, 10);
    const a = parseInt(armor, 10);
    if (Number.isNaN(h) || Number.isNaN(a)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'health and armor must be numbers' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const ped = await upsertCharacterPed({ characterId: id, model, health: h, armor: a });
    websocket.broadcast('peds', 'pedUpdated', ped);
    hooks.dispatch('peds.updated', ped);
    sendOk(res, { ped }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
