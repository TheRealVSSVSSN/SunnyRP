// src/routes/outbox.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { enqueue } from '../repositories/outbox.repo.js';
import { idempotentRoute } from '../middleware/idempotency.js';

export const outboxRouter = Router();

/**
 * POST /v1/outbox/enqueue
 * body: { topic: string, payload: object }
 * Enqueues an event for async processing; consumers are out of scope of this service.
 */
outboxRouter.post(
    '/v1/outbox/enqueue',
    idempotentRoute(async (req, res) => {
        const { topic, payload } = req.body || {};
        if (!topic) {
            return fail(req, res, 'INVALID_INPUT', 'Missing topic');
        }
        const id = await enqueue(topic, payload || {});
        return ok(req, res, { id, topic });
    })
);