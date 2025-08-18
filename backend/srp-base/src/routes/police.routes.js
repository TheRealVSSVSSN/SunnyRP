const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listOfficers,
  assignOfficer,
  updateOfficer,
} = require('../repositories/policeRepository');

const router = express.Router();

// List all police officers
router.get('/v1/police/officers', async (req, res) => {
  try {
    const officers = await listOfficers();
    sendOk(res, { officers }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICERS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Assign a new officer
router.post('/v1/police/officers', async (req, res) => {
  const { playerId, rank, onDuty } = req.body;
  if (!playerId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'playerId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const officer = await assignOfficer(playerId, rank || 'officer', onDuty ? 1 : 0);
    sendOk(res, { officer }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICER_ASSIGN_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update officer rank or duty status
router.put('/v1/police/officers/:id', async (req, res) => {
  const { id } = req.params;
  const { rank, onDuty } = req.body;
  if (rank === undefined && onDuty === undefined) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'rank or onDuty required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const officer = await updateOfficer(id, { rank, onDuty });
    sendOk(res, { officer }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICER_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;