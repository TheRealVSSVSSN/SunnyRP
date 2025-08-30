const express = require('express');
const { sendOk } = require('../utils/respond');
const dealersRepo = require('../repositories/dealersRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/dealers/offers', async (req, res, next) => {
  try {
    const offers = await dealersRepo.listActiveOffers();
    sendOk(res, { offers }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

router.post('/v1/dealers/offers', async (req, res, next) => {
  try {
    const { item, price, expiresAt } = req.body || {};
    const offer = await dealersRepo.createOffer({ item, price, expiresAt });
    websocket.broadcast('dealers', 'offer.created', offer);
    hooks.dispatch('dealers.offer.created', offer);
    sendOk(res, offer, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
