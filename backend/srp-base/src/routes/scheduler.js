import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listSchedulerRuns, setSchedulerRun } from '../repositories/scheduler.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.use(authToken);

//[[
// Type: Endpoint
// Name: GET /v1/scheduler/runs
// Use: Lists scheduler tasks and last run timestamps
// Created: 2025-09-06
// By: VSSVSSN
//]]
router.get('/runs', requireScope('scheduler:read'), async (req, res, next) => {
  try {
    const rows = await listSchedulerRuns();
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

//[[
// Type: Endpoint
// Name: POST /v1/scheduler/runs/{taskName}
// Use: Manually triggers a scheduler task run
// Created: 2025-09-06
// By: VSSVSSN
//]]
router.post('/runs/:taskName', idempotency, requireScope('scheduler:write'), async (req, res, next) => {
  try {
    const taskName = z.string().min(1).parse(req.params.taskName);
    const now = new Date();
    await setSchedulerRun(taskName, now);
    emitEvent('scheduler', 'run', taskName, { manual: true });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
