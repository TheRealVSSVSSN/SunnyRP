const express = require('express');
const config = require('../config/env');
const { sendOk, sendError } = require('../utils/respond');
const logger = require('../utils/logger');

// Live configuration state.  Initially seeded from defaults in
// config.features and static world settings.  In a production
// deployment this would be persisted in the database and reloaded on
// startup.  Modules may subscribe to configuration changes via
// events (e.g. Redis pub/sub) but here we implement a simple in
// memory version.
let liveConfig = {
  features: { ...config.features },
  settings: {
    Time: { hour: 12, minute: 0, freeze: false },
    Weather: { type: 'EXTRASUNNY', dynamic: false },
  },
};

const router = express.Router();

/**
 * GET /v1/config/live
 * Returns the current live configuration including feature flags and
 * world settings.  Callers poll this endpoint and broadcast the
 * result to all clients.  The response is cached client‑side in Lua.
 */
router.get('/v1/config/live', (req, res) => {
  sendOk(res, liveConfig, res.locals.requestId, res.locals.traceId);
});

/**
 * POST /v1/config/live
 * Update the live configuration.  Requires the caller to be an
 * admin (enforcement left to upstream middleware or route guard).
 * Accepts a JSON body containing `features` and/or `settings`.  The
 * updated configuration is returned.
 */
router.post('/v1/config/live', express.json(), (req, res) => {
  const { features, settings } = req.body || {};
  if (!features && !settings) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'No features or settings provided' }, 400, res.locals.requestId, res.locals.traceId);
  }
  if (features) {
    liveConfig.features = { ...liveConfig.features, ...features };
  }
  if (settings) {
    liveConfig.settings = { ...liveConfig.settings, ...settings };
  }
  sendOk(res, liveConfig, res.locals.requestId, res.locals.traceId);
});

module.exports = router;