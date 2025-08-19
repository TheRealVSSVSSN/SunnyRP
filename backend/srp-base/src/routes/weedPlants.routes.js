const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  createWeedPlant,
  deleteWeedPlant,
  updateWeedPlant,
  getAllWeedPlants,
} = require('../repositories/weedPlantsRepository');

const router = express.Router();

// List all weed plants
router.get('/v1/weed-plants', async (req, res) => {
  try {
    const plants = await getAllWeedPlants();
    sendOk(res, { plants }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WEED_PLANTS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a weed plant
router.post('/v1/weed-plants', async (req, res) => {
  const { coords, seed, ownerId } = req.body;
  if (!coords || typeof coords !== 'object' || coords.x === undefined || coords.y === undefined || coords.z === undefined) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'coords object with x, y, z fields is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!seed) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'seed is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!ownerId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'ownerId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const plant = await createWeedPlant(coords, seed, ownerId);
    sendOk(res, { plant }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WEED_PLANT_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update weed plant growth
router.patch('/v1/weed-plants/:id', async (req, res) => {
  const { id } = req.params;
  const { growth } = req.body;
  if (growth === undefined || Number.isNaN(parseInt(growth, 10))) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'growth numeric value is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const plant = await updateWeedPlant(id, parseInt(growth, 10));
    sendOk(res, { plant }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WEED_PLANT_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Delete a weed plant
router.delete('/v1/weed-plants/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await deleteWeedPlant(id);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WEED_PLANT_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;