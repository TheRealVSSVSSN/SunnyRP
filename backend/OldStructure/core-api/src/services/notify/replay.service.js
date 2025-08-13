// src/services/replay.service.js
import crypto from 'crypto';
import { getRedis } from '../bootstrap/redis.js';

const ttl = Number(process.env.REPLAY_TTL_SECONDS || 30);   // seconds we accept a (ts,nonce) once
const skew = Number(process.env.REPLAY_ALLOWED_SKEW_SECONDS || 20); // max clock skew (s)

// Fallback: instance-local in-memory nonce store with TTL
const seen = new Map(); // key -> expiresAt(ms)
function prune() {
    const now = Date.now();
    for (const [k, exp] of seen) if (exp <= now) seen.delete(k);
}
setInterval(prune, 5000).unref();

/**
 * Verify HMAC + prevent replay using Redis SET NX (or in-memory fallback).
 * Canonical string: `${ts}\n${nonce}\n${METHOD}\n${path}\n${body}`
 */
export async function verify(req, apiToken) {
    const ts = Number(req.header('X-Ts') || 0);
    const nonce = String(req.header('X-Nonce') || '');
    const sig = String(req.header('X-Sig') || '');

    if (!ts || !nonce || !sig) return { ok: false, reason: 'MISSING_HEADERS' };

    // Clock skew guard
    const now = Math.floor(Date.now() / 1000);
    if (Math.abs(now - ts) > skew) return { ok: false, reason: 'TS_SKEW' };

    // Build canonical string from raw body if available, else JSON of parsed body
    const body = typeof req.rawBody === 'string' ? req.rawBody : JSON.stringify(req.body || {});
    const base = `${ts}\n${nonce}\n${req.method.toUpperCase()}\n${req.path}\n${body}`;

    // HMAC check
    const mac = crypto.createHmac('sha256', String(apiToken)).update(base).digest('hex');
    if (mac !== sig) return { ok: false, reason: 'BAD_SIG' };

    // Replay guard with Redis NX (preferred) or in-memory fallback
    const key = `srp:replay:${ts}:${nonce}`;
    const r = getRedis();
    if (r) {
        // ioredis: SET key value EX ttl NX  -> "OK" on success, null on key already exists
        const ok = await r.set(key, '1', 'EX', ttl, 'NX');
        if (!ok) return { ok: false, reason: 'REPLAY' };
    } else {
        if (seen.has(key)) return { ok: false, reason: 'REPLAY' };
        seen.set(key, Date.now() + ttl * 1000);
    }

    return { ok: true };
}