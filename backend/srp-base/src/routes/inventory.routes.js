const express = require('express');
const { sendOk } = require('../utils/respond');
const inventoryRepo = require('../repositories/inventoryRepository');

// Routes for player inventory.  These endpoints simply manage
// persistent storage of inventory items.  They do not perform
// gameplay checks or handle weight limits – those concerns live in
// higher level Lua scripts.
const router = express.Router();

// Get a player's inventory
router.get('/v1/inventory/:playerId', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const items = await inventoryRepo.getInventory(playerId);
    sendOk(res, items, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Add an item to a player's inventory
router.post('/v1/inventory/:playerId/add', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const { item, quantity } = req.body || {};
    const result = await inventoryRepo.addItem(playerId, item, Number(quantity) || 1);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Remove an item from a player's inventory
router.post('/v1/inventory/:playerId/remove', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const { item, quantity } = req.body || {};
    const result = await inventoryRepo.removeItem(playerId, item, Number(quantity) || 1);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;