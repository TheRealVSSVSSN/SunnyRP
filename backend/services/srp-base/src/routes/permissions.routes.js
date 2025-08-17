// backend/services/srp-base/src/routes/permissions.routes.js
import { Router } from 'express';
import * as rolesRepo from '../repositories/roles.repo.js';
import { ok } from '../utils/respond.js';

export const permissionsRouter = Router();

// tiny in-memory TTL cache to reduce DB chatter
const cache = new Map(); // key: playerId, val: { exp, scopes[] }
const TTL_MS = 5000;

permissionsRouter.get('/v1/permissions/:playerId', async (req, res, next) => {
    try {
        const playerId = String(req.params.playerId);
        const now = Date.now();
        const hit = cache.get(playerId);
        if (hit && hit.exp > now) {
            return ok(res, { playerId, scopes: hit.scopes });
        }

        const scopes = await rolesRepo.getScopesForPlayer(playerId);
        const arr = Array.isArray(scopes) ? scopes : [];
        cache.set(playerId, { exp: now + TTL_MS, scopes: arr });
        ok(res, { playerId, scopes: arr });
    } catch (e) { next(e); }
});