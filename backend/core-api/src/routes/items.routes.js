import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { fetchItems } from '../services/items.service.js';

const router = Router();

router.get('/items', authToken(false), async (req, res, next) => {
    try {
        const data = await fetchItems();
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;