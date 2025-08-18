const express = require('express');
const db = require('../repositories/db');
const config = require('../config/env');
const logger = require('../utils/logger');
const { sendOk } = require('../utils/respond');

const router = express.Router();

// Liveness probe.  Always returns 200 if the process is up.
router.get('/v1/healthz', (req, res) => {
  sendOk(res, { status: 'ok' }, res.locals.requestId, res.locals.traceId);
});

// Readiness probe.  Checks database connectivity.  In a clustered
// deployment additional checks (e.g. Redis) can be added.  Returns
// 503 if the DB check fails.
router.get('/v1/ready', async (req, res) => {
  try {
    await db.query('SELECT 1');
    sendOk(res, { ready: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    logger.error({ err }, 'readiness check failed');
    res.status(503).json({ ok: false, error: { code: 'FAILED_PRECONDITION', message: 'Database unreachable' }, requestId: res.locals.requestId, traceId: res.locals.traceId });
  }
});

// Prometheus metrics endpoint.  Enabled only when configured.  When
// disabled returns 404 to avoid exposing internals.
router.get('/metrics', async (req, res) => {
  if (!config.enableMetrics) {
    return res.status(404).end();
  }
  try {
    const client = require('prom-client');
    res.set('Content-Type', client.register.contentType);
    const metrics = await client.register.metrics();
    res.end(metrics);
  } catch (err) {
    res.status(500).end();
  }
});

module.exports = router;