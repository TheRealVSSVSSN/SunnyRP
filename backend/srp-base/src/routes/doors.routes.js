const express = require('express');
const doorsRepo = require('../repositories/doorsRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Routes for managing door state.  Doors can be created or
 * updated with POST /v1/doors and their locked state can be
 * toggled with PATCH /v1/doors/:doorId/state.  Listing all doors
 * is available via GET /v1/doors.  Clients should use these
 * endpoints to synchronise door state across the server and
 * persist changes between restarts.
 */

const router = express.Router();

// GET /v1/doors - return all doors
router.get('/v1/doors', async (req, res) => {
  try {
    const doors = await doorsRepo.getAll();
    sendOk(res, { doors }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch doors' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/doors - create or update a door
router.post('/v1/doors', express.json(), async (req, res) => {
  const { doorId, name, locked, position, heading } = req.body || {};
  if (!doorId) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'doorId is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const door = await doorsRepo.createOrUpdate({ doorId, name, locked, position, heading });
    sendOk(res, { door }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to save door' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// PATCH /v1/doors/:doorId/state - toggle locked state
router.patch('/v1/doors/:doorId/state', express.json(), async (req, res) => {
  const { doorId } = req.params;
  const { locked } = req.body || {};
  if (typeof locked !== 'boolean') {
    return sendError(res, { code: 'INVALID_INPUT', message: 'locked boolean is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const door = await doorsRepo.setState(doorId, locked);
    sendOk(res, { door }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to update door state' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;