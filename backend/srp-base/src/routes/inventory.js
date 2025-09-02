import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { getInventory, addItem, removeItem } from '../repositories/inventory.js';

const router = Router();
const idSchema = z.coerce.number().int().positive();

router.use(authToken);

router.get('/:characterId/items', requireScope('inventory:read'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const items = await getInventory(characterId);
    res.json(items);
  } catch (err) {
    next(err);
  }
});

router.post('/:characterId/items', idempotency, requireScope('inventory:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const body = z.object({ itemId: idSchema, quantity: z.coerce.number().int().positive() }).parse(req.body);
    await addItem(characterId, body);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

router.delete('/:characterId/items/:itemId', idempotency, requireScope('inventory:write'), async (req, res, next) => {
  try {
    const characterId = idSchema.parse(req.params.characterId);
    const itemId = idSchema.parse(req.params.itemId);
    await removeItem(characterId, itemId);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
