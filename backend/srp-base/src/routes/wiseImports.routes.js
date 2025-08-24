const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/wiseImportsRepository');

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
    sendOk(res, { order }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'WISE_IMPORTS_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
