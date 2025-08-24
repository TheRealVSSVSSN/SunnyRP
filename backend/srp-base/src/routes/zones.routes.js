const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listZones,
  createZone,
  deleteZone,
} = require('../repositories/zonesRepository');

const router = express.Router();

// GET /v1/zones - list defined zones
router.get('/v1/zones', async (req, res) => {
  try {
    const zones = await listZones();
    sendOk(res, { zones }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'ZONES_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/zones - create a new zone
router.post('/v1/zones', async (req, res) => {
  const { name, type, data, createdBy } = req.body;
  if (!name || !type || !data) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'name, type and data are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const zone = await createZone(name, type, data, createdBy || null);
    sendOk(res, { zone }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'ZONE_CREATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// DELETE /v1/zones/:id - remove a zone
router.delete('/v1/zones/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await deleteZone(id);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'ZONE_DELETE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
