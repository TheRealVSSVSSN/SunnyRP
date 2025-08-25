const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const repo = require('../repositories/diamondCasinoRepository');

const router = express.Router();

router.post('/v1/diamond-casino/games', async (req, res) => {
  const { gameType, metadata } = req.body || {};
  if (!gameType) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'gameType is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const game = await repo.createGame({ gameType, metadata });
    sendOk(res, { game }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CASINO_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/diamond-casino/games/:gameId/bets', async (req, res) => {
  const { gameId } = req.params;
  const { characterId, amount, betData } = req.body || {};
  if (!characterId || amount == null) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and amount are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const bet = await repo.addBet({ gameId: parseInt(gameId, 10), characterId, amount, betData });
    sendOk(res, { bet }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CASINO_BET_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.get('/v1/diamond-casino/games/:gameId', async (req, res) => {
  try {
    const game = await repo.getGame(parseInt(req.params.gameId, 10));
    if (!game) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Game not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    sendOk(res, { game }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CASINO_FETCH_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
