const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listCharacterEmotes,
  addCharacterEmote,
  removeCharacterEmote,
} = require('../repositories/emotesRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List favorite emotes for a character
router.get('/v1/characters/:characterId/emotes', async (req, res) => {
  const { characterId } = req.params;
  const idNum = parseInt(characterId, 10);
  if (Number.isNaN(idNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const emotes = await listCharacterEmotes(idNum);
    sendOk(res, { emotes }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'EMOTE_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// Add a favorite emote for a character
router.post('/v1/characters/:characterId/emotes', async (req, res) => {
  const { characterId } = req.params;
  const { emote } = req.body;
  const idNum = parseInt(characterId, 10);
  if (Number.isNaN(idNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!emote || typeof emote !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'emote is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const record = await addCharacterEmote({ characterId: idNum, emote });
    websocket.broadcast('emotes', 'favoriteAdded', { characterId: idNum, emote });
    hooks.dispatch('emotes.favoriteAdded', { characterId: idNum, emote });
    sendOk(res, { emote: record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'EMOTE_CREATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// Remove a favorite emote for a character
router.delete('/v1/characters/:characterId/emotes/:emote', async (req, res) => {
  const { characterId, emote } = req.params;
  const idNum = parseInt(characterId, 10);
  if (Number.isNaN(idNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!emote) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'emote is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await removeCharacterEmote({ characterId: idNum, emote });
    websocket.broadcast('emotes', 'favoriteRemoved', { characterId: idNum, emote });
    hooks.dispatch('emotes.favoriteRemoved', { characterId: idNum, emote });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'EMOTE_DELETE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
