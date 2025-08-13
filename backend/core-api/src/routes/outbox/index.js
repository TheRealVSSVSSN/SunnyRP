import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { stats } from '../services/outbox/index.js';

const r = Router();
r.get('/admin/outbox/stats', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await stats() });
    } catch (e) { next(e) }
});
export default r;