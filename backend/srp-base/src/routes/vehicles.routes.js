const express = require('express');
const { sendOk } = require('../utils/respond');
const vehiclesRepo = require('../repositories/vehiclesRepository');

// Routes for vehicle ownership and registration.  These endpoints
// persist data about player vehicles and expose basic CRUD
// operations.  They intentionally avoid gameplay logic like
// garage spawning or modifications – those live in Lua scripts.
const router = express.Router();

// Retrieve vehicles for a player
router.get('/v1/vehicles/:playerId', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const vehicles = await vehiclesRepo.getVehicles(playerId);
    sendOk(res, vehicles, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Register a new vehicle
router.post('/v1/vehicles', async (req, res, next) => {
  try {
    const { playerId, model, plate, properties } = req.body || {};
    const result = await vehiclesRepo.registerVehicle({ playerId, model, plate, properties });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update an existing vehicle
router.post('/v1/vehicles/:id/update', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const updated = await vehiclesRepo.updateVehicle(id, req.body || {});
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List shop vehicles (placeholder)
router.get('/v1/vehicles/shop', async (req, res, next) => {
  try {
    const vehicles = await vehiclesRepo.listShopVehicles();
    sendOk(res, vehicles, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;