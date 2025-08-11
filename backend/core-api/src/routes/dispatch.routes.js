import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Svc from '../services/dispatch.service.js';

const r = Router();
const limiter = rateLimit({ windowMs: 1000, max: 300 });

function actor(req) {
    return {
        user_id: Number(req.header('X-SRP-UserId') || 0),
        char_id: Number(req.header('X-SRP-CharId') || 0),
    };
}

r.get('/dispatch', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.list(req.query.kind) });
    } catch (e) { next(e) }
});

r.post('/dispatch/call', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.call(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/dispatch/attach', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.attach(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/dispatch/clear', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.clear(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

export default r;