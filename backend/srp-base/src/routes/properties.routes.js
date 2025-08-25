const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { createRateLimiter } = require('../middleware/rateLimit');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const Properties = require('../repositories/propertiesRepository');

const router = express.Router();

// Limit property operations to 30 requests per minute per IP
const propertiesLimiter = createRateLimiter({ windowMs: 60_000, max: 30 });
router.use('/v1/properties', propertiesLimiter);

// GET /v1/properties
router.get('/v1/properties', async (req, res) => {
  try {
    const { type, ownerCharacterId } = req.query;
    const properties = await Properties.list({
      type: type || null,
      ownerCharacterId: ownerCharacterId ? parseInt(ownerCharacterId, 10) : null,
    });
    sendOk(res, { properties }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'PROPERTY_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/properties
router.post('/v1/properties', async (req, res) => {
  const { type, name, location, price, ownerCharacterId, expiresAt } = req.body || {};
  if (!type || !name) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'type and name are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const property = await Properties.create({
      type,
      name,
      location,
      price: price || 0,
      ownerCharacterId: ownerCharacterId || null,
      expiresAt: expiresAt || null,
    });
    websocket.broadcast('properties', 'propertyCreated', property);
    hooks.dispatch('properties.propertyCreated', property);
    sendOk(res, { property }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'PROPERTY_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/properties/:propertyId
router.get('/v1/properties/:propertyId', async (req, res) => {
  try {
    const property = await Properties.get(req.params.propertyId);
    if (!property) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Property not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { property }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'PROPERTY_GET_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/properties/:propertyId
router.patch('/v1/properties/:propertyId', async (req, res) => {
  try {
    const property = await Properties.update(req.params.propertyId, req.body || {});
    if (!property) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Property not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    websocket.broadcast('properties', 'propertyUpdated', property);
    hooks.dispatch('properties.propertyUpdated', property);
    sendOk(res, { property }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'PROPERTY_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/properties/:propertyId
router.delete('/v1/properties/:propertyId', async (req, res) => {
  try {
    const property = await Properties.get(req.params.propertyId);
    if (!property) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Property not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    await Properties.remove(req.params.propertyId);
    websocket.broadcast('properties', 'propertyDeleted', { id: req.params.propertyId });
    hooks.dispatch('properties.propertyDeleted', { id: req.params.propertyId });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'PROPERTY_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
