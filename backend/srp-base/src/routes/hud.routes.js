const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const hudRepo = require('../repositories/hudRepository');
const vehicleStatusRepo = require('../repositories/vehicleStatusRepository');
const websocket = require('../realtime/websocket');

const router = express.Router();

// Get HUD preferences for a character
router.get('/v1/characters/:characterId/hud', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const id = parseInt(characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const prefs = await hudRepo.getPreferences(id);
    sendOk(res, prefs, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update HUD preferences for a character
router.put('/v1/characters/:characterId/hud', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const id = parseInt(characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { speedUnit, showFuel, hudTheme } = req.body || {};
    if (speedUnit && !['mph', 'kph'].includes(speedUnit)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'speedUnit must be mph or kph' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const prefs = await hudRepo.upsertPreferences(id, {
      speedUnit: speedUnit || 'mph',
      showFuel: typeof showFuel === 'boolean' ? showFuel : true,
      hudTheme: hudTheme || null,
    });
    sendOk(res, prefs, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Get vehicle HUD status for a character
router.get('/v1/characters/:characterId/vehicle-state', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const id = parseInt(characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const status = await vehicleStatusRepo.getStatus(id);
    sendOk(res, status, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update vehicle HUD status for a character
router.put('/v1/characters/:characterId/vehicle-state', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const id = parseInt(characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { seatbelt, harness, nitrous } = req.body || {};
    const status = await vehicleStatusRepo.upsertStatus(id, {
      seatbelt: !!seatbelt,
      harness: !!harness,
      nitrous: Number.isFinite(nitrous) ? nitrous : 0,
    });
    websocket.broadcast('hud', 'vehicleState', status);
    sendOk(res, status, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
