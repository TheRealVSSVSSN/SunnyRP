const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const vehiclesRepo = require('../repositories/vehiclesRepository');
const vehicleControlRepo = require('../repositories/vehicleControlRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

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

// -----------------------------------------------------------------------------
// Harness and plate management
//
// Retrieve the harness durability for a given vehicle plate.  If the vehicle
// has no harness value, `harness` will be null.
router.get('/v1/vehicles/harness/:plate', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const harness = await vehiclesRepo.getHarnessByPlate(plate);
    sendOk(res, { harness }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update harness durability for a vehicle plate.  Expects JSON body with
// `durability` property (integer).  Returns the number of rows updated.
router.patch('/v1/vehicles/harness/:plate', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const { durability } = req.body || {};
    const updated = await vehiclesRepo.updateHarnessByPlate(plate, durability);
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Change the license plate of a vehicle.  Expects JSON body with
// `oldPlate` and `newPlate`.  Returns the number of rows updated.
router.post('/v1/vehicles/plate-change', async (req, res, next) => {
  try {
    const { oldPlate, newPlate } = req.body || {};
    const updated = await vehiclesRepo.changePlate(oldPlate, newPlate);
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// -----------------------------------------------------------------------------
// Vehicle condition management
//
// Retrieve the condition for a vehicle (engine damage, body damage, fuel and
// degradation array).  Plate is passed in the URL path.  Returns null if
// the vehicle does not exist or has no condition recorded.
router.get('/v1/vehicles/:plate/condition', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const condition = await vehiclesRepo.getVehicleConditionByPlate(plate);
    sendOk(res, condition, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update engine, body and fuel condition for a vehicle.  Expects a JSON body
// with any combination of `engineDamage`, `bodyDamage` or `fuel`.  Fields
// omitted will remain unchanged.  Returns the number of rows updated.
router.patch('/v1/vehicles/:plate/condition', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const { engineDamage, bodyDamage, fuel } = req.body || {};
    const updated = await vehiclesRepo.updateVehicleConditionByPlate(plate, {
      engineDamage,
      bodyDamage,
      fuel,
    });
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update degradation array for a vehicle.  Expects a JSON body with a
// `degradation` property as an array of eight integers.  Returns the number
// of rows updated.
router.patch('/v1/vehicles/:plate/degradation', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const { degradation } = req.body || {};
    const updated = await vehiclesRepo.updateVehicleDegradationByPlate(plate, degradation);
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// -----------------------------------------------------------------------------
// Vehicle control state
//
// Retrieve current control state for a vehicle (siren, indicator, etc.).
router.get('/v1/vehicles/:plate/control', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const state = await vehicleControlRepo.getByPlate(plate);
    sendOk(res, state, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update control state for a vehicle. Any provided fields overwrite existing values.
router.post('/v1/vehicles/:plate/control', async (req, res, next) => {
  try {
    const { plate } = req.params;
    const { sirenMuted, lxSirenState, powercallState, airManuState, indicatorState } = req.body || {};
    if (
      sirenMuted === undefined &&
      lxSirenState === undefined &&
      powercallState === undefined &&
      airManuState === undefined &&
      indicatorState === undefined
    ) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'at least one control field must be provided' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const updated = await vehicleControlRepo.upsert(plate, {
      sirenMuted,
      lxSirenState,
      powercallState,
      airManuState,
      indicatorState,
    });
    const payload = {
      plate,
      sirenMuted: sirenMuted ?? undefined,
      lxSirenState: lxSirenState ?? undefined,
      powercallState: powercallState ?? undefined,
      airManuState: airManuState ?? undefined,
      indicatorState: indicatorState ?? undefined,
    };
    websocket.broadcast('vehicles', 'control.update', payload);
    hooks.dispatch('vehicles.control.update', payload);
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
