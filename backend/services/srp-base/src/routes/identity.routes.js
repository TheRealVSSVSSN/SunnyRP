// src/routes/identity.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { validate } from '../middleware/validate.js';
import { PlayerLinkRequestSchema, PermissionsPathSchema } from '../schemas/identity.schemas.js';
import {
    findUserIdByAnyIdentifier,
    createUser,
    addIdentifiers,
    touchUser,
    getBanStatus,
    getScopes
} from '../repositories/identity.repo.js';

export const identityRouter = Router();

/**
 * POST /v1/players/link
 * body: { primary: 'license'|'steam'|'discord', identifiers: string[], ip?: string }
 * response: { banned: boolean, banReason: string|null, scopes: string[], userId: number }
 */
identityRouter.post(
    '/v1/players/link',
    validate({ body: PlayerLinkRequestSchema }),
    async (req, res, next) => {
        try {
            const { primary, identifiers, ip } = req.body;

            // Find existing user by any provided identifier
            let userId = await findUserIdByAnyIdentifier(identifiers);

            // Create user if not found
            if (!userId) {
                userId = await createUser(primary);
            }

            // Upsert identifiers + IP and touch last_seen / last_ip
            await addIdentifiers(userId, identifiers, ip);
            await touchUser(userId, ip);

            // Ban check + scopes
            const { banned, banReason } = await getBanStatus(userId);
            const scopes = await getScopes(userId);

            return ok(req, res, { banned, banReason, scopes, userId });
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * GET /v1/permissions/:playerId
 * response: { scopes: string[] }
 */
identityRouter.get(
    '/v1/permissions/:playerId',
    validate({ params: PermissionsPathSchema }),
    async (req, res, next) => {
        try {
            const { playerId } = req.params;
            const scopes = await getScopes(playerId);
            return ok(req, res, { scopes });
        } catch (err) {
            return next(err);
        }
    }
);