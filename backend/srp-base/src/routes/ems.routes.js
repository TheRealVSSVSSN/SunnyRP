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

module.exports = router;