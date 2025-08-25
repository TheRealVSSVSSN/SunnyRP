const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/wiseImportsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/wise-imports/orders/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const orders = await repo.listOrdersByCharacter(characterId);
    sendOk(res, { orders }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_IMPORTS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/wise-imports/orders', async (req, res) => {
  const { characterId, model } = req.body || {};
  if (!characterId || !model) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and model are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const order = await repo.createOrder({ characterId, model });
    websocket.broadcast('wise-imports', 'order-created', { order });
    hooks.dispatch('wise-imports.order.created', order);
    sendOk(res, { order }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_IMPORTS_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/wise-imports/orders/:id/deliver', async (req, res) => {
  if (!req.get('X-Idempotency-Key')) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { id } = req.params;
  const { characterId } = req.body || {};
  if (!characterId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const delivered = await repo.deliverOrder(Number(id), characterId);
    if (!delivered) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Order not ready' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('wise-imports', 'order-delivered', { id: Number(id), characterId });
    hooks.dispatch('wise-imports.order.delivered', { id: Number(id), characterId });
    sendOk(res, { delivered: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_IMPORTS_DELIVER_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
