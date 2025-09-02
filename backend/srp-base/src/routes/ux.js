import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listChat, addChat, createVote, castVote, getVote } from '../repositories/ux.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.use(authToken);

router.get('/chat', requireScope('ux:read'), async (req, res, next) => {
  try {
    const limit = z.coerce.number().int().positive().max(100).default(50).parse(req.query.limit);
    const messages = await listChat(limit);
    res.json(messages);
  } catch (err) {
    next(err);
  }
});

router.post('/chat', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: z.number().int().positive(), message: z.string().min(1) }).parse(req.body);
    const id = await addChat(body.characterId, body.message);
    emitEvent('ux', 'chat', String(body.characterId), { id, characterId: body.characterId, message: body.message });
    res.status(201).json({ id });
  } catch (err) {
    next(err);
  }
});

router.post('/votes', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ question: z.string().min(1), options: z.array(z.string().min(1)).min(1), endsAt: z.string().datetime().optional() }).parse(req.body);
    const id = await createVote(body.question, body.options, body.endsAt ?? null);
    emitEvent('ux', 'vote.start', String(id), { question: body.question, options: body.options, endsAt: body.endsAt ?? null });
    res.status(201).json({ id });
  } catch (err) {
    next(err);
  }
});

router.post('/votes/:voteId', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const voteId = z.coerce.number().int().positive().parse(req.params.voteId);
    const body = z.object({ characterId: z.number().int().positive(), optionId: z.number().int().positive() }).parse(req.body);
    await castVote(voteId, body.characterId, body.optionId);
    emitEvent('ux', 'vote.cast', String(voteId), { characterId: body.characterId, optionId: body.optionId });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/votes/:voteId', requireScope('ux:read'), async (req, res, next) => {
  try {
    const voteId = z.coerce.number().int().positive().parse(req.params.voteId);
    const vote = await getVote(voteId);
    if (!vote) return res.status(404).json({ error: 'Not found' });
    res.json(vote);
  } catch (err) {
    next(err);
  }
});

router.post('/taskbar', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: z.number().int().positive(), task: z.string().min(1), progress: z.number().min(0).max(1) }).parse(req.body);
    emitEvent('ux', 'taskbar', String(body.characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/broadcast', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ message: z.string().min(1) }).parse(req.body);
    emitEvent('ux', 'broadcast', '*', { message: body.message });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/notify', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({
      characterId: z.number().int().positive().optional(),
      message: z.string().min(1),
      type: z.enum(['info', 'success', 'error']).default('info')
    }).parse(req.body);
    emitEvent('ux', 'notify', body.characterId ? String(body.characterId) : '*', body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/taskbarskill', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: z.number().int().positive(), skill: z.string().min(1), progress: z.number().min(0).max(1) }).parse(req.body);
    emitEvent('ux', 'taskbarskill', String(body.characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/taskbarthreat', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: z.number().int().positive(), threat: z.string().min(1), level: z.number().min(0).max(1) }).parse(req.body);
    emitEvent('ux', 'taskbarthreat', String(body.characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/tasknotify', idempotency, requireScope('ux:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: z.number().int().positive(), message: z.string().min(1) }).parse(req.body);
    emitEvent('ux', 'tasknotify', String(body.characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
