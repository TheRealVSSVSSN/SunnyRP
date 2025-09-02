import { Router } from 'express';
import { z } from 'zod';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { idempotency } from '../middleware/idempotency.js';
import { listChannel, joinChannel, leaveChannel, setBroadcast, getBroadcast, listBroadcast } from '../repositories/voice.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();
const channelSchema = z.string().min(1).max(64);
const charSchema = z.number().int().positive();

router.use(authToken);

router.get('/channels/:channelId', requireScope('voice:read'), async (req, res, next) => {
  try {
    const channelId = channelSchema.parse(req.params.channelId);
    const members = await listChannel(channelId);
    res.json(members);
  } catch (err) {
    next(err);
  }
});

router.post('/channels/:channelId/join', idempotency, requireScope('voice:write'), async (req, res, next) => {
  try {
    const channelId = channelSchema.parse(req.params.channelId);
    const body = z.object({ characterId: charSchema }).parse(req.body);
    await joinChannel(channelId, body.characterId);
    emitEvent('voice', 'join', String(body.characterId), { channelId });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/channels/:channelId/leave', idempotency, requireScope('voice:write'), async (req, res, next) => {
  try {
    const channelId = channelSchema.parse(req.params.channelId);
    const body = z.object({ characterId: charSchema }).parse(req.body);
    await leaveChannel(channelId, body.characterId);
    emitEvent('voice', 'leave', String(body.characterId), { channelId });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/broadcast/:characterId', requireScope('voice:read'), async (req, res, next) => {
  try {
    const characterId = charSchema.parse(req.params.characterId);
    const active = await getBroadcast(characterId);
    res.json({ active });
  } catch (err) {
    next(err);
  }
});

router.get('/broadcast', requireScope('voice:read'), async (req, res, next) => {
  try {
    const list = await listBroadcast();
    res.json(list);
  } catch (err) {
    next(err);
  }
});

router.post('/broadcast', idempotency, requireScope('voice:write'), async (req, res, next) => {
  try {
    const body = z.object({ characterId: charSchema, active: z.boolean() }).parse(req.body);
    await setBroadcast(body.characterId, body.active, Number(process.env.VOICE_BROADCAST_LIMIT) || 5);
    emitEvent('voice', 'broadcast', String(body.characterId), { active: body.active });
    res.status(204).end();
  } catch (err) {
    if (err.message === 'Broadcast limit reached') {
      return res.status(409).json({ error: err.message });
    }
    next(err);
  }
});

export default router;
