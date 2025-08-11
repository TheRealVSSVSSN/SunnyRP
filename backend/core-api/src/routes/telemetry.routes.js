import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import replayGuard from '../middleware/replayGuard.js';
import burstShield from '../middleware/burstShield.js';
import * as Tel from '../services/telemetry.service.js';
import * as Al from '../services/alerts.service.js';

const r = Router();
const actor = (req) => ({ user_id: Number(req.header('X-SRP-UserId') || 0), char_id: Number(req.header('X-SRP-CharId') || 0) });

/* Ingest generic telemetry */
r.post('/telemetry/events', authToken(true), replayGuard, burstShield, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Tel.ingest(req.body || {}, actor(req)) });
    } catch (e) { next(e) }
});

/* Report anomaly (server decides; backend records+alerts) */
r.post('/telemetry/anomaly', authToken(true), replayGuard, burstShield, async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Tel.anomaly(String(req.body.kind || 'unknown'), req.body.meta || {}, actor(req)) });
    } catch (e) { next(e) }
});

/* Staff alert polling */
r.get('/admin/alerts', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Al.list(req.query || {}) });
    } catch (e) { next(e) }
});
r.post('/admin/alerts/ack', authToken(true), async (req, res, next) => {
    try {
        res.json({ ok: true, data: await Al.ack(req.body || {}) });
    } catch (e) { next(e) }
});

export default r;