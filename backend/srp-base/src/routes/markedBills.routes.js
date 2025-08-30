const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const markedBillsRepo = require('../repositories/markedBillsRepository');
const economyRepo = require('../repositories/economyRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

// Get marked bills balance for a character
router.get('/v1/characters/:characterId/marked-bills', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const amount = await markedBillsRepo.getAmount(characterId);
    sendOk(res, { characterId, amount }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Alter marked bills amount
router.post('/v1/characters/:characterId/marked-bills:alter', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const { amount, reason } = req.body || {};
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    let result;
    if (reason === 'ItemDrop') {
      result = await markedBillsRepo.subtract(characterId, amt);
      websocket.broadcast('economy', 'markedBills.drop', { characterId, amount: amt, balance: result.amount });
      hooks.dispatch('economy.markedBills.drop', { characterId, amount: amt, balance: result.amount });
    } else {
      result = await markedBillsRepo.add(characterId, amt);
      websocket.broadcast('economy', 'markedBills.add', { characterId, amount: amt, balance: result.amount });
      hooks.dispatch('economy.markedBills.add', { characterId, amount: amt, balance: result.amount });
    }
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    if (err.message === 'INSUFFICIENT_FUNDS') {
      return sendError(res, { code: 'INSUFFICIENT_FUNDS', message: 'Not enough marked bills' }, 400, res.locals.requestId, res.locals.traceId);
    }
    next(err);
  }
});

// Convert marked bills to clean money
router.post('/v1/characters/:characterId/marked-bills:pickup', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const { amount } = req.body || {};
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await economyRepo.deposit(characterId, amt);
    websocket.broadcast('economy', 'markedBills.pickup', { characterId, amount: amt, balance: result.balance });
    hooks.dispatch('economy.markedBills.pickup', { characterId, amount: amt, balance: result.balance });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
