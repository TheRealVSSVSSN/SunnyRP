const express = require('express');
const jobsRepo = require('../repositories/jobsRepository');
const broadcastRepo = require('../repositories/broadcastRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const { sendOk, sendError } = require('../utils/respond');

// Maximum number of characters allowed to hold the broadcaster job at the
// same time.  Defaults to 5 but can be overridden with the
// MAX_BROADCASTERS environment variable.  When the limit is reached
// additional attempts will be rejected.
const MAX_BROADCASTERS = Number.parseInt(process.env.MAX_BROADCASTERS, 10) || 5;

/**
 * Routes for managing broadcaster roles. The original resource allowed
 * players to become broadcasters if there were fewer than a set number
 * of active broadcasters. This endpoint counts current 'broadcaster'
 * assignments and, if below the configured limit, assigns the job to
 * the requesting player using the jobs repository. Duty status is not
 * toggled; callers may handle it separately.
 */
const router = express.Router();

/**
 * POST /v1/broadcast/attempt
 *
 * Body: { characterId: number }
 *
 * Attempts to assign the 'broadcaster' job to the given character.  If
 * the maximum number of broadcasters has been reached, an error is
 * returned.  On success the assigned job record is returned.
 */
router.post('/attempt', async (req, res, next) => {
  try {
    const { characterId } = req.body || {};
    if (characterId === undefined) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'characterId is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    // Determine how many characters currently have the broadcaster job
    const count = await jobsRepo.countCharactersForJob('broadcaster');
    if (count >= MAX_BROADCASTERS) {
      return sendError(
        res,
        { code: 'LIMIT_REACHED', message: 'There are already too many broadcasters' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    // Look up the broadcaster job.  If it doesn't exist, return an error.
    const job = await jobsRepo.getJobByName('broadcaster');
    if (!job) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'broadcaster job is not defined' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    // Assign the job to the character (on_duty will be false).  If the
    // assignment already exists it will update the record.
    const assignment = await jobsRepo.assignJob(parseInt(characterId, 10), job.id);
    sendOk(res, assignment, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

/**
 * GET /v1/broadcast/messages
 *
 * Query: ?limit=50
 *
 * Lists recent broadcast messages ordered from newest to oldest.  The
 * limit parameter caps the number of returned records (default 50,
 * maximum 100).
 */
router.get('/messages', async (req, res, next) => {
  try {
    const limit = Math.max(1, Math.min(100, parseInt(req.query.limit, 10) || 50));
    const messages = await broadcastRepo.getRecentMessages(limit);
    sendOk(res, { messages }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

/**
 * POST /v1/broadcast/messages
 *
 * Body: { characterId: number, message: string }
 *
 * Persists a broadcast message and pushes it via WebSocket and webhook
 * sinks.  Clients must supply an idempotency key.
 */
router.post('/messages', async (req, res, next) => {
  try {
    const { characterId, message } = req.body || {};
    if (characterId === undefined || typeof message !== 'string' || message.length === 0) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'characterId and message are required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const record = await broadcastRepo.createMessage({
    characterId: parseInt(characterId, 10),
    message: message.slice(0, 255),
    });
    websocket.broadcast('broadcast', 'message', record);
    hooks.dispatch('broadcast.message', record);
    sendOk(res, record, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
