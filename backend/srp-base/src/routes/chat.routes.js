const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { listMessagesByCharacter, createMessage } = require('../repositories/chatRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List chat messages for a character
router.get('/v1/chat/messages/:characterId', async (req, res) => {
  try {
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
    const limit = req.query.limit ? parseInt(req.query.limit, 10) : 50;
    const messages = await listMessagesByCharacter(idNum, Number.isNaN(limit) ? 50 : limit);
    sendOk(res, { messages }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CHAT_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a chat message
router.post('/v1/chat/messages', async (req, res) => {
  const { characterId, channel, message } = req.body || {};
  const idNum = parseInt(characterId, 10);
  if (Number.isNaN(idNum) || typeof channel !== 'string' || !channel || typeof message !== 'string' || !message) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, channel and message are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const msg = await createMessage({ characterId: idNum, channel, message });
    sendOk(res, { message: msg }, res.locals.requestId, res.locals.traceId);
    websocket.broadcast('chat', 'message', { message: msg });
    hooks.dispatch('chat.message', msg);
  } catch (err) {
    sendError(res, { code: 'CHAT_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
