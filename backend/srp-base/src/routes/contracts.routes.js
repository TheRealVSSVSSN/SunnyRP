const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listContractsForPlayer,
  createContract,
  getContract,
  markAccepted,
  markDeclined,
} = require('../repositories/contractsRepository');
const { createTransaction } = require('../repositories/economyRepository');
const { broadcast } = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const router = express.Router();

router.get('/v1/contracts', async (req, res) => {
  const { playerId } = req.query;
  if (!playerId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'playerId is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const contracts = await listContractsForPlayer(playerId);
    sendOk(res, { contracts }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CONTRACT_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/contracts', async (req, res) => {
  const { senderId, receiverId, amount, info } = req.body || {};
  if (!senderId || !receiverId || amount === undefined) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'senderId, receiverId and amount are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  const amt = Number(amount);
  if (!Number.isFinite(amt) || amt <= 0) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'amount must be a positive number' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const { id } = await createContract({ senderId, receiverId, amount: amt, info: info || null });
    const payload = { id, senderId, receiverId, amount: amt, info: info || null };
    broadcast('contracts', 'created', payload);
    hooks.dispatch('contracts.created', payload);
    sendOk(res, { id }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CONTRACT_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/contracts/:id/accept', async (req, res) => {
  const contractId = parseInt(req.params.id, 10);
  const { playerId } = req.body || {};
  if (Number.isNaN(contractId) || !playerId) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'valid id and playerId are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const contract = await getContract(contractId);
    if (!contract) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Contract not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    if (contract.receiver_id !== playerId) {
      return sendError(
        res,
        { code: 'FORBIDDEN', message: 'Player is not the receiver' },
        403,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    if (contract.accepted !== null) {
      return sendError(
        res,
        { code: 'CONTRACT_RESOLVED', message: 'Contract already resolved' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    await createTransaction({ fromPlayerId: playerId, toPlayerId: contract.sender_id, amount: contract.amount, reason: 'contract' });
    await markAccepted(contractId);
    const payload = { id: contractId, senderId: contract.sender_id, receiverId: contract.receiver_id, amount: contract.amount };
    broadcast('contracts', 'accepted', payload);
    hooks.dispatch('contracts.accepted', payload);
    sendOk(res, { id: contractId }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CONTRACT_ACCEPT_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/contracts/:id/decline', async (req, res) => {
  const contractId = parseInt(req.params.id, 10);
  if (Number.isNaN(contractId)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'valid id is required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const contract = await getContract(contractId);
    if (!contract) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'Contract not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    if (contract.accepted !== null) {
      return sendError(
        res,
        { code: 'CONTRACT_RESOLVED', message: 'Contract already resolved' },
        409,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    await markDeclined(contractId);
    const payload = { id: contractId, senderId: contract.sender_id, receiverId: contract.receiver_id, amount: contract.amount };
    broadcast('contracts', 'declined', payload);
    hooks.dispatch('contracts.declined', payload);
    sendOk(res, { id: contractId }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CONTRACT_DECLINE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
