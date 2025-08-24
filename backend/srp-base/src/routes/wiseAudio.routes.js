const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/wiseAudioRepository');

const router = express.Router();

router.get('/v1/wise-audio/tracks/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const tracks = await repo.listTracksByCharacter(characterId);
    sendOk(res, { tracks }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_AUDIO_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/wise-audio/tracks', async (req, res) => {
  const { characterId, label, url } = req.body || {};
  if (!characterId || !label || !url) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, label and url are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const track = await repo.createTrack({ characterId, label, url });
    sendOk(res, { track }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_AUDIO_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
