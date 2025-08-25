const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/importPackRepository');

const router = express.Router();

router.get('/v1/import-pack/orders/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const orders = await repo.listOrdersByCharacter(characterId);
    sendOk(res, { orders }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/import-pack/orders', async (req, res) => {
  const { characterId, package: packageName } = req.body || {};
  if (!characterId || !packageName) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and package are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const order = await repo.createOrder({ characterId, packageName });
    sendOk(res, { order }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/import-pack/orders/:id/deliver', async (req, res) => {
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
    sendOk(res, { delivered: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'IMPORT_PACK_DELIVER_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
