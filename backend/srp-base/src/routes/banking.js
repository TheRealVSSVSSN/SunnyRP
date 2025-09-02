import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { getAccount, deposit, withdraw, getTransactions } from '../repositories/banking.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();
const amountSchema = z.coerce.number().positive();

router.use(authToken);

router.get('/:characterId/account', requireScope('banking:read'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const account = await getAccount(characterId);
    res.json(account);
  } catch (err) {
    next(err);
  }
});

router.post('/:characterId/deposit', idempotency, requireScope('banking:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const body = z.object({ amount: amountSchema }).parse(req.body);
    const account = await deposit(characterId, body.amount);
    res.json(account);
  } catch (err) {
    next(err);
  }
});

router.post('/:characterId/withdraw', idempotency, requireScope('banking:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const body = z.object({ amount: amountSchema }).parse(req.body);
    const account = await withdraw(characterId, body.amount);
    res.json(account);
  } catch (err) {
    next(err);
  }
});

router.get('/:characterId/transactions', requireScope('banking:read'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const txns = await getTransactions(characterId);
    res.json(txns);
  } catch (err) {
    next(err);
  }
});

export default router;
