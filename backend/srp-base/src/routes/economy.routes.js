const express = require('express');
const { sendOk } = require('../utils/respond');
const economyRepo = require('../repositories/economyRepository');

// Routes for economy operations (accounts and transactions).  These
// endpoints expose basic banking functionality for players.  More
// complex features such as loans, business accounts or tax are
// intentionally omitted at this framework level.
const router = express.Router();

// Get a player's account
router.get('/v1/accounts/:playerId', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const account = await economyRepo.getAccount(playerId);
    sendOk(res, account, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Deposit into an account
router.post('/v1/accounts/:playerId/deposit', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const { amount } = req.body || {};
    const result = await economyRepo.deposit(playerId, Number(amount) || 0);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Withdraw from an account
router.post('/v1/accounts/:playerId/withdraw', async (req, res, next) => {
  try {
    const { playerId } = req.params;
    const { amount } = req.body || {};
    const result = await economyRepo.withdraw(playerId, Number(amount) || 0);
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Create a transaction between two players
router.post('/v1/transactions', async (req, res, next) => {
  try {
    const { fromPlayerId, toPlayerId, amount, reason } = req.body || {};
    const result = await economyRepo.createTransaction({ fromPlayerId, toPlayerId, amount, reason });
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