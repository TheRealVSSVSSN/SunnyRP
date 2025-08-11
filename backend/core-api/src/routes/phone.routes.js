import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Phone from '../services/phone.service.js';
import * as SMS from '../services/sms.service.js';
import * as Contacts from '../services/contacts.service.js';
import * as Ads from '../services/ads.service.js';

const r = Router();
const limiterFast = rateLimit({ windowMs: 1000, max: 300 });
const limiterSMS = rateLimit({ windowMs: 1000, max: 120 });

const actor = (req) => ({ user_id: Number(req.header('X-SRP-UserId') || 0), char_id: Number(req.header('X-SRP-CharId') || 0) });

/* Phones */
r.get('/phones', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await Phone.list(req.query, actor(req)) }); } catch (e) { next(e) } });
r.post('/phones/ensure', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Phone.ensure(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/phones/claim', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Phone.claim(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.get('/phones/number/:number', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await Phone.byNumber(req.params.number) }); } catch (e) { next(e) } });

/* SMS */
r.post('/sms/send', authToken(true), limiterSMS, async (req, res, next) => { try { res.json({ ok: true, data: await SMS.send(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.get('/sms/thread', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await SMS.thread(req.query || {}, actor(req)) }); } catch (e) { next(e) } });
r.get('/sms/inbox', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await SMS.inbox(req.query || {}, actor(req)) }); } catch (e) { next(e) } });

/* Contacts */
r.get('/contacts', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await Contacts.list(req.query || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/contacts', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Contacts.create(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.put('/contacts/:id', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Contacts.update(req.params.id, req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.delete('/contacts/:id', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Contacts.remove(req.params.id, req.query || {}, actor(req)) }); } catch (e) { next(e) } });

/* Ads */
r.get('/ads', authToken(true), async (req, res, next) => { try { res.json({ ok: true, data: await Ads.list(req.query || {}) }); } catch (e) { next(e) } });
r.post('/ads', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Ads.create(req.body || {}, actor(req)) }); } catch (e) { next(e) } });
r.post('/ads/deactivate', authToken(true), limiterFast, async (req, res, next) => { try { res.json({ ok: true, data: await Ads.deactivate(req.body || {}, actor(req)) }); } catch (e) { next(e) } });

export default r;