import { Router } from 'express';
import hmacVerify from '../middleware/hmacVerify.js';
import * as world from '../services/world/index.js';

const router = Router();

router.get('/time', hmacVerify(), async (req, res) => {
    res.json(await world.getTime());
});

router.post('/time', hmacVerify(), async (req, res) => {
    try {
        const { override } = req.body || {};
        if (!override) return res.status(400).json({ ok: false, error: { code: 'OVERRIDE_REQUIRED', message: 'override HH:MM required' } });
        const cfg = await world.setTimeOverride(override);
        res.json({ ok: true, time: cfg });
    } catch (e) {
        res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: e.message } });
    }
});

router.get('/weather', hmacVerify(), async (req, res) => {
    res.json(await world.getWeather());
});

router.post('/weather', hmacVerify(), async (req, res) => {
    try {
        const { type } = req.body || {};
        if (!type) return res.status(400).json({ ok: false, error: { code: 'TYPE_REQUIRED', message: 'type required' } });
        const cfg = await world.setWeather(type);
        res.json({ ok: true, weather: cfg });
    } catch (e) {
        res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: e.message } });
    }
});

export default router;