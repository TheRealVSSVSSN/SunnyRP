const express = require('express');
const emsRepo = require('../repositories/emsRepository');
const { sendOk, sendError } = require('../utils/respond');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

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
    if (websocket) websocket.broadcast('ems', 'record.created', record);
    dispatcher.dispatch('ems.record.created', record);
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
    if (websocket) websocket.broadcast('ems', 'record.updated', record);
    dispatcher.dispatch('ems.record.updated', record);
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
    if (websocket) websocket.broadcast('ems', 'record.deleted', { id: req.params.id });
    dispatcher.dispatch('ems.record.deleted', { id: req.params.id });
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
    if (websocket) websocket.broadcast('ems', 'shift.started', shift);
    dispatcher.dispatch('ems.shift.started', shift);
    const active = await emsRepo.getActiveShifts();
    if (websocket) websocket.broadcast('ems', 'shifts.active', active);
    dispatcher.dispatch('ems.shifts.active', active);
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
    if (websocket) websocket.broadcast('ems', 'shift.ended', shift);
    dispatcher.dispatch('ems.shift.ended', shift);
    const active = await emsRepo.getActiveShifts();
    if (websocket) websocket.broadcast('ems', 'shifts.active', active);
    dispatcher.dispatch('ems.shifts.active', active);
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

const spawnLimiter = createRateLimiter({ windowMs: 60000, max: 5, errorCode: 'RATE_LIMIT', message: 'Too many spawns' });
router.post('/v1/ems/vehicles', spawnLimiter, express.json(), async (req, res) => {
  const { characterId, vehicleType } = req.body || {};
  if (!characterId || !vehicleType) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'characterId and vehicleType are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const assignments = await jobsRepo.getCharacterJobs(characterId);
    if (!assignments.some((j) => j.name === 'ems')) {
      return sendError(res, { code: 'FORBIDDEN', message: 'Character not assigned to EMS' }, 403, res.locals.requestId, res.locals.traceId);
    }
    const record = await emsVehiclesRepo.logSpawn(characterId, vehicleType);
    if (websocket) websocket.broadcast('ems', 'vehicle.spawn', record);
    dispatcher.dispatch('ems.vehicle.spawn', record);
    sendOk(res, record, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to spawn vehicle' }, 500, res.locals.requestId, res.locals.traceId);
  }
});
module.exports = router;
