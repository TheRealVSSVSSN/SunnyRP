const express = require('express');
const jobsRepo = require('../repositories/jobsRepository');
const { sendOk, sendError } = require('../utils/respond');

// Maximum number of players allowed to hold the broadcaster job at the
// same time.  Defaults to 5 but can be overridden with the
// MAX_BROADCASTERS environment variable.  When the limit is reached
// additional attempts will be rejected.
const MAX_BROADCASTERS = Number.parseInt(process.env.MAX_BROADCASTERS, 10) || 5;

/**
 * Routes for managing broadcaster roles.  legacy's broadcaster
 * resource allows players to become a broadcaster if there are fewer
 * than a set number of active broadcasters.  This endpoint
 * implements similar logic on the server-side.  It counts the
 * current assignments of the 'broadcaster' job and, if below the
 * configured limit, assigns the job to the requesting player.  The
 * assignment uses the existing jobs repository and does not toggle
 * duty; additional logic to set on-duty status can be added by
 * callers.
 */
const router = express.Router();

/**
 * POST /v1/broadcast/attempt
 *
 * Body: { playerId: string }
 *
 * Attempts to assign the 'broadcaster' job to the given player.  If
 * the maximum number of broadcasters has been reached, an error is
 * returned.  On success the assigned job record is returned.
 */
router.post('/v1/broadcast/attempt', express.json(), async (req, res, next) => {
  try {
    const { playerId } = req.body || {};
    if (!playerId) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'playerId is required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    // Determine how many players currently have the broadcaster job
    const count = await jobsRepo.countPlayersForJob('broadcaster');
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
    // Assign the job to the player (on_duty will be false).  If the
    // assignment already exists it will update the record.
    const assignment = await jobsRepo.assignJob(playerId, job.id);
    sendOk(res, assignment, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;