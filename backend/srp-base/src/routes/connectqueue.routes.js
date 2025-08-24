const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { listPriorities, upsertPriority, removePriority } = require('../repositories/connectqueueRepository');
const { createRateLimiter } = require('../middleware/rateLimit');

const router = express.Router();

// Limit queue priority modifications/listing to 30 requests per minute per IP
const queueLimiter = createRateLimiter({ windowMs: 60_000, max: 30 });
router.use('/v1/connectqueue/priorities', queueLimiter);

// GET /v1/connectqueue/priorities?accountId=1&limit=10
router.get('/v1/connectqueue/priorities', async (req, res) => {
  try {
    const { accountId, limit } = req.query;
    let accountNum;
    if (accountId !== undefined) {
      accountNum = parseInt(accountId, 10);
      if (Number.isNaN(accountNum)) {
        return sendError(
          res,
          { code: 'VALIDATION_ERROR', message: 'accountId must be an integer' },
          400,
          res.locals.requestId,
          res.locals.traceId,
        );
      }
    }
    const limitNum = limit ? parseInt(limit, 10) : 50;
    const rows = await listPriorities(accountNum, Number.isNaN(limitNum) ? 50 : limitNum);
    sendOk(res, { priorities: rows }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'QUEUE_PRIORITY_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/connectqueue/priorities
router.post('/v1/connectqueue/priorities', async (req, res) => {
  const { accountId, priority, reason, expiresAt } = req.body || {};
  const accountNum = parseInt(accountId, 10);
  const priorityNum = parseInt(priority, 10);
  if (Number.isNaN(accountNum) || Number.isNaN(priorityNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'accountId and priority are required integers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  let expiresDate = null;
  if (expiresAt) {
    const d = new Date(expiresAt);
    if (Number.isNaN(d.getTime())) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'expiresAt must be a valid date-time' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    expiresDate = d;
  }
  try {
    const priorityRow = await upsertPriority({ accountId: accountNum, priority: priorityNum, reason, expiresAt: expiresDate });
    sendOk(res, { priority: priorityRow }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'QUEUE_PRIORITY_UPSERT_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/connectqueue/priorities/:accountId
router.delete('/v1/connectqueue/priorities/:accountId', async (req, res) => {
  const { accountId } = req.params;
  const accountNum = parseInt(accountId, 10);
  if (Number.isNaN(accountNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'accountId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await removePriority(accountNum);
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'QUEUE_PRIORITY_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
