const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const economyRepo = require('../repositories/economyRepository');
const invoiceRepo = require('../repositories/invoiceRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

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
    websocket.broadcast('banking', 'deposit', { characterId, amount: amt, balance: result.balance });
    hooks.dispatch('banking.deposit', { characterId, amount: amt, balance: result.balance });
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
    websocket.broadcast('banking', 'withdraw', { characterId, amount: amt, balance: result.balance });
    hooks.dispatch('banking.withdraw', { characterId, amount: amt, balance: result.balance });
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
    websocket.broadcast('banking', 'transaction', { id: result.id, fromCharacterId, toCharacterId, amount: amt, reason });
    hooks.dispatch('banking.transaction', { id: result.id, fromCharacterId, toCharacterId, amount: amt, reason });
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

// Create an invoice
router.post('/v1/invoices', async (req, res, next) => {
  try {
    const { fromCharacterId, toCharacterId, amount, reason, dueAt } = req.body || {};
    if (!fromCharacterId || !toCharacterId) {
      return sendError(res, { code: 'INVALID_INPUT', message: 'fromCharacterId and toCharacterId are required' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const amt = Number(amount);
    if (!Number.isFinite(amt) || amt <= 0) {
      return sendError(res, { code: 'INVALID_AMOUNT', message: 'Amount must be positive' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await invoiceRepo.createInvoice({ fromCharacterId, toCharacterId, amount: amt, reason, dueAt });
    websocket.broadcast('banking', 'invoice.created', { id: result.id, fromCharacterId, toCharacterId, amount: amt, reason, dueAt });
    hooks.dispatch('banking.invoice.created', { id: result.id, fromCharacterId, toCharacterId, amount: amt, reason, dueAt });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// List invoices for a character
router.get('/v1/characters/:characterId/invoices', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const status = req.query.status;
    const invoices = await invoiceRepo.listInvoices(characterId, status);
    sendOk(res, { invoices }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Pay an invoice
router.post('/v1/invoices/:id:pay', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { characterId } = req.body || {};
    if (!characterId) {
      return sendError(res, { code: 'INVALID_INPUT', message: 'characterId required' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await invoiceRepo.payInvoice(id, characterId);
    if (!result) {
      return sendError(res, { code: 'NOT_ALLOWED', message: 'Cannot pay invoice' }, 400, res.locals.requestId, res.locals.traceId);
    }
    websocket.broadcast('banking', 'invoice.paid', { id, characterId });
    hooks.dispatch('banking.invoice.paid', { id, characterId });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Cancel an invoice
router.post('/v1/invoices/:id:cancel', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { characterId } = req.body || {};
    if (!characterId) {
      return sendError(res, { code: 'INVALID_INPUT', message: 'characterId required' }, 400, res.locals.requestId, res.locals.traceId);
    }
    const result = await invoiceRepo.cancelInvoice(id, characterId);
    if (!result) {
      return sendError(res, { code: 'NOT_ALLOWED', message: 'Cannot cancel invoice' }, 400, res.locals.requestId, res.locals.traceId);
    }
    websocket.broadcast('banking', 'invoice.cancelled', { id, characterId });
    hooks.dispatch('banking.invoice.cancelled', { id, characterId });
    sendOk(res, result, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;