const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const ClothesRepository = require('../repositories/clothesRepository');
const { createRateLimiter } = require('../middleware/rateLimit');

const router = express.Router();

// Limit clothing operations to 20 requests per minute per IP
const clothesLimiter = createRateLimiter({ windowMs: 60_000, max: 20 });
router.use('/v1/clothes', clothesLimiter);

// GET /v1/clothes?characterId=123
router.get('/v1/clothes', async (req, res) => {
  const { characterId } = req.query;
  if (!characterId) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'characterId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const cid = parseInt(characterId, 10);
  if (Number.isNaN(cid)) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'characterId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const clothes = await ClothesRepository.listByCharacter(cid);
    sendOk(res, { clothes }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CLOTHES_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/clothes
router.post('/v1/clothes', async (req, res) => {
  const { characterId, slot, data, name } = req.body || {};
  if (!characterId || !slot || !data) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, slot and data are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const cid = parseInt(characterId, 10);
  if (Number.isNaN(cid)) {
    return sendError(
      res,
      { code: 'INVALID_ARGUMENT', message: 'characterId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const clothing = await ClothesRepository.create({ characterId: cid, slot, data, name });
    sendOk(res, { clothing }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CLOTHES_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/clothes/:id
router.delete('/v1/clothes/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await ClothesRepository.delete(id);
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CLOTHES_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
