import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { fetchStatus, applyStatusPatch } from '../services/status/index.js';

const router = Router();

// GET /status/:charId
router.get('/status/:charId', authToken(true), async (req, res, next) => {
    try {
        const charId = parseInt(req.params.charId, 10);
        if (!charId) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
        const data = await fetchStatus(charId);
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /status/:charId/patch
router.post('/status/:charId/patch', authToken(true), async (req, res, next) => {
    try {
        const charId = parseInt(req.params.charId, 10);
        if (!charId) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
        const data = await applyStatusPatch(charId, req.body || {});
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;