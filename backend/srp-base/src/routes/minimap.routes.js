const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { listBlips, createBlip, deleteBlip } = require('../repositories/minimapRepository');

const router = express.Router();

// GET /v1/minimap/blips - list all blips
router.get('/v1/minimap/blips', async (req, res) => {
  try {
    const blips = await listBlips();
    sendOk(res, { blips }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'MINIMAP_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/minimap/blips - create a blip
router.post('/v1/minimap/blips', async (req, res) => {
  const { x, y, z, sprite, color, label } = req.body;
  if ([x, y, z, sprite, color, label].some((v) => v === undefined)) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'x, y, z, sprite, color and label are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const blip = await createBlip({ x, y, z, sprite, color, label });
    sendOk(res, { blip }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'MINIMAP_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/minimap/blips/:id - remove a blip
router.delete('/v1/minimap/blips/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await deleteBlip(id);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'MINIMAP_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
