const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/diamondBlackjackRepository');

const router = express.Router();

router.get('/v1/diamond-blackjack/hands/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const hands = await repo.listHandsByCharacter(characterId);
    sendOk(res, { hands }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'BLACKJACK_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/diamond-blackjack/hands', async (req, res) => {
  const { characterId, tableId, bet, payout, dealerHand, playerHand, playedAt } = req.body || {};
  if (!characterId || tableId == null || bet == null || payout == null || !dealerHand || !playerHand) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId, tableId, bet, payout, dealerHand and playerHand are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const hand = await repo.recordHand({ characterId, tableId, bet, payout, dealerHand, playerHand, playedAt });
    sendOk(res, { hand }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'BLACKJACK_RECORD_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
