const express = require('express');
const outboxRepo = require('../repositories/outboxRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// POST /v1/outbox/enqueue
// Body: { topic: string, payload: object }
router.post('/v1/outbox/enqueue', express.json(), async (req, res) => {
  const { topic, payload } = req.body || {};
  if (!topic || typeof topic !== 'string' || !payload) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'topic and payload are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const id = await outboxRepo.enqueue(topic, payload);
    sendOk(res, { id }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to enqueue event' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;