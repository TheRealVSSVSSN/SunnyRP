import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import {
  listWhitelist,
  addWhitelist,
  removeWhitelist,
  getHardCap,
  setHardCap,
  verifyLoginPassword,
  setLoginPassword,
  getCID,
  assignCID,
  isHospitalized,
  hospitalize,
  discharge,
  recordSpawn
} from '../repositories/sessions.js';
import { countPlayers } from '../repositories/scoreboard.js';

import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.post('/login', async (req, res, next) => {
  try {
    const body = z.object({ password: z.string().min(1) }).parse(req.body);
    const ok = await verifyLoginPassword(body.password);
    if (!ok) return res.status(403).json({ error: 'Invalid password' });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.use(authToken);

router.put('/login', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const body = z.object({ password: z.string().min(1) }).parse(req.body);
    await setLoginPassword(body.password);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.use(authToken);

router.get('/whitelist', requireScope('sessions:read'), async (req, res, next) => {
  try {
    const limit = z.coerce.number().int().positive().max(1000).default(1000).parse(req.query.limit);
    const rows = await listWhitelist(limit);
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

router.post('/whitelist', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const body = z.object({ accountId: z.number().int().positive(), power: z.number().int().default(0) }).parse(req.body);
    await addWhitelist(body.accountId, body.power);
    emitEvent('sessions', 'whitelist', String(body.accountId), { accountId: body.accountId, power: body.power });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/whitelist/:accountId', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const accountId = z.coerce.number().int().positive().parse(req.params.accountId);
    await removeWhitelist(accountId);
    emitEvent('sessions', 'whitelist', String(accountId), { accountId, removed: true });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/hardcap', requireScope('sessions:read'), async (req, res, next) => {
  try {
    const maxPlayers = await getHardCap();
    res.json({ maxPlayers });
  } catch (err) {
    next(err);
  }
});

router.put('/hardcap', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const body = z.object({ maxPlayers: z.number().int().positive() }).parse(req.body);
    await setHardCap(body.maxPlayers);
    emitEvent('sessions', 'hardcap', '*', { maxPlayers: body.maxPlayers });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/population', requireScope('sessions:read'), async (req, res, next) => {
  try {
    const count = await countPlayers();
    res.json({ count });
  } catch (err) {
    next(err);
  }
});

router.get('/characters/:characterId/cid', requireScope('sessions:read'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    const cid = await getCID(characterId);
    res.json({ cid });
  } catch (err) {
    next(err);
  }
});

router.post('/characters/:characterId/cid', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    const cid = await assignCID(characterId);
    emitEvent('sessions', 'cid', String(characterId), { cid });
    res.json({ cid });
  } catch (err) {
    next(err);
  }
});

router.get('/characters/:characterId/hospitalize', requireScope('sessions:read'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    const hospitalized = await isHospitalized(characterId);
    res.json({ hospitalized });
  } catch (err) {
    next(err);
  }
});

router.post('/characters/:characterId/hospitalize', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    await hospitalize(characterId);
    emitEvent('sessions', 'hospitalize', String(characterId), {});
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/characters/:characterId/hospitalize', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    await discharge(characterId);
    emitEvent('sessions', 'discharge', String(characterId), {});
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.post('/characters/:characterId/spawn', idempotency, requireScope('sessions:write'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    const body = z.object({ x: z.number(), y: z.number(), z: z.number(), heading: z.number() }).parse(req.body);
    await recordSpawn(characterId, body.x, body.y, body.z, body.heading);
    emitEvent('sessions', 'spawn', String(characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
