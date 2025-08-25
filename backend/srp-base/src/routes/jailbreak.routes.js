const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const jailbreakRepo = require('../repositories/jailbreakRepository');

const router = express.Router();

// Start a jailbreak attempt
router.post('/v1/jailbreaks', async (req, res, next) => {
  try {
    const { characterId, prison } = req.body || {};
    if (!characterId || !prison) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'characterId and prison required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const attempt = await jailbreakRepo.createAttempt({ characterId, prison });
    sendOk(res, { attempt }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Complete a jailbreak attempt
router.post('/v1/jailbreaks/:id/complete', async (req, res, next) => {
  try {
    const { id } = req.params;
    const { success } = req.body || {};
    if (typeof success !== 'boolean') {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'success boolean required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const attempt = await jailbreakRepo.completeAttempt({ id, success });
    if (!attempt) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Attempt not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    sendOk(res, { attempt }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List active jailbreak attempts
router.get('/v1/jailbreaks/active', async (req, res, next) => {
  try {
    const attempts = await jailbreakRepo.listActiveAttempts();
    sendOk(res, { attempts }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
