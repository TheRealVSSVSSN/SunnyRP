import { Router } from 'express';
import hmacVerify from '../middleware/hmacVerify.js';
import * as notify from '../services/notify/index.js';

const router = Router();

// Game server calls this with { channel, content?, embed? }
router.post('/emit', hmacVerify(), async (req, res) => {
    try {
        const result = await notify.emit(req.body || {});
        res.json(result);
    } catch (e) {
        res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: e.message } });
    }
});

export default router;