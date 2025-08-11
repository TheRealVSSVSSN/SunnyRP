const express = require('express');
const router = express.Router();

const hmacVerify = require('../middleware/hmacVerify');
const configSvc = require('../services/config.service');

// Game server calls these with HMAC; admin console can later use JWT scopes.
router.get('/live', hmacVerify(), async (req, res) => {
    const cfg = await configSvc.getLive();
    res.json(cfg);
});

router.patch('/live', hmacVerify(), async (req, res) => {
    try {
        const merged = await configSvc.patchLive(req.body || {});
        // In the future we can push an inbox event to game here.
        res.json(merged);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
});

// Optional: feature flags endpoints (for admin later)
router.get('/flags', hmacVerify(), async (req, res) => {
    res.json(await configSvc.listFeatureFlags());
});

router.post('/flags', hmacVerify(), async (req, res) => {
    const { name, enabled } = req.body || {};
    if (!name) return res.status(400).json({ error: 'name required' });
    const row = await configSvc.setFeatureFlag(name, !!enabled);
    res.json(row);
});

module.exports = router;