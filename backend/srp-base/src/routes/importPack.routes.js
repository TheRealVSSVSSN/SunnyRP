const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/importPackRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/import-pack/orders/character/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const orders = await repo.listOrdersByCharacter(characterId);
    sendOk(res, { orders }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.get('/v1/import-pack/orders/:id', async (req, res) => {
  const { id } = req.params;
  const { characterId } = req.query;
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
    const order = await repo.getOrder(Number(id), characterId);
    if (!order) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Order not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    sendOk(res, { order }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_GET_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/import-pack/orders', async (req, res) => {
  if (!req.get('X-Idempotency-Key')) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const { characterId, package: packageName, price } = req.body || {};
  if (!characterId || !packageName || typeof price !== 'number') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, package, and numeric price are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const order = await repo.createOrder({ characterId, packageName, price });
    websocket.broadcast('import-pack', 'order.created', order);
    hooks.dispatch('import-pack.order.created', order);
    sendOk(res, { order }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/import-pack/orders/:id/deliver', async (req, res) => {
  if (!req.get('X-Idempotency-Key')) {
    return sendError(
      res,
      { code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'X-Idempotency-Key header is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const { id } = req.params;
    const updated = await repo.markDelivered(Number(id));
    if (!updated) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Order not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('import-pack', 'order.delivered', { id: Number(id) });
    hooks.dispatch('import-pack.order.delivered', { id: Number(id) });
    sendOk(res, { delivered: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_DELIVER_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/import-pack/orders/:id/cancel', async (req, res) => {
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
    const canceled = await repo.cancelOrder(Number(id), characterId);
    if (!canceled) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Order not found or not pending' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('import-pack', 'order.canceled', { id: Number(id), characterId });
    hooks.dispatch('import-pack.order.canceled', { id: Number(id), characterId });
    sendOk(res, { canceled: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_CANCEL_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
