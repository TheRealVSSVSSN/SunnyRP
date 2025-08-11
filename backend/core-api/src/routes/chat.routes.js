import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import { logChat, getHistory } from '../services/chat.service.js';

const router = Router();

const chatLimiter = rateLimit({
    windowMs: 10 * 1000,
    max: 60, // 60 messages per 10s per token (server-to-backend only)
    keyGenerator: (req) => req.headers['x-api-token'] || req.ip
});

/**
 * POST /chat/log
 * { userId, characterId, channel, message, position?, routing_bucket?, src? }
 * Header: X-API-Token, X-Profanity: true|false (optional)
 */
router.post('/chat/log', authToken(true), chatLimiter, async (req, res, next) => {
    try {
        const { userId, characterId, channel, message, position, routing_bucket, src } = req.body || {};
        if (!userId || !channel || !message) {
            const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e;
        }
        const profanity = (req.headers['x-profanity'] ?? 'true').toString().toLowerCase() !== 'false';
        const data = await logChat({ userId, characterId, channel, message, position, routing_bucket, src, profanity });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

/**
 * GET /chat/history?charId=..&limit=50
 */
router.get('/chat/history', authToken(true), async (req, res, next) => {
    try {
        const characterId = parseInt(req.query.charId, 10);
        const limit = Math.min(parseInt(req.query.limit || '50', 10), 200);
        if (!characterId) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
        const data = await getHistory({ characterId, limit });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;