import { Router } from 'express';
import hmacVerify from '../middleware/hmacVerify.js';
import * as configSvc from '../services/config.service.js';

const router = Router();

// Game server calls with HMAC
router.get('/live', hmacVerify(), async (req, res) => {
    const cfg = await configSvc.getLive();
    res.json(cfg); // base expects raw snapshot (not wrapped)
});

router.patch('/live', hmacVerify(), async (req, res) => {
    try {
        const merged = await configSvc.patchLive(req.body || {});
        res.json(merged); // base expects merged snapshot back
    } catch (e) {
        res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: e.message } });
    }
});

// Optional: feature flags (admin console can later use JWT)
router.get('/flags', hmacVerify(), async (req, res) => {
    const rows = await configSvc.listFeatureFlags();
    res.json({ ok: true, flags: rows });
});

router.post('/flags', hmacVerify(), async (req, res) => {
    try {
        const { name, enabled } = req.body || {};
        if (!name) return res.status(400).json({ ok: false, error: { code: 'NAME_REQUIRED', message: 'name required' } });
        const row = await configSvc.setFeatureFlag(name, !!enabled);
        res.json({ ok: true, flag: row });
    } catch (e) {
        res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: e.message } });
    }
});

export default router;