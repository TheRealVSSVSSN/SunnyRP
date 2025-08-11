import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Svc from '../services/mdt.service.js';

const r = Router();
const limiter = rateLimit({ windowMs: 2000, max: 240 });

// Helper to read actor (user/char) from headers passed by FiveM server
function actor(req) {
    return {
        user_id: Number(req.header('X-SRP-UserId') || 0),
        char_id: Number(req.header('X-SRP-CharId') || 0),
    };
}

r.get('/mdt/reports', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.list(req.query) });
    } catch (e) { next(e) }
});

r.post('/mdt/reports', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.create(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.get('/mdt/reports/:id', authToken(true), async (req, res, next) => {
    try {
        const d = await Svc.get(req.params.id); res.json({ ok: !!d, data: d });
    } catch (e) { next(e) }
});

r.put('/mdt/reports/:id', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.update(req.params.id, req.body || {}) });
    } catch (e) { next(e) }
});

r.delete('/mdt/reports/:id', authToken(true), limiter, async (req, res, next) => {
    try {
        await Svc.remove(req.params.id); res.json({ ok: true });
    } catch (e) { next(e) }
});

export default r;