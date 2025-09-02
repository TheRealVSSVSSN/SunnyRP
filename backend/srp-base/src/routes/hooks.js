import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listEndpoints, createEndpoint, deleteEndpoint } from '../repositories/hooks.js';
import { refreshEndpoints } from '../webhooks/dispatcher.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();
const bodySchema = z.object({ url: z.string().url(), secret: z.string().min(1) });

router.use(authToken);

/**
 * @openapi
 * /v1/hooks/endpoints:
 *   get:
 *     summary: List webhook endpoints
 *     tags:
 *       - Hooks
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - hooks:read
 *     responses:
 *       '200':
 *         description: Endpoint list
 *   post:
 *     summary: Create webhook endpoint
 *     tags:
 *       - Hooks
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - hooks:write
 *     parameters:
 *       - $ref: '#/components/parameters/IdempotencyKey'
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - url
 *               - secret
 *             properties:
 *               url:
 *                 type: string
 *                 format: uri
 *               secret:
 *                 type: string
 *     responses:
 *       '201':
 *         description: Endpoint created
 */
router.get('/endpoints', requireScope('hooks:read'), async (req, res, next) => {
  try {
    const rows = await listEndpoints();
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

router.post('/endpoints', idempotency, requireScope('hooks:write'), async (req, res, next) => {
  try {
    const body = bodySchema.parse(req.body);
    const created = await createEndpoint(body);
    await refreshEndpoints();
    res.status(201).json(created);
  } catch (err) {
    next(err);
  }
});

/**
 * @openapi
 * /v1/hooks/endpoints/{id}:
 *   delete:
 *     summary: Delete webhook endpoint
 *     tags:
 *       - Hooks
 *     security:
 *       - hmacAuth: []
 *         bearerAuth:
 *           - hooks:write
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *       - $ref: '#/components/parameters/IdempotencyKey'
 *     responses:
 *       '204':
 *         description: Endpoint deleted
 */
router.delete('/endpoints/:id', idempotency, requireScope('hooks:write'), async (req, res, next) => {
  try {
    const id = idSchema.parse(req.params.id);
    await deleteEndpoint(id);
    await refreshEndpoints();
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
