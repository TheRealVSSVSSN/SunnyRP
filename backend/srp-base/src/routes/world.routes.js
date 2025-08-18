const express = require('express');
const { sendOk } = require('../utils/respond');
const worldRepo = require('../repositories/worldRepository');

// Routes for world state and events.  These endpoints provide a
// foundation for FiveM resources that need to fetch or update
// global state (time, weather), record deaths/kills and save
// coordinates.  They perform no gameplay logic themselves but
// simply persist and return data.
const router = express.Router();

// Fetch the latest world state (time, weather, density).  Returns
// null if no state has been recorded yet.
router.get('/v1/world/state', async (req, res, next) => {
  try {
    const state = await worldRepo.getWorldState();
    sendOk(res, state, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update the world state.  Expects a JSON body with time,
// weather and density properties.  Clients should include
// idempotency and HMAC headers to avoid duplicate updates and to
// authenticate the call.
router.post('/v1/world/state', async (req, res, next) => {
  try {
    const { time, weather, density } = req.body || {};
    await worldRepo.updateWorldState({ time, weather, density });
    sendOk(res, { message: 'World state updated' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Record a death event.  Accepts a JSON body with playerId,
// killerId (optional), weapon (optional) and coords.  This
// endpoint simply persists the event; consumers can subscribe to
// domain events via the outbox pattern if desired.
router.post('/v1/world/events/death', async (req, res, next) => {
  try {
    const { playerId, killerId, weapon, coords, meta } = req.body || {};
    await worldRepo.recordEvent({ type: 'death', playerId, killerId, weapon, coords, meta });
    sendOk(res, { message: 'Death event recorded' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Record a kill event.  Accepts a JSON body with playerId,
// killerId, weapon and coords.  Kill and death are separated for
// clarity but share the same underlying storage.
router.post('/v1/world/events/kill', async (req, res, next) => {
  try {
    const { playerId, killerId, weapon, coords, meta } = req.body || {};
    await worldRepo.recordEvent({ type: 'kill', playerId, killerId, weapon, coords, meta });
    sendOk(res, { message: 'Kill event recorded' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Save arbitrary coordinates.  Accepts a JSON body with
// playerId, label and coords.  Coordinates should be an object
// containing x/y/z or other relevant values.  Consumers can use
// this for command based coordinate saving or zone creation.
router.post('/v1/world/coords/save', async (req, res, next) => {
  try {
    const { playerId, label, coords } = req.body || {};
    await worldRepo.saveCoordinates({ playerId, label, coords });
    sendOk(res, { message: 'Coordinates saved' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;