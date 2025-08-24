const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listApartments,
  createApartment,
  assignResident,
  vacateResident,
} = require('../repositories/apartmentsRepository');

const router = express.Router();

// List apartments, optionally filter by character
router.get('/v1/apartments', async (req, res) => {
  const { characterId } = req.query;
  let cid = null;
  if (characterId !== undefined) {
    cid = parseInt(characterId, 10);
    if (Number.isNaN(cid)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
  }
  try {
    const apartments = await listApartments(cid);
    sendOk(res, { apartments }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'APARTMENTS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a new apartment
router.post('/v1/apartments', async (req, res) => {
  const { name, location, price } = req.body || {};
  if (!name) {
    return sendError(res, { code: 'VALIDATION_ERROR', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const apt = await createApartment(name, location || null, price || 0);
    sendOk(res, { apartment: apt }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'APARTMENT_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Assign a resident to an apartment
router.post('/v1/apartments/:apartmentId/residents', async (req, res) => {
  const { apartmentId } = req.params;
  const { characterId } = req.body || {};
  const cid = parseInt(characterId, 10);
  if (!characterId || Number.isNaN(cid)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId is required and must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const record = await assignResident(apartmentId, cid);
    sendOk(res, { record }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'APARTMENT_ASSIGN_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Remove a resident from an apartment
router.delete('/v1/apartments/:apartmentId/residents/:characterId', async (req, res) => {
  const { apartmentId, characterId } = req.params;
  const cid = parseInt(characterId, 10);
  if (Number.isNaN(cid)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId must be an integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await vacateResident(apartmentId, cid);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'APARTMENT_VACATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
