// src/middleware/authToken.js
import crypto from 'crypto';
import { createClient } from 'redis';
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

let redis;
/** nonce store for internal HMAC if no Redis */
const memNonces = new Map(); // key -> expiryMs

async function seenNonce(key, ttlSec) {
  if (env.REDIS_URL) {
    if (!redis) {
      redis = createClient({ url: env.REDIS_URL });
      await redis.connect();
    }
    const ok = await redis.set(`intreplay:${key}`, '1', { NX: true, EX: ttlSec });
    return ok !== null;
  }
  const now = Date.now();
  // cleanup
  for (const [k, v] of memNonces.entries()) {
    if (v < now) memNonces.delete(k);
  }
  if (memNonces.has(key)) return false;
  memNonces.set(key, now + ttlSec * 1000);
  return true;
}

function verifyInternalHmac(req) {
  const ts = req.header('X-Internal-Ts');
  const nonce = req.header('X-Internal-Nonce');
  const sig = req.header('X-Internal-Sig');
  if (!ts || !nonce || !sig) return false;

  const skew = Math.abs(Math.floor(Date.now() / 1000) - parseInt(ts, 10));
  if (skew > env.INTERNAL_HMAC_TTL_SEC) return false;

  const method = req.method.toUpperCase();
  const path = req.originalUrl.split('?')[0];
  const canonical = `${ts}\n${nonce}\n${method}\n${path}\n${req.rawBody || ''}`;
  const calc = crypto.createHmac('sha256', env.INTERNAL_HMAC_SECRET)
    .update(canonical, 'utf8')
    .digest('hex');

  if (calc !== sig) return false;
  return { ts, nonce };
}

/**
 * Auth middleware
 * - Accepts X-API-Token for all routes (FiveM -> API).
 * - If ENABLE_SERVICE_TOKENS=true, accepts X-Service-Token for SAFE methods (read-only).
 * - If ENABLE_INTERNAL_HMAC=true, accepts X-Internal-* HMAC for any method (inter-service).
 *   When a service token or internal HMAC is used, req.isService = true (replayGuard skips).
 */
export function authToken(/* legacy signature preserved */) {
  return async (req, res, next) => {
    // Primary API token
    const api = req.header('X-API-Token');
    if (api && api === env.API_TOKEN) {
      req.isService = false;
      return next();
    }

    // Read-only service token
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

    // Internal HMAC
    if (env.ENABLE_INTERNAL_HMAC) {
      const verified = verifyInternalHmac(req);
      if (verified) {
        const key = `${verified.nonce}:${verified.ts}`;
        const fresh = await seenNonce(key, env.INTERNAL_HMAC_TTL_SEC);
        if (!fresh) {
          return fail(req, res, 'UNAUTHENTICATED', 'REPLAY');
        }
        req.isService = true;
        return next();
      }
    }

    return fail(req, res, 'UNAUTHENTICATED', 'Missing or invalid token');
  };
}