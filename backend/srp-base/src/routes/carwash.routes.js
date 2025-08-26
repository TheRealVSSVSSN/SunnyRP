const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const carwashRepo = require('../repositories/carwashRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

// Routes for vehicle car washes and dirt tracking.
const router = express.Router();

// Record a car wash for a vehicle and reset dirt level
router.post('/v1/carwash', async (req, res, next) => {
  try {
    const { characterId, plate, location, cost } = req.body || {};
    if (!characterId || !plate || !location || cost === undefined) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'characterId, plate, location and cost are required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { id } = await carwashRepo.recordWash({
      characterId: Number(characterId),
      plate,
      location,
      cost: Number(cost),
    });
    websocket.broadcast('vehicles', 'dirt.update', { plate, dirt: 0 });
    hooks.dispatch('carwash.wash', {
      characterId: Number(characterId),
      plate,
      location,
      cost: Number(cost),
    });
    sendOk(res, { id }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Retrieve wash history for a character
router.get('/v1/carwash/history/:characterId', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const history = await carwashRepo.getHistory(Number(characterId));
    sendOk(res, { history }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Get dirt level for a vehicle
router.get('/v1/vehicles/:plate/dirt', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const dirt = await carwashRepo.getDirtByPlate(plate);
    sendOk(res, { dirt }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update dirt level for a vehicle
router.patch('/v1/vehicles/:plate/dirt', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const { dirt } = req.body || {};
    if (dirt === undefined) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'dirt is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const updated = await carwashRepo.setDirtByPlate(plate, Number(dirt));
    websocket.broadcast('vehicles', 'dirt.update', { plate, dirt: Number(dirt) });
    hooks.dispatch('carwash.dirt.set', { plate, dirt: Number(dirt) });
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
