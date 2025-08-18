const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listBlips,
  createBlip,
  deleteBlip,
} = require('../repositories/blipsRepository');

const router = express.Router();

// GET /v1/blips - list active blips
router.get('/v1/blips', async (req, res) => {
  try {
    const blips = await listBlips();
    sendOk(res, { blips }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'BLIPS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/blips - create a new blip
router.post('/v1/blips', async (req, res) => {
  const { type, coords, createdBy, expiresAt } = req.body;
  if (!type || !coords) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'type and coords are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const blip = await createBlip(type, coords, createdBy || null, expiresAt || null);
    sendOk(res, { blip }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'BLIP_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/blips/:id - remove a blip
router.delete('/v1/blips/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await deleteBlip(id);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'BLIP_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;