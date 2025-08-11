import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Heat from '../services/crimeHeat.service.js';
import * as Loot from '../services/crimeLoot.service.js';
import * as Heist from '../services/crimeHeist.service.js';

const r = Router();
const limiter = rateLimit({ windowMs: 1000, max: 240 });

function actor(req) { return { user_id: Number(req.header('X-SRP-UserId') || 0), char_id: Number(req.header('X-SRP-CharId') || 0) }; }

// Heat
r.post('/crime/heat/add', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Heat.add(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});
r.post('/crime/heat/decay', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Heat.decay(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

// Loot
r.post('/crime/loot/roll', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Loot.roll(req.body || {}) });
    } catch (e) { next(e) }
});

// Heist/cooldown
r.post('/crime/heist/start', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Heist.start(req.body || {}) });
    } catch (e) { next(e) }
});
r.post('/crime/heist/complete', authToken(true), limiter, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Heist.complete(req.body || {}) });
    } catch (e) { next(e) }
});

export default r;