const express = require('express');
const emsRepo = require('../repositories/emsRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/ems/records
router.get('/v1/ems/records', async (req, res) => {
  try {
    const records = await emsRepo.getRecords();
    sendOk(res, records, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch records' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/ems/records/:id
router.get('/v1/ems/records/:id', async (req, res) => {
  try {
    const record = await emsRepo.getRecord(req.params.id);
    if (!record) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Record not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, record, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch record' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/ems/records
router.post('/v1/ems/records', express.json(), async (req, res) => {
  const { patient_id, doctor_id, treatment, status } = req.body || {};
  if (!patient_id || !doctor_id || !treatment) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'patient_id, doctor_id and treatment are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const record = await emsRepo.createRecord({ patient_id, doctor_id, treatment, status });
    sendOk(res, record, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create record' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/ems/records/:id
router.patch('/v1/ems/records/:id', express.json(), async (req, res) => {
  try {
    const record = await emsRepo.updateRecord(req.params.id, req.body || {});
    if (!record) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Record not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, record, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to update record' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/ems/records/:id
router.delete('/v1/ems/records/:id', async (req, res) => {
  try {
    const ok = await emsRepo.deleteRecord(req.params.id);
    if (!ok) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Record not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to delete record' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/ems/shifts/active
router.get('/v1/ems/shifts/active', async (req, res) => {
  try {
    const shifts = await emsRepo.getActiveShifts();
    sendOk(res, shifts, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to fetch active shifts' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/ems/shifts
router.post('/v1/ems/shifts', express.json(), async (req, res) => {
  const { characterId } = req.body || {};
  if (!characterId) {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'characterId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const shift = await emsRepo.startShift(characterId);
    sendOk(res, shift, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to start shift' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

// POST /v1/ems/shifts/:id/end
router.post('/v1/ems/shifts/:id/end', async (req, res) => {
  try {
    const shift = await emsRepo.endShift(req.params.id);
    if (!shift) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Shift not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    sendOk(res, shift, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'INTERNAL_ERROR', message: 'Failed to end shift' },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;
