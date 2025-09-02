import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { getCharacters, createCharacter, selectCharacter, deleteCharacter } from '../repositories/characters.js';
import { assignRole, getAccountRoles } from '../repositories/roles.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();

router.use(authToken);

/**
 * @openapi
 * /v1/accounts/{accountId}/characters:
 *   get:
 *     summary: List characters for an account
 *     tags:
 *       - Accounts
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - accounts:read
 *     parameters:
 *       - in: path
 *         name: accountId
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       '200':
 *         description: Successful response
 *   post:
 *     summary: Create a character
 *     tags:
 *       - Accounts
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - accounts:write
 *     parameters:
 *       - in: path
 *         name: accountId
 *         required: true
 *         schema:
 *           type: integer
 *       - $ref: '#/components/parameters/IdempotencyKey'
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - firstName
 *               - lastName
 *             properties:
 *               firstName:
 *                 type: string
 *               lastName:
 *                 type: string
 *     responses:
 *       '201':
 *         description: Character created
 */
router.get('/:accountId/characters', requireScope('accounts:read'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const rows = await getCharacters(accountId);
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

router.post('/:accountId/characters', idempotency, requireScope('accounts:write'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const body = z.object({ firstName: z.string().min(1), lastName: z.string().min(1) }).parse(req.body);
    const character = await createCharacter(accountId, body);
    res.status(201).json(character);
  } catch (err) {
    next(err);
  }
});

/**
 * @openapi
 * /v1/accounts/{accountId}/characters/{characterId}:select:
 *   post:
 *     summary: Select active character
 *     tags:
 *       - Accounts
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - accounts:write
 *     parameters:
 *       - in: path
 *         name: accountId
 *         required: true
 *         schema:
 *           type: integer
 *       - in: path
 *         name: characterId
 *         required: true
 *         schema:
 *           type: integer
 *       - $ref: '#/components/parameters/IdempotencyKey'
 *     responses:
 *       '204':
 *         description: Selection saved
 */
router.post('/:accountId/characters/:characterId:select', idempotency, requireScope('accounts:write'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const characterId = idSchema.parse(req.params.characterId);
    await selectCharacter(accountId, characterId);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

/**
 * @openapi
 * /v1/accounts/{accountId}/characters/{characterId}:
 *   delete:
 *     summary: Delete a character
 *     tags:
 *       - Accounts
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - accounts:write
 *     parameters:
 *       - in: path
 *         name: accountId
 *         required: true
 *         schema:
 *           type: integer
 *       - in: path
 *         name: characterId
 *         required: true
 *         schema:
 *           type: integer
 *       - $ref: '#/components/parameters/IdempotencyKey'
 *     responses:
 *       '204':
 *         description: Character deleted
 */
router.delete('/:accountId/characters/:characterId', idempotency, requireScope('accounts:write'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const characterId = idSchema.parse(req.params.characterId);
    await deleteCharacter(accountId, characterId);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/:accountId/roles', requireScope('roles:read'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const roles = await getAccountRoles(accountId);
    res.json(roles);
  } catch (err) {
    next(err);
  }
});

router.post('/:accountId/roles', idempotency, requireScope('roles:write'), async (req, res, next) => {
  try {
    const accountId = idSchema.parse(req.params.accountId);
    const body = z.object({ roleId: z.number().int().positive() }).parse(req.body);
    await assignRole(accountId, body.roleId);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;