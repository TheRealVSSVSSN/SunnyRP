import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { ingestPosition } from '../services/map/index.js';

const router = Router();

/**
 * POST /map/position
 * { userId, characterId, position:{x,y,z,heading}, routing_bucket?, speed?, ts? }
 * Headers: X-API-Token, X-SRP-Telemetry: true|false
 */
router.post('/map/position', authToken(true), async (req, res, next) => {
    try {
        const { userId, characterId, position, routing_bucket, speed, ts } = req.body || {};
        if (!userId || !characterId || !position) {
            const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e;
        }
        const data = await ingestPosition({ req, userId, characterId, position, routing_bucket, speed, ts });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;