const express = require('express');
const charRepo = require('../repositories/characterRepository');
const selectionRepo = require('../repositories/characterSelectionRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/accounts/:accountId/characters
router.get('/v1/accounts/:accountId/characters', async (req, res) => {
  const { accountId } = req.params;
  try {
    const characters = await charRepo.listByOwner(accountId);
    sendOk(res, { characters }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to list characters' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/accounts/:accountId/characters
router.post('/v1/accounts/:accountId/characters', express.json(), async (req, res) => {
  const { accountId } = req.params;
  const { first_name, last_name, dob, gender, phone_number, story } = req.body || {};
  if (!first_name || !last_name) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'first_name and last_name are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const created = await charRepo.create({
      owner_hex: accountId,
      first_name,
      last_name,
      dob,
      gender,
      phone_number,
      story,
    });
    sendOk(res, { character: created }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return sendError(res, { code: 'CONFLICT', message: 'Character name or phone already exists' }, 409, res.locals.requestId, res.locals.traceId);
    }
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create character' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/accounts/:accountId/characters/:characterId:select
router.post('/v1/accounts/:accountId/characters/:characterId:select', async (req, res) => {
  const { accountId, characterId } = req.params;
  try {
    const character = await charRepo.getById(parseInt(characterId, 10));
    if (!character || character.ownerHex !== accountId) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Character not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    await selectionRepo.setSelected(accountId, characterId);
    sendOk(res, { selected: Number(characterId) }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to select character' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// DELETE /v1/accounts/:accountId/characters/:characterId
router.delete('/v1/accounts/:accountId/characters/:characterId', async (req, res) => {
  const { accountId, characterId } = req.params;
  try {
    const removed = await charRepo.remove(parseInt(characterId, 10), accountId);
    if (!removed) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Character not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    const selected = await selectionRepo.getSelected(accountId);
    if (selected && Number(selected) === Number(characterId)) {
      await selectionRepo.clear(accountId);
    }
    sendOk(res, { deleted: true }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to delete character' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
