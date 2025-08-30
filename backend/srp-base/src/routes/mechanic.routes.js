const express = require('express');
const { sendOk } = require('../utils/respond');
const mechanicRepo = require('../repositories/mechanicRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

// Mechanic orders allow vehicle upgrade requests to be tracked server side.
const router = express.Router();

// Create a new mechanic order
router.post('/v1/mechanic/orders', async (req, res, next) => {
  try {
    const { vehiclePlate, characterId, description } = req.body || {};
    const order = await mechanicRepo.createOrder(vehiclePlate, characterId, description);
    websocket.broadcast('mechanic', 'orders.created', order);
    hooks.dispatch('mechanic.orders.created', order);
    sendOk(res, order, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Retrieve an order by id
router.get('/v1/mechanic/orders/:id', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const order = await mechanicRepo.getOrder(id);
    sendOk(res, order, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
