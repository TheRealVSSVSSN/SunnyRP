import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listCharacterJobs, setPrimaryJob, setSecondaryJob, removeSecondaryJob } from '../repositories/jobs.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();

router.use(authToken);

router.get('/characters/:characterId', requireScope('jobs:read'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const jobs = await listCharacterJobs(characterId);
    res.json(jobs);
  } catch (err) {
    next(err);
  }
});

router.post('/characters/:characterId', idempotency, requireScope('jobs:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const body = z.object({ job: z.string().min(1).max(32), grade: z.number().int().nonnegative() }).parse(req.body);
    await setPrimaryJob(characterId, body.job, body.grade);
    emitEvent('jobs', 'primary', String(characterId), { job: body.job, grade: body.grade });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/characters/:characterId/secondary', idempotency, requireScope('jobs:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const body = z.object({ job: z.string().min(1).max(32), grade: z.number().int().nonnegative() }).parse(req.body);
    await setSecondaryJob(characterId, body.job, body.grade);
    emitEvent('jobs', 'secondary.add', String(characterId), { job: body.job, grade: body.grade });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/characters/:characterId/secondary/:job', idempotency, requireScope('jobs:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const job = z.string().min(1).max(32).parse(req.params.job);
    await removeSecondaryJob(characterId, job);
    emitEvent('jobs', 'secondary.remove', String(characterId), { job });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
