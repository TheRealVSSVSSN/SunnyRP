const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/wiseUCRepository');

const router = express.Router();

router.get('/v1/wise-uc/profiles/:characterId', async (req, res) => {
  const { characterId } = req.params;
  if (!characterId) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'characterId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const profile = await repo.getProfileByCharacter(characterId);
    if (!profile) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Profile not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    sendOk(res, { profile }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'WISE_UC_GET_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

router.post('/v1/wise-uc/profiles', async (req, res) => {
  const { characterId, alias, active = true } = req.body || {};
  if (!characterId || !alias) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'characterId and alias are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const profile = await repo.upsertProfile({ characterId, alias, active });
    sendOk(res, { profile }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'WISE_UC_UPSERT_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
