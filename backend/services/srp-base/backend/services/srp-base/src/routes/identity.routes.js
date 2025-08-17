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
import { idempotentRoute } from '../middleware/idempotency.js';

export const identityRouter = Router();

/**
 * POST /v1/players/link
 * body: { primary: 'license'|'steam'|'discord', identifiers: string[], ip?: string }
 * response: { banned: boolean, banReason: string|null, scopes: string[], userId: number }
 */
identityRouter.post(
    '/v1/players/link',
    validate({ body: PlayerLinkRequestSchema }),
    idempotentRoute(async (req, res) => {
        const { primary, identifiers, ip } = req.body;

        let userId = await findUserIdByAnyIdentifier(identifiers);

        if (!userId) {
            userId = await createUser(primary);
        }

        await addIdentifiers(userId, identifiers, ip);
        await touchUser(userId, ip);

        const { banned, banReason } = await getBanStatus(userId);
        const scopes = await getScopes(userId);

        return ok(req, res, { banned, banReason, scopes, userId });
    })
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