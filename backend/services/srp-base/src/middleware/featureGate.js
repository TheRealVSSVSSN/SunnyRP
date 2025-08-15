// src/middleware/featureGate.js
import { getFeature } from '../services/features.service.js';
import { fail } from '../utils/respond.js';

/**
 * Feature gate middleware.
 * Reads features from config_kv (key='features') via cached service.
 * If feature is disabled => 404 with standard envelope (hides surface).
 */
export function featureGate(featureKey, defaultOn = true) {
    return async (req, res, next) => {
        try {
            const enabled = await getFeature(featureKey, defaultOn);
            if (!enabled) {
                return fail(req, res, 'NOT_FOUND', 'Feature disabled'); // 404
            }
            return next();
        } catch (err) {
            return next(err);
        }
    };
}