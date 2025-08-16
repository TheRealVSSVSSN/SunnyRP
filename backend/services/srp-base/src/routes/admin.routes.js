// src/routes/admin.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { validate } from '../middleware/validate.js';
import { rateLimit } from '../middleware/rateLimit.js';
import { env } from '../config/env.js';
import { readAudit } from '../repositories/audit.repo.js';
import {
    ensureUserByIdentifiers,
    banUser,
    kickUser,
    listBans
} from '../repositories/admin.repo.js';
import {
    findUserIdByAnyIdentifier,
    resolveUserByIdentifier,
    getUserWithIdentifiers,
    searchUsersByIdentifierOrName
} from '../repositories/identity.repo.js';
import { idempotentRoute } from '../middleware/idempotency.js';
import { requireScopes } from '../middleware/requireScopes.js';

export const adminRouter = Router();

/**
 * POST /v1/admin/ban
 * requires scope: admin OR admin.ban
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
    requireScopes(req => req.body.actorUserId, ['admin', 'admin.ban']),
    idempotentRoute(async (req, res) => {
        const { actorUserId, targetUserId, primary, identifiers, reason, active } = req.body;

        let targetId = targetUserId || null;
        if (!targetId) {
            if (!identifiers || identifiers.length === 0) {
                return fail(req, res, 'INVALID_INPUT', 'Provide targetUserId or identifiers[]');
            }
            targetId = await ensureUserByIdentifiers(primary || 'license', identifiers, null);
        } else {
            const found = await findUserIdByAnyIdentifier([`user:${targetId}`]).catch(() => null);
            (void found);
        }

        const result = await banUser(actorUserId, targetId, reason || null, active !== false);
        return ok(req, res, result);
    })
);

/**
 * POST /v1/admin/kick
 * requires scope: admin OR admin.kick
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
    requireScopes(req => req.body.actorUserId, ['admin', 'admin.kick']),
    idempotentRoute(async (req, res) => {
        const { actorUserId, targetUserId, reason } = req.body;
        const result = await kickUser(actorUserId, targetUserId, reason || null);
        return ok(req, res, result);
    })
);

/**
 * GET /v1/admin/audit
 * query: { userId?, limit?, action?, after?, before? }
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
            limit: z.coerce.number().min(1).max(200).default(50),
            action: z.string().optional(),
            after: z.string().optional(),
            before: z.string().optional()
        })
    }),
    async (req, res, next) => {
        try {
            const { userId, limit, action, after, before } = req.query;
            const entries = await readAudit({
                userId: userId || null,
                limit: limit || 50,
                action: action || null,
                after: after || null,
                before: before || null
            });
            return ok(req, res, { entries });
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * GET /v1/admin/users/resolve?actorUserId=&identifier=
 * requires scope: admin OR admin.users
 */
adminRouter.get(
    '/v1/admin/users/resolve',
    rateLimit({
        key: (req) => `adminusers:${req.query?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_ADMIN_READ
    }),
    validate({
        query: (z) => z.object({
            actorUserId: z.coerce.number(),
            identifier: z.string().min(3)
        })
    }),
    requireScopes(req => Number(req.query.actorUserId), ['admin', 'admin.users']),
    async (req, res, next) => {
        try {
            const { identifier } = req.query;
            const user = await resolveUserByIdentifier(identifier);
            if (!user) {
                return fail(req, res, 'NOT_FOUND', 'No user for identifier');
            }
            const full = await getUserWithIdentifiers(user.id);
            return ok(req, res, { user: full });
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * GET /v1/admin/users/search?actorUserId=&q=&limit=
 * requires scope: admin OR admin.users
 * prefix matches identifiers or display_name
 */
adminRouter.get(
    '/v1/admin/users/search',
    rateLimit({
        key: (req) => `adminsearch:${req.query?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_ADMIN_READ
    }),
    validate({
        query: (z) => z.object({
            actorUserId: z.coerce.number(),
            q: z.string().min(2),
            limit: z.coerce.number().min(1).max(100).default(20)
        })
    }),
    requireScopes(req => Number(req.query.actorUserId), ['admin', 'admin.users']),
    async (req, res, next) => {
        try {
            const { q, limit } = req.query;
            const results = await searchUsersByIdentifierOrName(q, limit);
            return ok(req, res, { results });
        } catch (err) {
            return next(err);
        }
    }
);

/**
 * GET /v1/admin/bans/list?actorUserId=&userId=&active=true&limit=
 * requires scope: admin OR admin.ban
 */
adminRouter.get(
    '/v1/admin/bans/list',
    rateLimit({
        key: (req) => `bans:${req.query?.actorUserId || req.ip}`,
        windowSec: env.RATE_LIMIT_WINDOW_SEC,
        limit: env.RATE_LIMIT_MAX_ADMIN_READ
    }),
    validate({
        query: (z) => z.object({
            actorUserId: z.coerce.number(),
            userId: z.coerce.number().optional(),
            active: z.union([z.string(), z.boolean()]).optional(), // allow 'true'/'false'
            limit: z.coerce.number().min(1).max(200).default(50)
        })
    }),
    requireScopes(req => Number(req.query.actorUserId), ['admin', 'admin.ban']),
    async (req, res, next) => {
        try {
            const userId = req.query.userId ?? null;
            const activeRaw = req.query.active;
            let active = null;
            if (typeof activeRaw !== 'undefined') {
                active = String(activeRaw).toLowerCase() === 'true' ? true :
                    String(activeRaw).toLowerCase() === 'false' ? false : null;
            }
            const list = await listBans({ userId, active, limit: req.query.limit || 50 });
            return ok(req, res, { bans: list });
        } catch (err) {
            return next(err);
        }
    }
);