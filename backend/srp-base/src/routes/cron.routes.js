const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { getAllJobs, createJob } = require('../repositories/cronRepository');

const router = express.Router();

// List all cron jobs
router.get('/v1/cron/jobs', async (req, res) => {
  try {
    const jobs = await getAllJobs();
    sendOk(res, { jobs }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CRON_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create or replace a cron job
router.post('/v1/cron/jobs', async (req, res) => {
  const { name, schedule, payload, accountId, characterId, priority = 0, nextRun } = req.body;

  if (!name || typeof name !== 'string') {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name is required and must be a string' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!schedule || typeof schedule !== 'string') {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'schedule is required and must be a string' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!nextRun || typeof nextRun !== 'string') {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'nextRun is required and must be an ISO date string' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const prio = parseInt(priority, 10);
  if (Number.isNaN(prio)) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'priority must be a number' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const job = await createJob({
      name,
      schedule,
      payload: payload || null,
      accountId: accountId ?? null,
      characterId: characterId ?? null,
      priority: prio,
      nextRun,
    });
    sendOk(res, { job }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CRON_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
