import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { listPlayers, upsertPlayer, removePlayer } from '../repositories/scoreboard.js';
import { emitEvent } from '../websockets/gateway.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();

router.use(authToken);

router.get('/players', requireScope('scoreboard:read'), async (req, res, next) => {
  try {
    const { sort } = z
      .object({ sort: z.enum(['displayName', 'ping']).default('displayName') })
      .parse(req.query);
    const players = await listPlayers({ sort });
    res.json(players);
  } catch (err) {
    next(err);
  }
});

router.post('/players', idempotency, requireScope('scoreboard:write'), async (req, res, next) => {
  try {
    const body = z.object({
      characterId: idSchema,
      accountId: idSchema,
      displayName: z.string().min(1).max(64),
      job: z.string().max(32).default(''),
      ping: z.coerce.number().int().nonnegative()
    }).parse(req.body);
    await upsertPlayer(body);
    emitEvent('scoreboard', 'update', String(body.characterId), {
      ping: body.ping,
      displayName: body.displayName,
      job: body.job
    });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/players/:characterId', idempotency, requireScope('scoreboard:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    await removePlayer(characterId);
    emitEvent('scoreboard', 'remove', String(characterId), {});
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
