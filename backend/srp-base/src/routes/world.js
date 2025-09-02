import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import {
  getWeather,
  setWeather,
  listZones,
  createZone,
  deleteZone,
  listBarriers,
  createBarrier,
  deleteBarrier,
  saveCoords,
  getCoords,
  saveEntityCoords,
  getEntityCoords
} from '../repositories/world.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();

router.use(authToken);

router.get('/weather', requireScope('world:read'), async (req, res, next) => {
  try {
    const weather = await getWeather();
    res.json({ weather });
  } catch (err) {
    next(err);
  }
});

router.put('/weather', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const body = z.object({ weather: z.string().min(1).max(16) }).parse(req.body);
    await setWeather(body.weather);
    emitEvent('world', 'weather', '*', { weather: body.weather });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/coords/:characterId', requireScope('world:read'), async (req, res, next) => {
  try {
    const characterId = z.coerce.number().int().positive().parse(req.params.characterId);
    const coords = await getCoords(characterId);
    if (!coords) return res.status(404).json({ error: 'Not found' });
    res.json(coords);
  } catch (err) {
    next(err);
  }
});

router.post('/coords', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const body = z.object({
      characterId: z.number().int().positive(),
      x: z.number(),
      y: z.number(),
      z: z.number(),
      heading: z.number()
    }).parse(req.body);
    await saveCoords(body.characterId, body.x, body.y, body.z, body.heading);
    emitEvent('world', 'coords', String(body.characterId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/infinity/entities/:entityId', requireScope('world:read'), async (req, res, next) => {
  try {
    const entityId = z.coerce.number().int().positive().parse(req.params.entityId);
    const coords = await getEntityCoords(entityId);
    if (!coords) return res.status(404).json({ error: 'Not found' });
    res.json(coords);
  } catch (err) {
    next(err);
  }
});

router.post('/infinity/entities', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const body = z.object({
      entityId: z.number().int().positive(),
      x: z.number(),
      y: z.number(),
      z: z.number(),
      heading: z.number()
    }).parse(req.body);
    await saveEntityCoords(body.entityId, body.x, body.y, body.z, body.heading);
    emitEvent('world', 'infinity.entity', String(body.entityId), body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/zones', requireScope('world:read'), async (req, res, next) => {
  try {
    const zones = await listZones();
    res.json(zones);
  } catch (err) {
    next(err);
  }
});

router.post('/zones', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const body = z.object({ name: z.string().min(1).max(64), data: z.any() }).parse(req.body);
    const id = await createZone(body.name, body.data);
    emitEvent('world', 'zone.create', String(id), { id, name: body.name, data: body.data });
    res.status(201).json({ id });
  } catch (err) {
    next(err);
  }
});

router.delete('/zones/:id', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const id = z.coerce.number().int().positive().parse(req.params.id);
    await deleteZone(id);
    emitEvent('world', 'zone.delete', String(id), { id });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.get('/barriers', requireScope('world:read'), async (req, res, next) => {
  try {
    const barriers = await listBarriers();
    res.json(barriers);
  } catch (err) {
    next(err);
  }
});

router.post('/barriers', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const body = z.object({ zoneId: z.number().int().positive(), data: z.any() }).parse(req.body);
    const id = await createBarrier(body.zoneId, body.data);
    emitEvent('world', 'barrier.create', String(id), { id, zoneId: body.zoneId, data: body.data });
    res.status(201).json({ id });
  } catch (err) {
    next(err);
  }
});

router.delete('/barriers/:id', idempotency, requireScope('world:write'), async (req, res, next) => {
  try {
    const id = z.coerce.number().int().positive().parse(req.params.id);
    await deleteBarrier(id);
    emitEvent('world', 'barrier.delete', String(id), { id });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
