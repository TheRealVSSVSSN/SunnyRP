const express = require('express');
const charRepo = require('../repositories/characterRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// Utility to generate a pseudo‑unique phone number.  In a real
// deployment phone numbers should follow a defined scheme and be
// guaranteed unique either via preallocation or database constraint.
function generatePhone() {
  const num = Math.floor(1000000 + Math.random() * 9000000);
  return `555${num}`;
}

// GET /v1/characters?owner_hex=...
router.get('/v1/characters', async (req, res) => {
  const ownerHex = req.query.owner_hex;
  if (!ownerHex) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'owner_hex query parameter is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const list = await charRepo.listByOwner(ownerHex);
  sendOk(res, list, res.locals.requestId, res.locals.traceId);
});

// POST /v1/characters
router.post('/v1/characters', express.json(), async (req, res) => {
  const {
    owner_hex,
    first_name,
    last_name,
    dob,
    gender,
    phone_number,
    story,
  } = req.body || {};
  if (!owner_hex || !first_name || !last_name) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'owner_hex, first_name and last_name are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const data = {
    owner_hex,
    first_name,
    last_name,
    dob,
    gender,
    phone_number: phone_number || generatePhone(),
    story,
  };
  try {
    const created = await charRepo.create(data);
    sendOk(res, created, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return sendError(res, { code: 'CONFLICT', message: 'Character name or phone already exists' }, 409, res.locals.requestId, res.locals.traceId);
    }
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create character' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/characters/:id
router.get('/v1/characters/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (Number.isNaN(id)) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'Invalid character id' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const character = await charRepo.getById(id);
  if (!character) {
    return sendError(res, { code: 'NOT_FOUND', message: 'Character not found' }, 404, res.locals.requestId, res.locals.traceId);
  }
  sendOk(res, character, res.locals.requestId, res.locals.traceId);
});

// PATCH /v1/characters/:id
router.patch('/v1/characters/:id', express.json(), async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (Number.isNaN(id)) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'Invalid character id' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const updates = req.body || {};
  if (Object.keys(updates).length === 0) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'No updates provided' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const updated = await charRepo.update(id, updates);
    if (!updated) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Character not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, updated, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return sendError(res, { code: 'CONFLICT', message: 'Name or phone conflict' }, 409, res.locals.requestId, res.locals.traceId);
    }
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to update character' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;