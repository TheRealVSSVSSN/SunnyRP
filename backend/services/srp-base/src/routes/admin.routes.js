// src/routes/admin.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { validate } from '../middleware/validate.js';
import { rateLimit } from '../middleware/rateLimit.js';
import { env } from '../config/env.js';
import { readAudit } from '../repositories/audit.repo.js';
import {
    ensureUserByIdentifiers,
    isAdmin,
    banUser,
    kickUser
} from '../repositories/admin.repo.js';

import { findUserIdByAnyIdentifier } from '../repositories/identity.repo.js';

export const adminRouter = Router();

/**
 * POST /v1/admin/ban
 * body: {
 *   actorUserId: number,
 *   targetUserId?: number,
 *   primary?: 'license'|'steam'|'discord',
 *   identifiers?: string[],
 *   reason?: string,
 *   active?: boolean
 * }
 */
adminRouter.post(
    '/v1/admin/ban',
    rateLimit({
        key: (req) => `ban:${req.body?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_BAN
    }),
    validate({
        body: (z) => z.object({
            actorUserId: z.coerce.number(),
            targetUserId: z.coerce.number().optional(),
            primary: z.enum(['license', 'steam', 'discord']).optional(),
            identifiers: z.array(z.string().min(3)).optional(),
            reason: z.string().optional(),
            active: z.coerce.boolean().default(true)
        })
    }),
    async (req, res, next) => {
        try {
            const { actorUserId, targetUserId, primary, identifiers, reason, active } = req.body;

            if (!(await isAdmin(actorUserId))) {
                return fail(req, res, 'FORBIDDEN', 'Admin scope required');
            }

            let targetId = targetUserId || null;
            if (!targetId) {
                if (!identifiers || identifiers.length === 0) {
                    return fail(req, res, 'INVALID_INPUT', 'Provide targetUserId or identifiers[]');
                }
                // resolve or create target user
                targetId = await ensureUserByIdentifiers(primary || 'license', identifiers, null);
            } else {
                // sanity check: exists?
                const found = await findUserIdByAnyIdentifier([`user:${targetId}`]).catch(() => null);
                (void found); // non-fatal; we allow direct ban by id even if not found in identifiers
            }

            const result = await banUser(actorUserId, targetId, reason || null, active !== false);
            return ok(req, res, result);
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * POST /v1/admin/kick
 * body: { actorUserId: number, targetUserId: number, reason?: string }
 * (Records audit; actual kick can be performed by FiveM base via separate channel/outbox later.)
 */
adminRouter.post(
    '/v1/admin/kick',
    rateLimit({
        key: (req) => `kick:${req.body?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_BAN
    }),
    validate({
        body: (z) => z.object({
            actorUserId: z.coerce.number(),
            targetUserId: z.coerce.number(),
            reason: z.string().optional()
        })
    }),
    async (req, res, next) => {
        try {
            const { actorUserId, targetUserId, reason } = req.body;

            if (!(await isAdmin(actorUserId))) {
                return fail(req, res, 'FORBIDDEN', 'Admin scope required');
            }

            const result = await kickUser(actorUserId, targetUserId, reason || null);
            return ok(req, res, result);
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * GET /v1/admin/audit?userId=&limit=
 */
adminRouter.get(
    '/v1/admin/audit',
    rateLimit({
        key: (req) => `audit:${req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_AUDIT_READ
    }),
    validate({
        query: (z) => z.object({
            userId: z.coerce.number().optional(),
            limit: z.coerce.number().min(1).max(200).default(50)
        })
    }),
    async (req, res, next) => {
        try {
            const { userId, limit } = req.query;
            const entries = await readAudit({ userId: userId || null, limit: limit || 50 });
            return ok(req, res, { entries });
        } catch (err) {
            return next(err);
        }
    }
);