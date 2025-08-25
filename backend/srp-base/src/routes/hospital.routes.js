const express = require('express');
const hospitalRepo = require('../repositories/hospitalRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/hospital/admissions/active
router.get('/v1/hospital/admissions/active', async (req, res) => {
  try {
    const admissions = await hospitalRepo.getActiveAdmissions();
    sendOk(res, { admissions }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch admissions' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/hospital/admissions
router.post('/v1/hospital/admissions', express.json(), async (req, res) => {
  const { characterId, reason, bed, notes } = req.body || {};
  if (!characterId || !reason) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'characterId and reason are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const admission = await hospitalRepo.createAdmission({ characterId, reason, bed, notes });
    sendOk(res, admission, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create admission' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/hospital/admissions/:id/discharge
router.post('/v1/hospital/admissions/:id/discharge', async (req, res) => {
  try {
    const admission = await hospitalRepo.dischargeAdmission(req.params.id);
    if (!admission) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Admission not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, admission, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to discharge admission' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
