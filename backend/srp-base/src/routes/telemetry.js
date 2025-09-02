import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import {
  logError,
  getErrors,
  logRcon,
  execCode,
  scheduleRestart,
  getRestartSchedule,
  clearRestartSchedule,
  logDebug
} from '../repositories/telemetry.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.use(authToken);

router.get('/errors', requireScope('telemetry:read'), async (req, res, next) => {
  try {
    const limit = z.coerce.number().int().positive().max(100).default(50).parse(req.query.limit);
    const logs = await getErrors(limit);
    res.json(logs);
  } catch (err) {
    next(err);
  }
});

router.post('/errors', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    const body = z.object({
      service: z.string().min(1),
      level: z.string().min(1),
      message: z.string().min(1)
    }).parse(req.body);
    const log = await logError(body);
    emitEvent('telemetry', 'error', '*', log);
    res.status(201).json(log);
  } catch (err) {
    next(err);
  }
});

router.post('/rcon', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    const body = z.object({ command: z.string().min(1), args: z.string().optional() }).parse(req.body);
    const log = await logRcon(body);
    emitEvent('telemetry', 'rcon', '*', body);
    res.status(201).json(log);
  } catch (err) {
    next(err);
  }
});

router.post('/exec', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    const body = z.object({ code: z.string().min(1) }).parse(req.body);
    const result = await execCode(body.code);
    emitEvent('telemetry', 'exec', '*', { code: body.code, output: result.output });
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
});

router.post('/restart', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    const body = z.object({ restartAt: z.string().datetime(), reason: z.string().optional() }).parse(req.body);
    await scheduleRestart(body.restartAt, body.reason ?? null);
    emitEvent('telemetry', 'restart.schedule', '*', { restartAt: body.restartAt, reason: body.reason ?? null });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/restart', requireScope('telemetry:read'), async (req, res, next) => {
  try {
    const sched = await getRestartSchedule();
    res.json(sched || {});
  } catch (err) {
    next(err);
  }
});

router.delete('/restart', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    await clearRestartSchedule();
    emitEvent('telemetry', 'restart.cancel', '*', {});
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/debug', idempotency, requireScope('telemetry:write'), async (req, res, next) => {
  try {
    const body = z.object({ message: z.string().min(1) }).parse(req.body);
    await logDebug(body.message);
    emitEvent('telemetry', 'debug', '*', { message: body.message });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
