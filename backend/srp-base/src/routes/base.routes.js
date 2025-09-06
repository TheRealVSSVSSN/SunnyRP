// Updated: 2024-11-28
import { Router } from 'express';
import {
  listCharacters,
  createCharacter,
  selectCharacter,
  deleteCharacter,
} from '../repositories/baseRepository.js';
import { idempotency, saveIdempotency } from '../middleware/idempotency.js';
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
    res.status(201).type('application/json').send(body);
    saveIdempotency(req, res, body);
  } catch (e) {
    next(e);
  }
});

router.post('/:accountId/characters/:characterId/select', async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    const characterId = Number(req.params.characterId);
    const character = await selectCharacter(accountId, characterId);
    if (!character) throw Object.assign(new Error('not_found'), { status: 404 });
    res.json({ ok: true });
  } catch (e) {
    next(e);
  }
});

router.delete('/:accountId/characters/:characterId', async (req, res, next) => {
  try {
    const accountId = Number(req.params.accountId);
    const characterId = Number(req.params.characterId);
    const deleted = await deleteCharacter(accountId, characterId);
    res.status(deleted ? 200 : 404).json({ ok: deleted });
  } catch (e) {
    next(e);
  }
});

export default router;
