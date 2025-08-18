const express = require('express');
const lootRepo = require('../repositories/lootRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/loot/items
router.get('/v1/loot/items', async (req, res) => {
  try {
    const items = await lootRepo.getItems();
    sendOk(res, items, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch items' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/loot/items/:id
router.get('/v1/loot/items/:id', async (req, res) => {
  try {
    const item = await lootRepo.getItem(req.params.id);
    if (!item) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/loot/items
router.post('/v1/loot/items', express.json(), async (req, res) => {
  const { owner_id, item_type, value, coordinates, metadata } = req.body || {};
  if (!owner_id || !item_type) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'owner_id and item_type are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const item = await lootRepo.createItem({ owner_id, item_type, value, coordinates, metadata });
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/loot/items/:id
router.patch('/v1/loot/items/:id', express.json(), async (req, res) => {
  try {
    const item = await lootRepo.updateItem(req.params.id, req.body || {});
    if (!item) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to update item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/loot/items/:id
router.delete('/v1/loot/items/:id', async (req, res) => {
  try {
    const ok = await lootRepo.deleteItem(req.params.id);
    if (!ok) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to delete item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;