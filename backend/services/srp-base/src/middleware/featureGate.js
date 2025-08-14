// src/middleware/featureGate.js
/**
 * Example feature gate (expand per-route as features roll out).
 */
export function featureGate(_config = {}) {
    return (_req, _res, next) => next();
}