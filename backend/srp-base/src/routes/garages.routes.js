const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listGarages,
  createGarage,
  updateGarage,
  deleteGarage,
  storeVehicle,
  retrieveVehicle,
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
router.post('/v1/garages/:garageId/store', async (req, res) => {
  const { garageId } = req.params;
  const { vehicleId } = req.body;
  if (!vehicleId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'vehicleId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const record = await storeVehicle(garageId, vehicleId);
    sendOk(res, { record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_STORE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Retrieve a vehicle from a garage
router.post('/v1/garages/:garageId/retrieve', async (req, res) => {
  const { garageId } = req.params;
  const { vehicleId } = req.body;
  if (!vehicleId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'vehicleId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    await retrieveVehicle(garageId, vehicleId);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GARAGE_RETRIEVE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;