const express = require('express');
const repo = require('../repositories/baseRepository');
const validate = require('../middleware/validate');
const idempotency = require('../middleware/idempotency');

const router = express.Router();

router.get('/v1/accounts/:accountId/characters', (req, res) => {
  const chars = repo.listCharacters(req.params.accountId);
  res.json({ characters: chars });
});

router.post(
  '/v1/accounts/:accountId/characters',
  idempotency,
  validate((req) => {
    if (!req.body || typeof req.body.name !== 'string' || !req.body.name.trim()) {
      throw new Error('name_required');
    }
  }),
  (req, res) => {
    const character = repo.createCharacter(req.params.accountId, { name: req.body.name });
    res.status(201).json({ character });
  }
);

router.post(
  '/v1/accounts/:accountId/characters/:characterId:select',
  idempotency,
  (req, res, next) => {
    try {
      const character = repo.selectCharacter(req.params.accountId, req.params.characterId);
      res.json({ character });
    } catch (e) {
      next(e);
    }
  }
);

router.delete(
  '/v1/accounts/:accountId/characters/:characterId',
  idempotency,
  (req, res) => {
    const deleted = repo.deleteCharacter(req.params.accountId, req.params.characterId);
    if (!deleted) return res.status(404).json({ error: 'not_found' });
    res.status(204).end();
  }
);

module.exports = router;
