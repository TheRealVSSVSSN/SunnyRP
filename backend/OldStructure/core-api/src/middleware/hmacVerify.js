// ESM HMAC verify: "METHOD\nPATH\nX-Ts\nX-Nonce\nrawBody"
import crypto from 'crypto';

const memNonce = new Set();
let nonceTimeout;
function rememberNonce(n, ttlSec = 120) {
    memNonce.add(n);
    clearTimeout(nonceTimeout);
    nonceTimeout = setTimeout(() => memNonce.clear(), ttlSec * 1000).unref();
}
function seenNonce(n) { return memNonce.has(n); }

export default function hmacVerify({ skewSec = 60, tokenEnv = 'GAME_API_TOKEN' } = {}) {
    return async (req, res, next) => {
        try {
            const token = req.get('X-API-Token') || process.env[tokenEnv] || '';
            const ts = req.get('X-Ts') || '';
            const nonce = req.get('X-Nonce') || '';
            const sig = (req.get('X-Sig') || '').toLowerCase();
            if (!token || !ts || !nonce || !sig) {
                return res.status(401).json({ ok: false, error: { code: 'HMAC_MISSING', message: 'Missing HMAC headers' } });
            }
            const now = Math.floor(Date.now() / 1000);
            const tsNum = parseInt(ts, 10);
            if (Number.isNaN(tsNum) || Math.abs(now - tsNum) > skewSec) {
                return res.status(401).json({ ok: false, error: { code: 'HMAC_SKEW', message: 'Clock skew too large' } });
            }
            if (seenNonce(nonce)) {
                return res.status(401).json({ ok: false, error: { code: 'HMAC_REPLAY', message: 'Replay detected' } });
            }
            const rawBody = (req.rawBody && typeof req.rawBody === 'string')
                ? req.rawBody
                : (req.body ? JSON.stringify(req.body) : '');
            const raw = `${req.method.toUpperCase()}\n${req.path}\n${ts}\n${nonce}\n${rawBody}`;
            const digest = crypto.createHmac('sha256', token).update(raw).digest('hex');
            if (digest !== sig) {
                return res.status(401).json({ ok: false, error: { code: 'HMAC_BAD_SIG', message: 'Invalid signature' } });
            }
            rememberNonce(nonce);
            return next();
        } catch (e) {
            return res.status(500).json({ ok: false, error: { code: 'HMAC_ERROR', message: 'hmacVerify failure' } });
        }
    };
}