const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { getInterior, setInterior } = require('../repositories/interiorsRepository');

const router = express.Router();

// Get interior for an apartment scoped to character
router.get('/v1/apartments/:apartmentId/interior', async (req, res) => {
  const { apartmentId } = req.params;
  const { characterId } = req.query;
  const aid = parseInt(apartmentId, 10);
  const cid = parseInt(characterId, 10);
  if (Number.isNaN(aid) || Number.isNaN(cid)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'apartmentId and characterId must be integers' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const interior = await getInterior(aid, cid);
    if (!interior) {
      return sendError(res, { code: 'INTERIOR_NOT_FOUND', message: 'No interior found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { interior }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERIOR_FETCH_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Save interior for an apartment scoped to character
router.post('/v1/apartments/:apartmentId/interior', async (req, res) => {
  const { apartmentId } = req.params;
  const { characterId, template } = req.body || {};
  const aid = parseInt(apartmentId, 10);
  const cid = parseInt(characterId, 10);
  if (Number.isNaN(aid) || Number.isNaN(cid) || !template) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'apartmentId and characterId must be integers and template required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const interior = await setInterior(aid, cid, template);
    sendOk(res, { interior }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERIOR_SAVE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
