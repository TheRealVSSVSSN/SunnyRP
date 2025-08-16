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
            try { await recordAudit(actorUserId, null, 'config.set', { key, value }); } catch { }
        }
        return ok(req, res, { key, value });
    } catch (err) {
        return next(err);
    }
});

/**
 * LEGACY (back-compat): PATCH /config/live
 * Accepts a partial patch like { features: {...}, settings: {...} } and merges into current live config.
 * Returns the full, updated live config so callers can apply it locally.
 */
configRouter.patch('/config/live', async (req, res, next) => {
    try {
        if (!env.ENABLE_CONFIG_WRITE) {
            return fail(req, res, 'FORBIDDEN', 'Config writes disabled');
        }

        const patch = (req.body && typeof req.body === 'object') ? req.body : {};
        const current = await getAllConfig();

        const nextLive = { features: current.features || {}, settings: current.settings || {} };

        // Shallow-deep merge for features/settings objects
        function mergeInto(dst, src) {
            if (!src || typeof src !== 'object') return;
            for (const [k, v] of Object.entries(src)) {
                if (v && typeof v === 'object' && !Array.isArray(v)) {
                    dst[k] = dst[k] && typeof dst[k] === 'object' ? { ...dst[k] } : {};
                    mergeInto(dst[k], v);
                } else {
                    dst[k] = v;
                }
            }
        }

        let featuresChanged = false;
        let settingsChanged = false;

        if (patch.features && typeof patch.features === 'object') {
            const before = JSON.stringify(nextLive.features || {});
            mergeInto(nextLive.features, patch.features);
            featuresChanged = JSON.stringify(nextLive.features || {}) !== before;
        }

        if (patch.settings && typeof patch.settings === 'object') {
            const before = JSON.stringify(nextLive.settings || {});
            mergeInto(nextLive.settings, patch.settings);
            settingsChanged = JSON.stringify(nextLive.settings || {}) !== before;
        }

        if (!featuresChanged && !settingsChanged) {
            // Nothing to change; return current snapshot
            return ok(req, res, nextLive);
        }

        if (featuresChanged) {
            await setConfig('features', nextLive.features);
            try { await invalidateFeaturesCache(); } catch { }
        }
        if (settingsChanged) {
            await setConfig('settings', nextLive.settings);
        }

        const actorUserId = req.body?.actorUserId;
        if (actorUserId) {
            try { await recordAudit(actorUserId, null, 'config.patch', patch); } catch { }
        }

        return ok(req, res, nextLive);
    } catch (err) {
        return next(err);
    }
});