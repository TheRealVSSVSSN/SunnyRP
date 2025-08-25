const express = require('express');
const dispatchRepo = require('../repositories/dispatchRepository');
const { sendOk, sendError } = require('../utils/respond');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// GET /v1/dispatch/alerts
router.get('/v1/dispatch/alerts', async (req, res) => {
  try {
    const alerts = await dispatchRepo.getAlerts();
    sendOk(res, { alerts }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch alerts' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/dispatch/alerts
router.post('/v1/dispatch/alerts', express.json(), async (req, res) => {
  const { code, title, description, sender, coords } = req.body || {};
  if (!code || !title) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'code and title are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const alert = await dispatchRepo.createAlert({ code, title, description, sender, coords });
    websocket.broadcast('police', 'dispatchAlert', alert);
    hooks.dispatch('police.dispatch.alert', alert);
    sendOk(res, { alert }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create alert' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/dispatch/alerts/:id/ack
router.patch('/v1/dispatch/alerts/:id/ack', async (req, res) => {
  const { id } = req.params;
  try {
    const ok = await dispatchRepo.acknowledgeAlert(id);
    if (!ok) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Alert not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    const payload = { id: parseInt(id, 10), status: 'acknowledged' };
    websocket.broadcast('police', 'dispatchAck', payload);
    hooks.dispatch('police.dispatch.ack', payload);
    sendOk(res, { acknowledged: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to acknowledge alert' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/dispatch/codes
router.get('/v1/dispatch/codes', async (req, res) => {
  try {
    const codes = await dispatchRepo.getCodes();
    sendOk(res, { codes }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch codes' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;