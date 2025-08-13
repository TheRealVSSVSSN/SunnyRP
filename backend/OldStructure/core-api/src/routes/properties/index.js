import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Svc from '../services/properties/index.js';

const r = Router();
const limiter = rateLimit({ windowMs: 1500, max: 180 });

function actor(req) { return { user_id: Number(req.header('X-SRP-UserId') || 0), char_id: Number(req.header('X-SRP-CharId') || 0) }; }

r.get('/properties', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.list(req.query, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/purchase', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.purchase(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/sell', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.sell(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/access/grant', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.grant(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/access/revoke', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.revoke(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/rent/start', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.rentStart(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/rent/stop', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.rentStop(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/enter', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.enter(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

r.post('/properties/lock', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Svc.lock(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

export default r;