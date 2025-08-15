// src/middleware/requireScopes.js
import { fail } from '../utils/respond.js';
import { getUserScopesCached } from '../services/scopesCache.service.js';

/**
 * Enforces that the ACTOR (by userId resolver) has at least one of the required scopes.
 * `actorUserIdResolver` can read from req (e.g., req.body.actorUserId)
 * Example: requireScopes(req=>req.body.actorUserId, ['admin','admin.ban'])
 */
export function requireScopes(actorUserIdResolver, requiredScopes = []) {
    return async (req, res, next) => {
        try {
            const actorId = typeof actorUserIdResolver === 'function'
                ? actorUserIdResolver(req)
                : actorUserIdResolver;

            if (!actorId) {
                return fail(req, res, 'INVALID_INPUT', 'Missing actorUserId');
            }

            const scopes = await getUserScopesCached(actorId);

            // admin is super-scope
            const has =
                scopes.includes('admin') ||
                requiredScopes.some(s => scopes.includes(s));

            if (!has) {
                return fail(req, res, 'FORBIDDEN', 'Insufficient scope');
            }

            return next();
        } catch (err) {
            return next(err);
        }
    };
}