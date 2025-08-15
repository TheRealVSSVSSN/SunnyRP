// src/routes/config.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { getAllConfig, setConfig } from '../repositories/config.repo.js';
import { env } from '../config/env.js';
import { recordAudit } from '../repositories/audit.repo.js';
import { invalidateFeaturesCache } from '../services/features.service.js';

export const configRouter = Router();

/**
 * GET /v1/config/live
 * Returns all config key/values.
 */
configRouter.get('/v1/config/live', async (req, res, next) => {
    try {
        const kv = await getAllConfig();
        return ok(req, res, kv);
    } catch (err) {
        return next(err);
    }
});

/**
 * POST /v1/config/live
 * body: { key: string, value: any, actorUserId?: number }
 * Requires ENABLE_CONFIG_WRITE=true (env guard).
 * If key === 'features', feature cache is invalidated immediately.
 */
configRouter.post('/v1/config/live', async (req, res, next) => {
    try {
        if (!env.ENABLE_CONFIG_WRITE) {
            return fail(req, res, 'FORBIDDEN', 'Config writes disabled');
        }
        const { key, value, actorUserId } = req.body || {};
        if (!key) {
            return fail(req, res, 'INVALID_INPUT', 'Missing key');
        }
        await setConfig(key, value);
        if (key === 'features') {
            await invalidateFeaturesCache();
        }
        if (actorUserId) {
            await recordAudit(actorUserId, null, 'config.set', { key, value });
        }
        return ok(req, res, { key, value });
    } catch (err) {
        return next(err);
    }
});