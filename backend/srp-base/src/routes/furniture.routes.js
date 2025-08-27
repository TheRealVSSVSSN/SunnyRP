const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listFurniture,
  createFurniture,
  deleteFurniture,
} = require('../repositories/furnitureRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

// List furniture for a character
router.get('/v1/characters/:characterId/furniture', async (req, res) => {
  const { characterId } = req.params;
  const charId = parseInt(characterId, 10);
  if (Number.isNaN(charId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const furniture = await listFurniture(charId);
    sendOk(res, { furniture }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'FURNITURE_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create furniture for a character
router.post('/v1/characters/:characterId/furniture', async (req, res) => {
  const { characterId } = req.params;
  const charId = parseInt(characterId, 10);
  const { item, x, y, z, heading } = req.body;
  if (Number.isNaN(charId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!item || typeof item !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'item is required and must be a string' },
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
    const furniture = await createFurniture({ characterId: charId, item, x, y, z, heading });
    sendOk(res, { furniture }, res.locals.requestId, res.locals.traceId);
    websocket.broadcast('furniture', 'furniture.placed', { characterId: charId, furniture });
    dispatcher.dispatch('furniture.placed', { characterId: charId, furniture });
  } catch (err) {
    sendError(res, { code: 'FURNITURE_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Delete furniture item
router.delete('/v1/characters/:characterId/furniture/:id', async (req, res) => {
  const { characterId, id } = req.params;
  const charId = parseInt(characterId, 10);
  const furnId = parseInt(id, 10);
  if (Number.isNaN(charId) || Number.isNaN(furnId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and id must be valid integers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await deleteFurniture(charId, furnId);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
    websocket.broadcast('furniture', 'furniture.removed', { characterId: charId, id: furnId });
    dispatcher.dispatch('furniture.removed', { characterId: charId, id: furnId });
  } catch (err) {
    sendError(res, { code: 'FURNITURE_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
