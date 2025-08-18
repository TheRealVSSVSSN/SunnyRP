const express = require('express');
const weaponsRepo = require('../repositories/weaponsRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Routes for managing weapon definitions, attachments and player
 * weapons.  These endpoints allow creation of weapons and
 * attachments, listing them, and assigning weapons to players.
 */

const router = express.Router();

// GET /v1/weapons - list all weapon definitions
router.get('/v1/weapons', async (req, res) => {
  try {
    const weapons = await weaponsRepo.getAllWeapons();
    sendOk(res, { weapons }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch weapons' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/weapons - create a new weapon definition
router.post('/v1/weapons', express.json(), async (req, res) => {
  const { name, label, class: className } = req.body || {};
  if (!name) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const weapon = await weaponsRepo.createWeapon({ name, label, className });
    sendOk(res, { weapon }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create weapon' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/weapons/:id - fetch a weapon definition
router.get('/v1/weapons/:id', async (req, res) => {
  const id = Number(req.params.id);
  try {
    const weapon = await weaponsRepo.getWeapon(id);
    if (!weapon) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Weapon not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { weapon }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch weapon' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/weapons/:id/attachments - list attachments for a weapon
router.get('/v1/weapons/:id/attachments', async (req, res) => {
  const id = Number(req.params.id);
  try {
    const attachments = await weaponsRepo.getAttachments(id);
    sendOk(res, { attachments }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch attachments' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/weapons/:id/attachments - create a new attachment
router.post('/v1/weapons/:id/attachments', express.json(), async (req, res) => {
  const id = Number(req.params.id);
  const { attachmentName, label } = req.body || {};
  if (!attachmentName) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'attachmentName is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const attachment = await weaponsRepo.addAttachment(id, { attachmentName, label });
    sendOk(res, { attachment }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create attachment' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/players/:playerId/weapons - list a player's weapons
router.get('/v1/players/:playerId/weapons', async (req, res) => {
  const { playerId } = req.params;
  try {
    const weapons = await weaponsRepo.getPlayerWeapons(playerId);
    sendOk(res, { weapons }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch player weapons' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/players/:playerId/weapons - assign a weapon to a player
router.post('/v1/players/:playerId/weapons', express.json(), async (req, res) => {
  const { playerId } = req.params;
  const { weaponId, serial, modifiers } = req.body || {};
  if (!weaponId) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'weaponId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const weapon = await weaponsRepo.addPlayerWeapon(playerId, { weaponId, serial, modifiers });
    sendOk(res, { weapon }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to assign weapon' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;