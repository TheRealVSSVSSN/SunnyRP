const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listOfficers,
  assignOfficer,
  updateOfficer,
  setDuty,
} = require('../repositories/policeRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// List all police officers
router.get('/v1/police/roster', async (req, res) => {
  try {
    const officers = await listOfficers();
    sendOk(res, { officers }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICERS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Assign a new officer
router.post('/v1/police/roster', async (req, res) => {
  const { characterId, rank, onDuty } = req.body;
  if (!characterId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const officer = await assignOfficer(characterId, rank || 'officer', onDuty ? 1 : 0);
    const mapped = {
      id: officer.id,
      characterId: officer.characterId,
      rank: officer.rank,
      onDuty: officer.onDuty,
    };
    websocket.broadcast('police', 'duty', { characterId: mapped.characterId, onDuty: mapped.onDuty });
    hooks.dispatch('police.duty', { characterId: mapped.characterId, onDuty: mapped.onDuty });
    sendOk(res, { officer: mapped }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICER_ASSIGN_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update officer rank
router.put('/v1/police/roster/:id', async (req, res) => {
  const { id } = req.params;
  const { rank } = req.body;
  if (!rank) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'rank required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const officer = await updateOfficer(id, rank);
    const mapped = {
      id: officer.id,
      characterId: officer.character_id,
      rank: officer.rank,
      onDuty: officer.on_duty,
      createdAt: officer.created_at,
      updatedAt: officer.updated_at,
    };
    sendOk(res, { officer: mapped }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICER_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Toggle duty status
router.post('/v1/police/roster/:characterId:duty', async (req, res) => {
  const { characterId } = req.params;
  const { onDuty } = req.body;
  if (onDuty === undefined) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'onDuty required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const officer = await setDuty(characterId, onDuty ? 1 : 0);
    const mapped = {
      id: officer.id,
      characterId: officer.character_id,
      rank: officer.rank,
      onDuty: officer.on_duty,
      createdAt: officer.created_at,
      updatedAt: officer.updated_at,
    };
    websocket.broadcast('police', 'duty', { characterId: mapped.characterId, onDuty: mapped.onDuty });
    hooks.dispatch('police.duty', { characterId: mapped.characterId, onDuty: mapped.onDuty });
    sendOk(res, { officer: mapped }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'OFFICER_DUTY_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;