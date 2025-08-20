const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  getPlayerAmmo,
  updatePlayerAmmo,
} = require('../repositories/ammoRepository');

const router = express.Router();

/**
 * List a player's ammunition counts.
 *
 * Route: GET /v1/players/:playerId/ammo
 *
 * Returns a map of weapon types to ammo counts for the specified
 * player.  If the player has no ammo recorded, an empty object is
 * returned.  Does not require body content.
 */
router.get('/v1/players/:playerId/ammo', async (req, res) => {
  const { playerId } = req.params;
  if (!playerId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const ammo = await getPlayerAmmo(playerId);
    sendOk(res, { ammo }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'AMMO_LIST_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

/**
 * Update ammunition count for a specific weapon type.
 *
 * Route: PATCH /v1/players/:playerId/ammo
 *
 * Accepts a JSON body containing `weaponType` (string) and `ammo`
 * (integer).  Validates input and updates the player's ammo count for
 * that weapon.  Returns the player's updated ammo map.  Requires
 * authentication and idempotency via middleware.
 */
router.patch('/v1/players/:playerId/ammo', async (req, res) => {
  const { playerId } = req.params;
  const { weaponType, ammo } = req.body;
  if (!playerId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (!weaponType || typeof weaponType !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'weaponType must be provided as a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const ammoInt = parseInt(ammo, 10);
  if (Number.isNaN(ammoInt) || ammoInt < 0) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'ammo must be a non‑negative integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const updatedAmmo = await updatePlayerAmmo(playerId, weaponType, ammoInt);
    sendOk(res, { ammo: updatedAmmo }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(
      res,
      { code: 'AMMO_UPDATE_FAILED', message: err.message },
      500,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
});

module.exports = router;