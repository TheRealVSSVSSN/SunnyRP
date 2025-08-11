import crypto from 'crypto';
const ttl = Number(process.env.REPLAY_TTL_SECONDS || 30);
const skew = Number(process.env.REPLAY_ALLOWED_SKEW_SECONDS || 20);

// simple in-memory nonce store with TTL
const seen = new Map(); // key -> expiresAt

function prune() {
    const now = Date.now();
    for (const [k, exp] of seen) if (exp <= now) seen.delete(k);
}
setInterval(prune, 5000).unref();

export function verify(req, apiToken) {
    const ts = Number(req.header('X-Ts') || 0);
    const nonce = String(req.header('X-Nonce') || '');
    const sig = String(req.header('X-Sig') || '');
    if (!ts || !nonce || !sig) return { ok: false, reason: 'MISSING_HEADERS' };
    const now = Math.floor(Date.now() / 1000);
    if (Math.abs(now - ts) > skew) return { ok: false, reason: 'TS_SKEW' };
    const key = `${ts}:${nonce}`;
    if (seen.has(key)) return { ok: false, reason: 'REPLAY' };
    const body = typeof req.rawBody === 'string' ? req.rawBody : JSON.stringify(req.body || {});
    const base = `${ts}\n${nonce}\n${req.method.toUpperCase()}\n${req.path}\n${body}`;
    const h = crypto.createHmac('sha256', String(apiToken)).update(base).digest('hex');
    if (h !== sig) return { ok: false, reason: 'BAD_SIG' };
    seen.set(key, Date.now() + ttl * 1000);
    return { ok: true };
}