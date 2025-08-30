const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/commandsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/commands', async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit, 10) || 50, 100);
  const offset = parseInt(req.query.offset, 10) || 0;
  try {
    const commands = await repo.list(limit, offset);
    sendOk(res, { commands }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COMMAND_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/commands', async (req, res) => {
  const { name, description, police, ems, judge } = req.body;
  if (!name || typeof name !== 'string') {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const command = await repo.create({ name, description, police: !!police, ems: !!ems, judge: !!judge });
    websocket.broadcast('commands', 'created', command);
    hooks.dispatch('commands.created', command);
    sendOk(res, { command }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COMMAND_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.delete('/v1/commands/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (Number.isNaN(id)) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'id must be integer' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    await repo.remove(id);
    websocket.broadcast('commands', 'removed', { id });
    hooks.dispatch('commands.removed', { id });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'COMMAND_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
