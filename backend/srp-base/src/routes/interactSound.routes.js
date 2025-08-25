const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/interactSoundRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/interact-sound/plays/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const plays = await repo.listPlaysByCharacter(characterId);
    sendOk(res, { plays }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERACT_SOUND_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/interact-sound/plays', async (req, res) => {
  const { characterId, sound, volume, playedAt } = req.body || {};
  if (!characterId || !sound || volume == null) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, sound and volume are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const play = await repo.recordPlay({ characterId, sound, volume, playedAt });
    websocket.broadcast('audio', 'play', play);
    hooks.dispatch('interactSound.play', play);
    sendOk(res, { play }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERACT_SOUND_RECORD_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
