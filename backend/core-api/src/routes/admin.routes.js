import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { banUser, kickUser, getAudit } from '../services/admin.service.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Admin from '../services/admin.service.js';

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

const limiter = rateLimit({ windowMs: 2000, max: 240 });

router.get('/admin/players', authToken(true), async (req, res, next) => {
    try { res.json({ ok: true, data: await Admin.getOnline() }); } catch (e) { next(e); }
});

// Server heartbeat presence (called from FiveM server)
router.post('/admin/players/heartbeat', authToken(true), async (req, res, next) => {
    try { res.json(await Admin.heartbeat(req.body || {})); } catch (e) { next(e); }
});

// Preflight + audit (approval)
router.post('/admin/actions/:action', authToken(true), limiter, async (req, res, next) => {
    try { res.json(await Admin.preflight(req.params.action, req.body || {})); } catch (e) { next(e); }
});

// Mark outcome (success/error)
router.post('/admin/actions/complete', authToken(true), async (req, res, next) => {
    try { res.json(await Admin.complete(req.body || {})); } catch (e) { next(e); }
});

// Audit feed
router.get('/admin/audit', authToken(true), async (req, res, next) => {
    try { res.json({ ok: true, data: await Admin.auditList(req.query) }); } catch (e) { next(e); }
});

export default router;