const express = require('express');
const { sendOk, sendError } = require('../utils/respond');

// Stub repository for bans.  In a real deployment bans should be
// persisted in a dedicated table with expiry and scope fields.
const bans = new Map();

const router = express.Router();

// POST /v1/admin/ban
// Body: { playerId: string, reason: string, until?: string }
router.post('/v1/admin/ban', express.json(), async (req, res) => {
  const { playerId, reason, until } = req.body || {};
  if (!playerId || !reason) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId and reason are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  bans.set(playerId, { reason, until: until || null });
  sendOk(res, { banned: true, reason, until: until || null }, res.locals.requestId, res.locals.traceId);
});

module.exports = router;