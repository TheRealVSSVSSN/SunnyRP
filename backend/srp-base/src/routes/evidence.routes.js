const express = require('express');
const evidenceRepo = require('../repositories/evidenceRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/evidence/items
router.get('/v1/evidence/items', async (req, res) => {
  try {
    const items = await evidenceRepo.getItems();
    sendOk(res, items, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch evidence' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/evidence/items/:id
router.get('/v1/evidence/items/:id', async (req, res) => {
  try {
    const item = await evidenceRepo.getItem(req.params.id);
    if (!item) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/evidence/items
router.post('/v1/evidence/items', express.json(), async (req, res) => {
  const { type, description, location, owner, metadata } = req.body || {};
  if (!type || !description) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'type and description are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const item = await evidenceRepo.createItem({ type, description, location, owner, metadata });
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/evidence/items/:id
router.patch('/v1/evidence/items/:id', express.json(), async (req, res) => {
  try {
    const item = await evidenceRepo.updateItem(req.params.id, req.body || {});
    if (!item) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, item, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to update item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/evidence/items/:id
router.delete('/v1/evidence/items/:id', async (req, res) => {
  try {
    const ok = await evidenceRepo.deleteItem(req.params.id);
    if (!ok) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Item not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to delete item' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;