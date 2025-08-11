import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Svc from '../services/jobs.service.js';

const router = Router();
const limiter = rateLimit({ windowMs: 2000, max: 120 });

router.get('/jobs/definitions', authToken(true), async (req, res, next) => {
    try { res.json({ ok: true, data: await Svc.definitions() }); } catch (e) { next(e); }
});

router.post('/jobs/set', authToken(true), limiter, async (req, res, next) => {
    try { res.json({ ok: true, data: await Svc.setJob(req.body || {}) }); } catch (e) { next(e); }
});

router.post('/jobs/duty', authToken(true), limiter, async (req, res, next) => {
    try { res.json({ ok: true, data: await Svc.setDuty(req.body || {}) }); } catch (e) { next(e); }
});

// Optional helper to load current job for a character
router.get('/jobs/state', authToken(true), async (req, res, next) => {
    try { res.json({ ok: true, data: await Svc.state(req.query.charId) }); } catch (e) { next(e); }
});

export default router;