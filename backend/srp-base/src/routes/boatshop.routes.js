const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const boatshopRepo = require('../repositories/boatshopRepository');

const router = express.Router();

// List boats available for purchase
router.get('/v1/boatshop', async (req, res, next) => {
  try {
    const boats = await boatshopRepo.listBoats();
    sendOk(res, boats, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Purchase a boat
router.post('/v1/boatshop/purchase', async (req, res, next) => {
  try {
    const { characterId, boatId, plate, properties } = req.body || {};
    const purchase = await boatshopRepo.purchaseBoat({ characterId, boatId, plate, properties });
    if (!purchase) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Boat not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, purchase, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
