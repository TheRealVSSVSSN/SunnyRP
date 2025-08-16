// src/middleware/authToken.js
import { env } from '../config/env.js';
import { fail } from '../utils/respond.js';

function parseServiceTokens(csv) {
  const set = new Set();
  for (const raw of (csv || '').split(',').map(s => s.trim()).filter(Boolean)) {
    const parts = raw.split(':');
    const token = parts.length === 2 ? parts[1] : parts[0];
    if (token) set.add(token);
  }
  return set;
}

const SERVICE_TOKEN_SET = parseServiceTokens(env.SERVICE_TOKENS);
const SAFE_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);

/**
 * Auth middleware
 * - Accepts primary X-API-Token for all routes (FiveM -> API).
 * - If ENABLE_SERVICE_TOKENS=true, also accepts X-Service-Token for SAFE methods only (read-only).
 *   When a service token is used, req.isService = true (and replayGuard will skip).
 */
export function authToken(/* primaryToken kept for backward signature */) {
  return (req, res, next) => {
    const api = req.header('X-API-Token');
    if (api && api === env.API_TOKEN) {
      req.isService = false;
      return next();
    }

    if (env.ENABLE_SERVICE_TOKENS) {
      const svc = req.header('X-Service-Token');
      if (svc && SERVICE_TOKEN_SET.has(svc)) {
        if (!SAFE_METHODS.has(req.method)) {
          return fail(req, res, 'FORBIDDEN', 'Service token is read-only');
        }
        req.isService = true;
        return next();
      }
    }

    return fail(req, res, 'UNAUTHENTICATED', 'Missing or invalid token');
  };
}