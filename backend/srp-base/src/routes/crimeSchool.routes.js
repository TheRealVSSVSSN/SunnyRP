const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  getProgress,
  updateProgress,
} = require('../repositories/crimeSchoolRepository');

const router = express.Router();

// GET /v1/crimeschool/:playerId - get progress for a player
router.get('/v1/crimeschool/:playerId', async (req, res) => {
  const { playerId } = req.params;
  try {
    const progress = await getProgress(playerId);
    sendOk(res, { progress }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CRIMESCHOOL_FETCH_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/crimeschool/:playerId - update progress for a player
router.post('/v1/crimeschool/:playerId', async (req, res) => {
  const { playerId } = req.params;
  const { stage } = req.body;
  if (!stage) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'stage is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const record = await updateProgress(playerId, stage);
    sendOk(res, { progress: record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CRIMESCHOOL_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;