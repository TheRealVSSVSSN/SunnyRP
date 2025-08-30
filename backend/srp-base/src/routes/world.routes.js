const express = require('express');
const { sendOk } = require('../utils/respond');
const worldRepo = require('../repositories/worldRepository');
const iplRepo = require('../repositories/iplRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

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
    const payload = { time: time || null, weather: weather || null, density: density || null };
    websocket.broadcast('world', 'state.updated', payload);
    hooks.dispatch('world.state.updated', payload);
    sendOk(res, { message: 'World state updated' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Broadcast rogue peds to clients for cleanup. Accepts an array of
// entity ids in `toDelete`. Uses websocket/webhook push only; no
// persistence is performed.
router.post('/v1/world/peds/rogue', async (req, res, next) => {
  try {
    const { toDelete = [] } = req.body || {};
    const payload = { toDelete };
    websocket.broadcast('world', 'peds.rogue', payload);
    hooks.dispatch('world.peds.rogue', payload);
    sendOk(res, { message: 'Rogue peds broadcast' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Fetch the latest weather forecast schedule. Returns null if no
// forecast has been stored.
router.get('/v1/world/forecast', async (req, res, next) => {
  try {
    const forecast = await worldRepo.getForecast();
    sendOk(res, forecast, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update the weather forecast schedule. Clients should include
// idempotency and HMAC headers to avoid duplicate updates and to
// authenticate the call.
router.post('/v1/world/forecast', async (req, res, next) => {
  try {
    const { forecast } = req.body || {};
    await worldRepo.updateForecast(forecast);
    sendOk(res, { message: 'Forecast updated' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Fetch the current timecycle override. Returns null if none is set.
router.get('/v1/world/timecycle', async (req, res, next) => {
  try {
    const override = await worldRepo.getTimecycleOverride();
    sendOk(res, override, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Set a timecycle override. Clients should include idempotency and
// HMAC headers to authenticate and avoid duplicates.
router.post('/v1/world/timecycle', async (req, res, next) => {
  try {
    const { preset, expiresAt } = req.body || {};
    await worldRepo.setTimecycleOverride({ preset, expiresAt });
    websocket.broadcast('world', 'timecycle.set', { preset, expiresAt: expiresAt || null });
    hooks.dispatch('world.timecycle.set', { preset, expiresAt: expiresAt || null });
    sendOk(res, { message: 'Timecycle override set' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Clear any active timecycle override.
router.delete('/v1/world/timecycle', async (req, res, next) => {
  try {
    await worldRepo.clearTimecycleOverride();
    websocket.broadcast('world', 'timecycle.clear', {});
    hooks.dispatch('world.timecycle.clear', {});
    sendOk(res, { message: 'Timecycle override cleared' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List all interior proxy states.
router.get('/v1/world/ipls', async (req, res, next) => {
  try {
    const ipls = await iplRepo.list();
    sendOk(res, { ipls }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Upsert an interior proxy state. Clients should include idempotency and
// HMAC headers for authentication and dedupe.
router.post('/v1/world/ipls', async (req, res, next) => {
  try {
    const { name, enabled } = req.body || {};
    await iplRepo.set(name, !!enabled);
    websocket.broadcast('world', 'ipl.updated', { name, enabled: !!enabled });
    hooks.dispatch('world.ipl.updated', { name, enabled: !!enabled });
    sendOk(res, { message: 'IPL state updated' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Remove an interior proxy state.
router.delete('/v1/world/ipls/:name', async (req, res, next) => {
  try {
    const { name } = req.params;
    await iplRepo.remove(name);
    websocket.broadcast('world', 'ipl.removed', { name });
    hooks.dispatch('world.ipl.removed', { name });
    sendOk(res, { message: 'IPL state removed' }, res.locals.requestId, res.locals.traceId);
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
