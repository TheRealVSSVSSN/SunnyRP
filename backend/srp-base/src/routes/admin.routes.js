const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { banPlayer } = require('../repositories/adminRepository');

const router = express.Router();

/**
 * Ban a player.
 *
 * Route: POST /v1/admin/ban
 * Body: { playerId: string, reason: string, until?: string }
 */
router.post('/v1/admin/ban', async (req, res) => {
  const { playerId, reason, until } = req.body || {};
  if (!playerId || typeof playerId !== 'string') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'playerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!reason || typeof reason !== 'string') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'reason is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  let untilDate = null;
  if (until) {
    const parsed = new Date(until);
    if (Number.isNaN(parsed.getTime())) {
      return sendError(
        res,
        { code: 'INVALID_INPUT', message: 'until must be a valid ISO 8601 date' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    untilDate = parsed;
  }
  try {
    await banPlayer(playerId, reason, untilDate);
    sendOk(
      res,
      { banned: true, reason, until: untilDate },
      res.locals.requestId,
      res.locals.traceId,
    );
  } catch (err) {
    sendError(
      res,
      { code: 'BAN_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
