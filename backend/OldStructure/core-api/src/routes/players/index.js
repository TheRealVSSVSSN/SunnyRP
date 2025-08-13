// players.routes.js
import { Router } from 'express';
import { link as linkSvc } from '../services/players/index.js';
import eitherAuth from '../middleware/eitherAuth.js'; // HMAC or API token (server-only)

const router = Router();

/**
 * POST /players/link
 * Body: { name?: string, identifiers: { [type]: value }, primary?: string, meta?: object }
 * Returns: { ok, playerId, banned, banReason, verified, whitelisted, scopes }
 *
 * Security: server-only (FiveM), enforced by HMAC/auth middlewares configured in bootstrap.
 */
router.post('/players/link', eitherAuth(), async (req, res) => {
    try {
        const { name, identifiers, primary, meta } = req.body || {};
        if (!identifiers || typeof identifiers !== 'object') {
            return res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: 'identifiers required' } });
        }

        const result = await linkSvc({ name, identifiers, primary, meta });
        return res.json({ ok: true, ...result });
    } catch (err) {
        const message = err?.message || 'link_failed';
        return res.status(500).json({ ok: false, error: { code: 'LINK_FAILED', message } });
    }
});

export default router;