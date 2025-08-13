import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Svc from '../services/businesses/index.js';

const r = Router();
const limiter = rateLimit({ windowMs: 1000, max: 240 });
function actor(req) { return { user_id: Number(req.header('X-SRP-UserId') || 0), char_id: Number(req.header('X-SRP-CharId') || 0) }; }

r.get('/businesses', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await Svc.list(req.query) }); } catch (e) { next(e) } });
r.post('/businesses/create', authToken(true), limiter, async (req, res, next) => { try { res.json({ ok: true, data: await Svc.create(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/businesses/open', authToken(true), limiter, async (req, res, next) => { try { res.json({ ok: true, data: await Svc.setOpen(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/businesses/hire', authToken(true), limiter, async (req, res, next) => { try { res.json({ ok: true, data: await Svc.hire(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/businesses/fire', authToken(true), limiter, async (req, res, next) => { try { res.json({ ok: true, data: await Svc.fire(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/businesses/item', authToken(true), limiter, async (req, res, next) => { try { res.json({ ok: true, data: await Svc.setItem(req.body || {}, actor(req)) }); } catch (e) { next(e) } });

export default r;