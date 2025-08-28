const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const k9Repo = require('../repositories/k9Repository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List all active K9 units
router.get('/v1/k9s/active', async (req, res, next) => {
  try {
    const k9s = await k9Repo.listActive();
    sendOk(res, { k9s }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List K9 units for a character
router.get('/v1/characters/:characterId/k9s', async (req, res, next) => {
  try {
    const characterId = parseInt(req.params.characterId, 10);
    if (Number.isNaN(characterId)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const k9s = await k9Repo.listByCharacter(characterId);
    sendOk(res, { k9s }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Create a K9 unit for a character
router.post('/v1/characters/:characterId/k9s', async (req, res, next) => {
  try {
    if (!req.get('X-Idempotency-Key')) {
      return sendError(
        res,
        { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const characterId = parseInt(req.params.characterId, 10);
    if (Number.isNaN(characterId)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { name, breed } = req.body || {};
    if (!name || typeof name !== 'string' || !breed || typeof breed !== 'string') {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'name and breed are required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const k9 = await k9Repo.createK9({ characterId, name, breed });
    websocket.broadcast('police', 'k9.created', { k9 });
    hooks.dispatch('k9.created', { k9 });
    sendOk(res, { k9 }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update active state for a K9 unit
router.patch('/v1/characters/:characterId/k9s/:k9Id/active', async (req, res, next) => {
  try {
    if (!req.get('X-Idempotency-Key')) {
      return sendError(
        res,
        { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const characterId = parseInt(req.params.characterId, 10);
    const k9Id = parseInt(req.params.k9Id, 10);
    if (Number.isNaN(characterId) || Number.isNaN(k9Id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId and k9Id must be integers' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { active } = req.body || {};
    const updated = await k9Repo.setActive(characterId, k9Id, active ? 1 : 0);
    if (updated) {
      websocket.broadcast('police', 'k9.updated', { characterId, k9Id, active: !!active });
      hooks.dispatch('k9.updated', { characterId, k9Id, active: !!active });
    }
    sendOk(res, { updated }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Retire a K9 unit
router.delete('/v1/characters/:characterId/k9s/:k9Id', async (req, res, next) => {
  try {
    if (!req.get('X-Idempotency-Key')) {
      return sendError(
        res,
        { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const characterId = parseInt(req.params.characterId, 10);
    const k9Id = parseInt(req.params.k9Id, 10);
    if (Number.isNaN(characterId) || Number.isNaN(k9Id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId and k9Id must be integers' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const removed = await k9Repo.retireK9(characterId, k9Id);
    if (removed) {
      websocket.broadcast('police', 'k9.retired', { characterId, k9Id });
      hooks.dispatch('k9.retired', { characterId, k9Id });
    }
    sendOk(res, { removed }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
