// 2025-02-14
import { Router } from 'express';
import {
  listCharacters,
  createCharacter,
  selectCharacter,
  deleteCharacter,
} from '../repositories/baseRepository.js';
import { idempotency } from '../middleware/idempotency.js';
import { assertValid } from '../middleware/validate.js';

/**
 * Router: /v1/accounts
 */
const router = Router();

router.get('/:accountId/characters', async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    if (!accountId) throw Object.assign(new Error('invalid_account'), { status: 400 });
    const chars = await listCharacters(accountId);
    res.json(chars);
  } catch (e) {
    next(e);
  }
});

router.post('/:accountId/characters', idempotency, async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    if (!accountId) throw Object.assign(new Error('invalid_account'), { status: 400 });
    assertValid(
      { firstName: { type: 'string', required: true }, lastName: { type: 'string', required: true } },
      req.body || {}
    );
    const character = await createCharacter(accountId, req.body);
    const body = JSON.stringify(character);
    res.locals.body = body;
    res.status(201).type('application/json').send(body);
    req.app.get('ws')?.emit('characters:updated', { accountId });
  } catch (e) {
    next(e);
  }
});

router.post('/:accountId/characters/:characterId/select', idempotency, async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    const characterId = Number(req.params.characterId);
    const character = await selectCharacter(accountId, characterId);
    if (!character) throw Object.assign(new Error('not_found'), { status: 404 });
    const body = JSON.stringify({ ok: true });
    res.locals.body = body;
    res.type('application/json').send(body);
    req.app.get('ws')?.emit('characters:selected', { accountId, characterId });
  } catch (e) {
    next(e);
  }
});

router.delete('/:accountId/characters/:characterId', idempotency, async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    const characterId = Number(req.params.characterId);
    const deleted = await deleteCharacter(accountId, characterId);
    const body = JSON.stringify({ ok: deleted });
    res.locals.body = body;
    res.status(deleted ? 200 : 404).type('application/json').send(body);
    if (deleted) req.app.get('ws')?.emit('characters:updated', { accountId });
  } catch (e) {
    next(e);
  }
});

export default router;
