const express = require('express');
const { z } = require('zod');
const repository = require('../repositories/baseRepository');
const validate = require('../middleware/validate');
const idempotency = require('../middleware/idempotency');

const router = express.Router();

router.get('/v1/accounts/:accountId/characters', (req, res) => {
  const chars = repository.listCharacters(req.params.accountId);
  res.json({ characters: chars });
});

const createSchema = z.object({
  firstName: z.string().min(1),
  lastName: z.string().min(1)
});

router.post('/v1/accounts/:accountId/characters', idempotency(), validate(createSchema), (req, res) => {
  const char = repository.createCharacter(req.params.accountId, req.validated);
  res.status(201).json(char);
});

router.post('/v1/accounts/:accountId/characters/:characterId/select', idempotency(), (req, res) => {
  const char = repository.selectCharacter(req.params.accountId, req.params.characterId);
  if (!char) return res.status(404).json({ error: 'not_found' });
  res.json(char);
});

router.delete('/v1/accounts/:accountId/characters/:characterId', idempotency(), (req, res) => {
  const ok = repository.deleteCharacter(req.params.accountId, req.params.characterId);
  if (!ok) return res.status(404).json({ error: 'not_found' });
  res.status(204).send();
});

module.exports = router;
