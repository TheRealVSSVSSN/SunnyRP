import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listQueue, enqueue, dequeue } from '../repositories/queue.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.use(authToken);

router.get('/', requireScope('queue:read'), async (req, res, next) => {
  try {
    const limit = z.coerce.number().int().positive().max(1000).default(100).parse(req.query.limit);
    const rows = await listQueue(limit);
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

router.post('/', idempotency, requireScope('queue:write'), async (req, res, next) => {
  try {
    const body = z.object({ accountId: z.number().int().positive(), priority: z.number().int().default(0) }).parse(req.body);
    await enqueue(body.accountId, body.priority);
    emitEvent('queue', 'update', '*', { accountId: body.accountId });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/:accountId', idempotency, requireScope('queue:write'), async (req, res, next) => {
  try {
    const accountId = z.coerce.number().int().positive().parse(req.params.accountId);
    await dequeue(accountId);
    emitEvent('queue', 'update', '*', { accountId });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
