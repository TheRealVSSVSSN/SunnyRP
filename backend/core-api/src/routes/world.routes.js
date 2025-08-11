const express = require('express');
const router = express.Router();
const hmacVerify = require('../middleware/hmacVerify');
const world = require('../services/world.service');

router.get('/time', hmacVerify(), async (req, res) => {
    res.json(await world.getTime());
});

router.post('/time', hmacVerify(), async (req, res) => {
    try {
        const { override } = req.body || {};
        if (!override) return res.status(400).json({ error: 'override HH:MM required' });
        const merged = await world.setTimeOverride(override);
        res.json({ ok: true, config: merged.Time || {} });
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
});

router.get('/weather', hmacVerify(), async (req, res) => {
    res.json(await world.getWeather());
});

router.post('/weather', hmacVerify(), async (req, res) => {
    try {
        const { type } = req.body || {};
        if (!type) return res.status(400).json({ error: 'type required' });
        const merged = await world.setWeather(type);
        res.json({ ok: true, config: merged.Weather || {} });
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
});

module.exports = router;