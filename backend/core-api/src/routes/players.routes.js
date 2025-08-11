import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { linkPlayer, getPlayer } from '../services/players.service.js';

const router = Router();

// POST /players/link
router.post('/players/link', authToken(true), async (req, res, next) => {
    try {
        const { identifiers = {}, primary = 'license', ip = null } = req.body || {};
        const result = await linkPlayer({ identifiers, primary, ip });
        res.json({ ok: true, data: result });
    } catch (e) { next(e); }
});

// GET /players/:userId
router.get('/players/:userId', authToken(true), async (req, res, next) => {
    try {
        const data = await getPlayer(Number(req.params.userId));
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;