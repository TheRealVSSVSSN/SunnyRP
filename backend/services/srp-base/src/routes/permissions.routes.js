// src/routes/permissions.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { validate } from '../middleware/validate.js';
import { rateLimit } from '../middleware/rateLimit.js';
import { env } from '../config/env.js';
import { grantRole, revokeRole } from '../repositories/roles.repo.js';
import { isAdmin } from '../repositories/admin.repo.js';
import { idempotentRoute } from '../middleware/idempotency.js';

export const permissionsRouter = Router();

/**
 * POST /v1/permissions/grant
 */
permissionsRouter.post(
    '/v1/permissions/grant',
    rateLimit({
        key: (req) => `perm:${req.body?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_PERMISSIONS
    }),
    validate({
        body: (z) => z.object({
            actorUserId: z.coerce.number(),
            targetUserId: z.coerce.number(),
            role: z.string().min(2)
        })
    }),
    idempotentRoute(async (req, res) => {
        const { actorUserId, targetUserId, role } = req.body;
        if (!(await isAdmin(actorUserId))) {
            return fail(req, res, 'FORBIDDEN', 'Admin scope required');
        }
        const r = await grantRole(targetUserId, role);
        return ok(req, res, { userId: targetUserId, role: r, action: 'granted' });
    })
);

/**
 * POST /v1/permissions/revoke
 */
permissionsRouter.post(
    '/v1/permissions/revoke',
    rateLimit({
        key: (req) => `perm:${req.body?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_PERMISSIONS
    }),
    validate({
        body: (z) => z.object({
            actorUserId: z.coerce.number(),
            targetUserId: z.coerce.number(),
            role: z.string().min(2)
        })
    }),
    idempotentRoute(async (req, res) => {
        const { actorUserId, targetUserId, role } = req.body;
        if (!(await isAdmin(actorUserId))) {
            return fail(req, res, 'FORBIDDEN', 'Admin scope required');
        }
        await revokeRole(targetUserId, role);
        return ok(req, res, { userId: targetUserId, role, action: 'revoked' });
    })
);