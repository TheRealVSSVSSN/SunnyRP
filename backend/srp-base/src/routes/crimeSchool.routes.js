const express = require('express');
const { sendOk } = require('../utils/respond');
const crimeSchoolRepo = require('../repositories/crimeSchoolRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// GET /v1/crime-school/:characterId - get progress for a character
router.get('/v1/crime-school/:characterId', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const progress = await crimeSchoolRepo.getProgress(parseInt(characterId, 10));
    sendOk(res, { progress }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// POST /v1/crime-school/:characterId - update progress for a character
router.post('/v1/crime-school/:characterId', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const { stage } = req.body || {};
    if (!stage) {
      return res.status(400).json({ ok: false, error: { code: 'INVALID_INPUT', message: 'stage is required' }, requestId: res.locals.requestId, traceId: res.locals.traceId });
    }
    const record = await crimeSchoolRepo.updateProgress(parseInt(characterId, 10), stage);
    const payload = { characterId: parseInt(characterId, 10), stage: record.stage };
    websocket.broadcast('crime-school', 'progress.updated', payload);
    hooks.dispatch('crime-school.progress.updated', payload);
    sendOk(res, { progress: record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
