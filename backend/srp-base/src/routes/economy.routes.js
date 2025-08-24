const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const economyRepo = require('../repositories/economyRepository');

// Routes for economy operations (accounts and transactions).  These
// endpoints expose basic banking functionality for characters.  More
// complex features such as loans, business accounts or tax are
// intentionally omitted at this framework level.
const router = express.Router();

// Get or create a character's account
router.get('/v1/characters/:characterId/account', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const account = await economyRepo.getAccount(characterId);
    sendOk(res, account, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Deposit into an account
router.post('/v1/characters/:characterId/account:deposit', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const { amount } = req.body || {};
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await economyRepo.deposit(characterId, amt);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Withdraw from an account
router.post('/v1/characters/:characterId/account:withdraw', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const { amount } = req.body || {};
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await economyRepo.withdraw(characterId, amt);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List recent transactions for a character
router.get('/v1/characters/:characterId/transactions', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const limit = Math.min(Number(req.query.limit) || 50, 100);
    const txs = await economyRepo.listTransactions(characterId, limit);
    sendOk(res, { transactions: txs }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Create a transaction between two characters
router.post('/v1/transactions', async (req, res, next) => {
  try {
    const { fromCharacterId, toCharacterId, amount, reason } = req.body || {};
    if (!fromCharacterId || !toCharacterId) {
      return sendError(res, { code: 'INVALID_INPUT', message: 'fromCharacterId and toCharacterId are required' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await economyRepo.createTransaction({ fromCharacterId, toCharacterId, amount: amt, reason });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Get a transaction by ID
router.get('/v1/transactions/:id', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const tx = await economyRepo.getTransaction(id);
    sendOk(res, tx, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;