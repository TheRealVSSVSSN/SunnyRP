const express = require('express');
const keysRepo = require('../repositories/keysRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// POST /v1/keys
router.post('/v1/keys', express.json(), async (req, res) => {
  const { player_id, key_type, target_id, metadata } = req.body || {};
  if (!player_id || !key_type || !target_id) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'player_id, key_type and target_id are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const key = await keysRepo.assignKey({ player_id, key_type, target_id, metadata });
    sendOk(res, key, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to assign key' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/keys/:id
router.delete('/v1/keys/:id', async (req, res) => {
  try {
    const ok = await keysRepo.revokeKey(req.params.id);
    if (!ok) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Key not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to revoke key' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/keys/:playerId
router.get('/v1/keys/:playerId', async (req, res) => {
  try {
    const keys = await keysRepo.listKeysForPlayer(req.params.playerId);
    sendOk(res, keys, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to list keys' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;