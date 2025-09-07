/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const { z } = require('zod');
const repository = require('../repositories/baseRepository');
const validate = require('../middleware/validate');
const idempotency = require('../middleware/idempotency');

const createSchema = z.object({
  firstName: z.string().min(1),
  lastName: z.string().min(1)
});

module.exports = [
  {
    method: 'GET',
    path: /^\/v1\/accounts\/([^/]+)\/characters$/,
    handler: (req, res, params) => {
      const chars = repository.listCharacters(params[1]);
      res.json({ characters: chars });
    }
  },
  {
    method: 'POST',
    path: /^\/v1\/accounts\/([^/]+)\/characters$/,
    middlewares: [idempotency(), validate(createSchema)],
    handler: (req, res, params) => {
      const char = repository.createCharacter(params[1], req.validated);
      res.status(201).json(char);
    }
  },
  {
    method: 'POST',
    path: /^\/v1\/accounts\/([^/]+)\/characters\/([^/]+)\/select$/,
    middlewares: [idempotency()],
    handler: (req, res, params) => {
      const char = repository.selectCharacter(params[1], params[2]);
      if (!char) return res.status(404).json({ error: 'not_found' });
      res.json(char);
    }
  },
  {
    method: 'DELETE',
    path: /^\/v1\/accounts\/([^/]+)\/characters\/([^/]+)$/,
    middlewares: [idempotency()],
    handler: (req, res, params) => {
      const ok = repository.deleteCharacter(params[1], params[2]);
      if (!ok) return res.status(404).json({ error: 'not_found' });
      res.status(204).send('');
    }
  }
];
