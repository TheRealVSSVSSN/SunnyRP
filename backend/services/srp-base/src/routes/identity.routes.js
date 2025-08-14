// src/routes/identity.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
export const identityRouter = Router();

// POST /v1/players/link  -> { primary, identifiers[], ip }
identityRouter.post('/v1/players/link', (req, res) => {
    const { primary, identifiers, ip } = req.body || {};
    if (!primary || !Array.isArray(identifiers)) return fail(req, res, 'INVALID_INPUT', 'Missing primary/identifiers');
    // TODO: upsert user + identifiers, update last IP, load bans & scopes
    // Stubbed response while DB is being wired:
    return ok(req, res, {
        banned: false,
        banReason: null,
        scopes: []
    });
});

// GET /v1/permissions/:playerId -> { scopes:[] }
identityRouter.get('/v1/permissions/:playerId', (req, res) => ok(req, res, {
    scopes: []
}));