const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listSecondaryJobs,
  createSecondaryJob,
  deleteSecondaryJobs,
} = require('../repositories/secondaryJobsRepository');

/**
 * Router for secondary job assignments.  A secondary job is an extra role
 * that a character can hold in addition to their primary job.  These
 * endpoints allow clients to list all secondary jobs for a character,
 * assign a new secondary job and remove all secondary jobs for a
 * character.  Validation errors and failures are returned in the
 * standard SRP error envelope.
 */
const router = express.Router();

// GET /v1/secondary-jobs
// Returns an array of secondary job records for the given playerId.
router.get('/v1/secondary-jobs', async (req, res) => {
  const { playerId } = req.query;
  if (!playerId || typeof playerId !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId query parameter is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const jobs = await listSecondaryJobs(playerId);
    sendOk(res, jobs, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'SECONDARY_JOBS_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/secondary-jobs
// Assign a new secondary job to a character.  Expects { playerId, job } in the
// JSON body and returns the inserted record ID on success.
router.post('/v1/secondary-jobs', async (req, res) => {
  const { playerId, job } = req.body || {};
  if (!playerId || typeof playerId !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!job || typeof job !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'job is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const id = await createSecondaryJob({ playerId, job });
    sendOk(res, { id }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'SECONDARY_JOB_CREATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// DELETE /v1/secondary-jobs
// Remove all secondary jobs for the given playerId.  Returns the number of
// deleted records.
router.delete('/v1/secondary-jobs', async (req, res) => {
  const { playerId } = req.query;
  if (!playerId || typeof playerId !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId query parameter is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const deleted = await deleteSecondaryJobs(playerId);
    sendOk(res, { deleted }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'SECONDARY_JOBS_DELETE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;