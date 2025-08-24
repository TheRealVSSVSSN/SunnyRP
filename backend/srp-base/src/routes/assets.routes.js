const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const AssetsRepository = require('../repositories/assetsRepository');
const { createRateLimiter } = require('../middleware/rateLimit');

const router = express.Router();

// Limit asset creation/listing to 20 requests per minute per IP
const assetsLimiter = createRateLimiter({ windowMs: 60_000, max: 20 });
router.use('/v1/assets', assetsLimiter);

// GET /v1/assets?ownerId=123
router.get('/v1/assets', async (req, res) => {
  const { ownerId } = req.query;
  if (!ownerId) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'ownerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const owner = parseInt(ownerId, 10);
  if (Number.isNaN(owner)) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'ownerId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const assets = await AssetsRepository.listByOwner(owner);
    sendOk(res, { assets }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'ASSET_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/assets/:id
router.get('/v1/assets/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const asset = await AssetsRepository.getAsset(id);
    if (!asset) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Asset not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { asset }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'ASSET_GET_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/assets
router.post('/v1/assets', async (req, res) => {
  const { ownerId, url, type, name } = req.body || {};
  if (!ownerId || !url || !type) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'ownerId, url and type are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const owner = parseInt(ownerId, 10);
  if (Number.isNaN(owner)) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'ownerId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const asset = await AssetsRepository.createAsset({ ownerId: owner, url, type, name });
    sendOk(res, { asset }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'ASSET_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/assets/:id
router.delete('/v1/assets/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await AssetsRepository.deleteAsset(id);
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'ASSET_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
