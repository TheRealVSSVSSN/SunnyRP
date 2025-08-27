const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { broadcast } = require('../realtime/websocket');
const { dispatch } = require('../hooks/dispatcher');
const { listCoords, saveCoord, deleteCoord } = require('../repositories/coordinatesRepository');

const router = express.Router();

router.get([
  '/v1/characters/:characterId/coordinates',
  '/v1/characters/:characterId/coords', // deprecated alias
], async (req, res) => {
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
    const coordinates = await listCoords(id);
    sendOk(res, { coordinates }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post([
  '/v1/characters/:characterId/coordinates',
  '/v1/characters/:characterId/coords', // deprecated alias
], async (req, res) => {
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
    const coordinate = await saveCoord({ characterId: id, name, x, y, z, heading });
    broadcast('coordinates', 'coordinate.saved', { characterId: id, coordinate });
    dispatch('coordinates.saved', { characterId: id, coordinate });
    sendOk(res, { coordinate }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_SAVE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.delete([
  '/v1/characters/:characterId/coordinates/:id',
  '/v1/characters/:characterId/coords/:id', // deprecated alias
], async (req, res) => {
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
    broadcast('coordinates', 'coordinate.deleted', { characterId: characterNum, coordId: coordNum });
    dispatch('coordinates.deleted', { characterId: characterNum, coordId: coordNum });
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COORD_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
