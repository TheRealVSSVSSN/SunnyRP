const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  banPlayer,
  setNoclip,
  unbanPlayer,
  isPlayerBanned,
} = require('../repositories/adminRepository');
const permissionsRepo = require('../repositories/permissionsRepository');
const websocket = require('../realtime/websocket');

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
    if (websocket) websocket.broadcast('admin', 'ban.added', { playerId, reason, until: untilDate });
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

/**
 * Toggle noclip for a player. Only players with admin or dev scope may receive noclip.
 *
 * Route: POST /v1/admin/noclip
 * Body: { playerId: string, actorId: string, enabled: boolean }
 */
router.post('/v1/admin/noclip', async (req, res) => {
  const { playerId, actorId, enabled } = req.body || {};
  if (!playerId || typeof playerId !== 'string') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'playerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!actorId || typeof actorId !== 'string') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'actorId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (typeof enabled !== 'boolean') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'enabled must be boolean' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const scopes = await permissionsRepo.getPlayerScopes(playerId);
    if (!scopes.includes('admin') && !scopes.includes('dev')) {
      return sendError(
        res,
        { code: 'FORBIDDEN', message: 'Player lacks noclip permission' },
        403,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    await setNoclip(playerId, actorId, enabled);
    if (websocket) websocket.broadcast(`player:${playerId}`, 'admin.noclip', { enabled });
    sendOk(
      res,
      { playerId, enabled },
      res.locals.requestId,
      res.locals.traceId,
    );
  } catch (err) {
    sendError(
      res,
      { code: 'NOCLIP_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

/**
 * Unban a player and log the action.
 *
 * Route: POST /v1/admin/unban
 * Body: { playerId: string, actorId: string, reason: string }
 */
router.post('/v1/admin/unban', async (req, res) => {
  const { playerId, actorId, reason } = req.body || {};
  if (!playerId || typeof playerId !== 'string') {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!actorId || typeof actorId !== 'string') {
    return sendError(res, { code: 'INVALID_INPUT', message: 'actorId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (!reason || typeof reason !== 'string') {
    return sendError(res, { code: 'INVALID_INPUT', message: 'reason is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    await unbanPlayer(playerId, actorId, reason);
    if (websocket) websocket.broadcast('admin', 'ban.removed', { playerId, reason, actorId });
    sendOk(res, { unbanned: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'UNBAN_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

/**
 * Check if a player is currently banned.
 *
 * Route: GET /v1/admin/bans/{playerId}
 */
router.get('/v1/admin/bans/:playerId', async (req, res) => {
  const { playerId } = req.params;
  try {
    const info = await isPlayerBanned(playerId);
    sendOk(res, info, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'BAN_STATUS_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
