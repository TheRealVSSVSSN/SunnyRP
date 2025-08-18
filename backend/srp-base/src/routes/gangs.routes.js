const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listGangs,
  createGang,
  updateGang,
  addMember,
  removeMember,
} = require('../repositories/gangsRepository');

const router = express.Router();

// List all gangs
router.get('/v1/gangs', async (req, res) => {
  try {
    const gangs = await listGangs();
    sendOk(res, { gangs }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GANGS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a new gang
router.post('/v1/gangs', async (req, res) => {
  const { name } = req.body;
  if (!name) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const gang = await createGang(name);
    sendOk(res, { gang }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GANG_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update a gang's name
router.put('/v1/gangs/:id', async (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  if (!name) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const gang = await updateGang(id, name);
    sendOk(res, { gang }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GANG_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Add a member to a gang
router.post('/v1/gangs/:gangId/members', async (req, res) => {
  const { gangId } = req.params;
  const { playerId, role } = req.body;
  if (!playerId) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'playerId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const member = await addMember(gangId, playerId, role || 'member');
    sendOk(res, { member }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GANG_ADD_MEMBER_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Remove a member from a gang
router.delete('/v1/gangs/:gangId/members/:playerId', async (req, res) => {
  const { gangId, playerId } = req.params;
  try {
    await removeMember(gangId, playerId);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'GANG_REMOVE_MEMBER_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;