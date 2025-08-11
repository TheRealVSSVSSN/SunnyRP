import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { banUser, kickUser, getAudit } from '../services/admin.service.js';

const router = Router();

// POST /admin/ban
router.post('/admin/ban', authToken(true), async (req, res, next) => {
    try {
        const { userId, reason, minutes = null, actorId = null } = req.body || {};
        const data = await banUser({ userId, reason, minutes, actorId });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /admin/kick
router.post('/admin/kick', authToken(true), async (req, res, next) => {
    try {
        const { userId, reason, actorId = null } = req.body || {};
        const data = await kickUser({ userId, reason, actorId });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// GET /admin/audit
router.get('/admin/audit', authToken(true), async (req, res, next) => {
    try {
        const userId = req.query.userId ? Number(req.query.userId) : null;
        const limit = req.query.limit ? Number(req.query.limit) : 50;
        const data = await getAudit({ userId, limit });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;