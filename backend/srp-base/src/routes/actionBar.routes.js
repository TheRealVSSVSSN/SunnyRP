const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { createRateLimiter } = require('../middleware/rateLimit');
const actionBarRepo = require('../repositories/actionBarRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

const readLimiter = createRateLimiter({ windowMs: 60_000, max: 60 });
const writeLimiter = createRateLimiter({ windowMs: 60_000, max: 30 });

// GET /v1/characters/:characterId/action-bar
router.get('/v1/characters/:characterId/action-bar', readLimiter, async (req, res, next) => {
  try {
    const id = parseInt(req.params.characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const slots = await actionBarRepo.getSlots(id);
    sendOk(res, slots, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// PUT /v1/characters/:characterId/action-bar
router.put('/v1/characters/:characterId/action-bar', writeLimiter, async (req, res, next) => {
  if (!req.headers['x-idempotency-key']) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const id = parseInt(req.params.characterId, 10);
    if (Number.isNaN(id)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const { slots } = req.body || {};
    if (!Array.isArray(slots)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'slots must be an array' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const norm = [];
    for (const s of slots) {
      const slotNum = parseInt(s.slot, 10);
      if (Number.isNaN(slotNum) || slotNum < 1 || slotNum > 5) {
        return sendError(
          res,
          { code: 'VALIDATION_ERROR', message: 'slot must be 1-5' },
          400,
          res.locals.requestId,
          res.locals.traceId,
        );
      }
      const item = s.item ? String(s.item).slice(0, 64) : null;
      norm.push({ slot: slotNum, item });
    }
    const updated = await actionBarRepo.setSlots(id, norm);
    const payload = { characterId: id, slots: updated };
    websocket.broadcast('hud', 'actionBar.updated', payload);
    dispatcher.dispatch('hud.actionBar.updated', payload);
    sendOk(res, updated, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
