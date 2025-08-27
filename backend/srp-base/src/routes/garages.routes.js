const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { createRateLimiter } = require('../middleware/rateLimit');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const {
  listGarages,
  createGarage,
  updateGarage,
  deleteGarage,
  storeVehicle,
  retrieveVehicle,
  listGarageVehicles,
} = require('../repositories/garagesRepository');

const router = express.Router();

// List all garages
router.get('/v1/garages', async (req, res) => {
  try {
    const garages = await listGarages();
    sendOk(res, { garages }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGES_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a new garage
router.post('/v1/garages', async (req, res) => {
  const { name, location, capacity } = req.body;
  if (!name) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const garage = await createGarage(name, location || null, capacity || 10);
    sendOk(res, { garage }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update a garage
router.put('/v1/garages/:id', async (req, res) => {
  const { id } = req.params;
  const data = req.body;
  if (!data || Object.keys(data).length === 0) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'At least one field is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const garage = await updateGarage(id, data);
    sendOk(res, { garage }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Delete a garage
router.delete('/v1/garages/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await deleteGarage(id);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Store a vehicle in a garage
const storeLimiter = createRateLimiter({ windowMs: 60000, max: 30, errorCode: 'RATE_LIMIT', message: 'Too many store requests' });
router.post('/v1/garages/:garageId/store', storeLimiter, async (req, res) => {
  const { garageId } = req.params;
  const { vehicleId, characterId } = req.body;
  if (!vehicleId || !characterId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'vehicleId and characterId are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const record = await storeVehicle(Number(garageId), Number(vehicleId), Number(characterId));
    websocket.broadcast('vehicles', 'garage.vehicleStored', {
      garageId: Number(garageId),
      vehicleId: Number(vehicleId),
      characterId: Number(characterId),
    });
    hooks.dispatch('garage.vehicleStored', {
      garageId: Number(garageId),
      vehicleId: Number(vehicleId),
      characterId: Number(characterId),
    });
    sendOk(res, { record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_STORE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Retrieve a vehicle from a garage
const retrieveLimiter = createRateLimiter({ windowMs: 60000, max: 30, errorCode: 'RATE_LIMIT', message: 'Too many retrieve requests' });
router.post('/v1/garages/:garageId/retrieve', retrieveLimiter, async (req, res) => {
  const { garageId } = req.params;
  const { vehicleId, characterId } = req.body;
  if (!vehicleId || !characterId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'vehicleId and characterId are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    await retrieveVehicle(Number(garageId), Number(vehicleId), Number(characterId));
    websocket.broadcast('vehicles', 'garage.vehicleRetrieved', {
      garageId: Number(garageId),
      vehicleId: Number(vehicleId),
      characterId: Number(characterId),
    });
    hooks.dispatch('garage.vehicleRetrieved', {
      garageId: Number(garageId),
      vehicleId: Number(vehicleId),
      characterId: Number(characterId),
    });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_RETRIEVE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// List vehicles stored by a character in a garage
router.get('/v1/characters/:characterId/garages/:garageId/vehicles', async (req, res) => {
  const { characterId, garageId } = req.params;
  try {
    const vehicles = await listGarageVehicles(Number(garageId), Number(characterId));
    sendOk(res, { vehicles }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_VEHICLES_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});
module.exports = router;

