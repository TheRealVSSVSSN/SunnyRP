const express = require('express');
const economyRepo = require('../repositories/economyRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Route for paying drift school fees.  Clients can call
 * POST /v1/driftschool/pay with a playerId and amount to
 * withdraw funds from the player's account.  If the player
 * does not have sufficient balance, a 402 error is returned.
 */
const router = express.Router();

router.post('/v1/driftschool/pay', express.json(), async (req, res) => {
  const { playerId, amount } = req.body || {};
  if (!playerId || typeof amount !== 'number' || amount <= 0) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'playerId and positive numeric amount are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const account = await economyRepo.getAccount(playerId);
    if (!account || account.balance < amount) {
      return sendError(res, { code: 'INSUFFICIENT_FUNDS', message: 'Insufficient balance for drift school payment' }, 402, res.locals.requestId, res.locals.traceId);
    }
    await economyRepo.withdraw(playerId, amount);
    sendOk(res, { success: true, newBalance: account.balance - amount }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to process drift school payment' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;