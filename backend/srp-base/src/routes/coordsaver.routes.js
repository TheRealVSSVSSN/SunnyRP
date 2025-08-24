const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { listCoords, saveCoord, deleteCoord } = require('../repositories/coordsaverRepository');

const router = express.Router();

router.get('/v1/characters/:characterId/coords', async (req, res) => {
  const { characterId } = req.params;
  const id = parseInt(characterId, 10);
  if (Number.isNaN(id)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const coords = await listCoords(id);
    sendOk(res, { coords }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/characters/:characterId/coords', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { characterId } = req.params;
  const id = parseInt(characterId, 10);
  const { name, x, y, z, heading } = req.body || {};
  if (Number.isNaN(id)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!name || typeof name !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'name is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if ([x, y, z].some((v) => typeof v !== 'number')) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'x, y and z must be numbers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const coord = await saveCoord({ characterId: id, name, x, y, z, heading });
    sendOk(res, { coord }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_SAVE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.delete('/v1/characters/:characterId/coords/:id', async (req, res) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { characterId, id } = req.params;
  const characterNum = parseInt(characterId, 10);
  const coordNum = parseInt(id, 10);
  if (Number.isNaN(characterNum) || Number.isNaN(coordNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and id must be numbers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await deleteCoord(characterNum, coordNum);
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
