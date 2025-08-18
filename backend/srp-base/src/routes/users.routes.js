const express = require('express');
const userRepo = require('../repositories/userRepository');
const { sendOk, sendError } = require('../utils/respond');

const router = express.Router();

// GET /v1/users/exists?hex_id=...
router.get('/v1/users/exists', async (req, res) => {
  const hex = req.query.hex_id;
  if (!hex) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'Missing hex_id' }, 400, res.locals.requestId, res.locals.traceId);
  }
  const exists = await userRepo.exists(hex);
  sendOk(res, { exists }, res.locals.requestId, res.locals.traceId);
});

// POST /v1/users
router.post('/v1/users', express.json(), async (req, res) => {
  const body = req.body || {};
  const { hex_id, name, identifiers } = body;
  if (!hex_id || !name) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'hex_id and name are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const created = await userRepo.create({ hex_id, name, identifiers });
    sendOk(res, created, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    // Duplicate key
    if (err && err.code === 'ER_DUP_ENTRY') {
      return sendError(res, { code: 'CONFLICT', message: 'User already exists' }, 409, res.locals.requestId, res.locals.traceId);
    }
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create user' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/users/:hex_id
router.get('/v1/users/:hexId', async (req, res) => {
  const { hexId } = req.params;
  const user = await userRepo.get(hexId);
  if (!user) {
    return sendError(res, { code: 'NOT_FOUND', message: 'User not found' }, 404, res.locals.requestId, res.locals.traceId);
  }
  sendOk(res, user, res.locals.requestId, res.locals.traceId);
});

module.exports = router;