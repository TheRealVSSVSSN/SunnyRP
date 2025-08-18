const express = require('express');
const permsRepo = require('../repositories/permissionsRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/permissions/:playerId
router.get('/v1/permissions/:playerId', async (req, res) => {
  const { playerId } = req.params;
  if (!playerId) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const scopes = await permsRepo.getPlayerScopes(playerId);
  sendOk(res, { scopes }, res.locals.requestId, res.locals.traceId);
});

// POST /v1/permissions/grant
router.post('/v1/permissions/grant', express.json(), async (req, res) => {
  const { playerId, scope } = req.body || {};
  if (!playerId || !scope) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId and scope are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const scopes = await permsRepo.grant(playerId, scope);
  sendOk(res, { scopes }, res.locals.requestId, res.locals.traceId);
});

// POST /v1/permissions/revoke
router.post('/v1/permissions/revoke', express.json(), async (req, res) => {
  const { playerId, scope } = req.body || {};
  if (!playerId || !scope) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId and scope are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const scopes = await permsRepo.revoke(playerId, scope);
  sendOk(res, { scopes }, res.locals.requestId, res.locals.traceId);
});

module.exports = router;