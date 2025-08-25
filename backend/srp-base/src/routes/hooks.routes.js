const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/hooks/endpoints', (req, res) => {
  const endpoints = hooks.list();
  sendOk(res, { endpoints }, res.locals.requestId, res.locals.traceId);
});

router.post('/v1/hooks/endpoints', (req, res) => {
  const { type, url, secret, enabled } = req.body || {};
  if (!type || !url) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'type and url are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const endpoint = hooks.register(type, url, secret, enabled !== false);
  sendOk(res, { endpoint }, res.locals.requestId, res.locals.traceId);
});

router.delete('/v1/hooks/endpoints/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  hooks.remove(id);
  sendOk(res, { removed: id }, res.locals.requestId, res.locals.traceId);
});

module.exports = router;
