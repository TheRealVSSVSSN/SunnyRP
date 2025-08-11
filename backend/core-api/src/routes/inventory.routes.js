import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import { getCharInventory, addToInventory, removeFromInventory } from '../services/inventory.service.js';

const router = Router();
const invLimiter = rateLimit({ windowMs: 2000, max: 80 });

router.get('/inventory/:charId', authToken(true), async (req, res, next) => {
    try {
        const charId = parseInt(req.params.charId, 10);
        const data = await getCharInventory(charId);
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /inventory/:charId/add
router.post('/inventory/:charId/add', authToken(true), invLimiter, async (req, res, next) => {
    try {
        const charId = parseInt(req.params.charId, 10);
        const key = req.headers['x-idempotency-key'] || req.body.idempotencyKey || null;
        const body = req.body || {};
        const defaultMaxStack = parseInt(process.env.SRP_INV_DEFAULT_MAX_STACK || '250', 10);
        const data = await addToInventory({
            idemKey: key,
            container_type: body.container_type || 'char',
            container_id: body.container_id || String(charId),
            item_key: body.item_key,
            quantity: body.quantity || 1,
            slot: body.slot || 0,
            metadata: body.metadata || null,
            defaultMaxStack
        });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /inventory/:charId/remove
router.post('/inventory/:charId/remove', authToken(true), invLimiter, async (req, res, next) => {
    try {
        const charId = parseInt(req.params.charId, 10);
        const key = req.headers['x-idempotency-key'] || req.body.idempotencyKey || null;
        const body = req.body || {};
        const data = await removeFromInventory({
            idemKey: key,
            container_type: body.container_type || 'char',
            container_id: body.container_id || String(charId),
            item_key: body.item_key,
            quantity: body.quantity || 1,
            slot: body.slot || 0
        });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;