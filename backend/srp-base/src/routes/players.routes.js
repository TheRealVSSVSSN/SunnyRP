const express = require('express');
const userRepo = require('../repositories/userRepository');
const permsRepo = require('../repositories/permissionsRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// POST /v1/players/link
// Body: { playerId: number, identifiers: [{type: string, value: string}] }
// Returns: { banned: boolean, banReason?: string, whitelisted: boolean, scopes: string[], user: object }
router.post('/v1/players/link', express.json(), async (req, res) => {
  const { playerId, identifiers } = req.body || {};
  if (!Array.isArray(identifiers) || identifiers.length === 0) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'identifiers array is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  // Determine canonical hex ID (prefer license, then steam, then discord)
  let hexId;
  let name = null;
  for (const id of identifiers) {
    if (id.type === 'license' && !hexId) {
      hexId = id.value;
    }
    if (id.type === 'steam' && !hexId) {
      hexId = id.value;
    }
    if (id.type === 'name') {
      name = id.value;
    }
  }
  if (!hexId) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'A license or steam identifier is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  // Ensure user exists
  let user = await userRepo.get(hexId);
  if (!user) {
    // Fall back to a generic name if none provided
    const userName = name || `Player ${hexId.slice(-4)}`;
    try {
      user = await userRepo.create({ hex_id: hexId, name: userName, identifiers });
    } catch (err) {
      // If another request created the user concurrently, fetch it now
      user = await userRepo.get(hexId);
    }
  }
  // Determine ban and whitelist status (stubbed to defaults)
  const banned = false;
  const banReason = null;
  const whitelisted = true;
  // Fetch scopes for this player
  const scopes = await permsRepo.getPlayerScopes(hexId);
  const result = { banned, banReason, whitelisted, scopes, user };
  sendOk(res, result, res.locals.requestId, res.locals.traceId);
});

module.exports = router;