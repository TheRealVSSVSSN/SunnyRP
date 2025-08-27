const express = require('express');
const hospitalRepo = require('../repositories/hospitalRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');
const { sendOk } = require('../utils/respond');

const router = express.Router();

// GET /v1/hospital/admissions/active
router.get('/v1/hospital/admissions/active', async (req, res, next) => {
  try {
    const admissions = await hospitalRepo.getActiveAdmissions();
    sendOk(res, { admissions }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// POST /v1/hospital/admissions
router.post('/v1/hospital/admissions', async (req, res, next) => {
  try {
    const { characterId, reason, bed, notes } = req.body || {};
    if (!characterId || !reason) {
      return res.status(400).json({
        ok: false,
        error: { code: 'INVALID_INPUT', message: 'characterId and reason are required' },
        requestId: res.locals.requestId,
        traceId: res.locals.traceId,
      });
    }
    const admission = await hospitalRepo.createAdmission({ characterId, reason, bed, notes });
    sendOk(res, admission, res.locals.requestId, res.locals.traceId);
    websocket.broadcast('hospital', 'admission.created', admission);
    dispatcher.dispatch('hospital.admission.created', admission);
  } catch (err) {
    next(err);
  }
});

// POST /v1/hospital/admissions/:id/discharge
router.post('/v1/hospital/admissions/:id/discharge', async (req, res, next) => {
  try {
    const admission = await hospitalRepo.dischargeAdmission(req.params.id);
    if (!admission) {
      return res.status(404).json({
        ok: false,
        error: { code: 'NOT_FOUND', message: 'Admission not found' },
        requestId: res.locals.requestId,
        traceId: res.locals.traceId,
      });
    }
    sendOk(res, admission, res.locals.requestId, res.locals.traceId);
    websocket.broadcast('hospital', 'admission.discharged', admission);
    dispatcher.dispatch('hospital.admission.discharged', admission);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
