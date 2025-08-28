const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const debugRepo = require('../repositories/debugRepository');
const { createRateLimiter } = require('../middleware/rateLimit');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// Rate limits
const debugLimiter = createRateLimiter({ windowMs: 60_000, max: 60 });
const writeLimiter = createRateLimiter({ windowMs: 60_000, max: 120 });
router.use('/v1/debug', debugLimiter);

// GET /v1/debug/status
router.get('/v1/debug/status', async (req, res) => {
  try {
    const info = await debugRepo.getSystemInfo();
    sendOk(res, { info }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'DEBUG_STATUS_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/debug/logs
router.post('/v1/debug/logs', writeLimiter, express.json(), async (req, res) => {
  const { level, message, context, accountId, characterId, source } = req.body || {};
  if (!level || !message) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'level and message are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const log = await debugRepo.insertLog({ level, message, context, accountId, characterId, source });
    websocket.broadcast('debug', 'log.created', log);
    hooks.dispatch('debug.log', log);
    sendOk(res, { log }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to store debug log' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/debug/logs
router.get('/v1/debug/logs', async (req, res) => {
  const { level, since, limit, accountId, characterId } = req.query || {};
  try {
    const logs = await debugRepo.listLogs({ level, since, limit: limit ? parseInt(limit, 10) : undefined, accountId, characterId: characterId ? parseInt(characterId, 10) : undefined });
    sendOk(res, { logs }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to list logs' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/debug/markers
router.post('/v1/debug/markers', writeLimiter, express.json(), async (req, res) => {
  const { type, data, ttlMs, createdBy } = req.body || {};
  if (!type) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'type is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const marker = await debugRepo.createMarker({ type, data, ttlMs, createdBy });
    websocket.broadcast('debug', 'marker.created', marker);
    hooks.dispatch('debug.marker.created', marker);
    sendOk(res, { marker }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create marker' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/debug/markers
router.get('/v1/debug/markers', async (req, res) => {
  const { type } = req.query || {};
  try {
    const markers = await debugRepo.listActiveMarkers({ type });
    sendOk(res, { markers }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to list markers' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/debug/markers/:id
router.delete('/v1/debug/markers/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (Number.isNaN(id)) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'invalid id' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const deleted = await debugRepo.deleteMarker(id);
    if (deleted) {
      websocket.broadcast('debug', 'marker.deleted', { id });
      hooks.dispatch('debug.marker.deleted', { id });
    }
    sendOk(res, { deleted }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to delete marker' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
