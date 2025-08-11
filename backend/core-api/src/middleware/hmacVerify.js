// Verifies X-API-Token, X-Ts, X-Nonce, X-Sig over "METHOD\nPATH\nX-Ts\nX-Nonce\nrawBody"
// If req.rawBody is unavailable, falls back to JSON.stringify(req.body).
const crypto = require('crypto');

let memNonce = new Set(); // fallback when Redis not available
let memNonceTimeout;
function rememberNonce(nonce, ttlSec = 120) {
    memNonce.add(nonce);
    clearTimeout(memNonceTimeout);
    memNonceTimeout = setTimeout(() => (memNonce.clear()), ttlSec * 1000).unref();
}
function seenNonce(nonce) { return memNonce.has(nonce); }

module.exports = function hmacVerify({ skewSec = 60, tokenEnv = 'GAME_API_TOKEN' } = {}) {
    return async function (req, res, next) {
        try {
            const token = req.get('X-API-Token') || process.env[tokenEnv] || '';
            const ts = req.get('X-Ts') || '';
            const nonce = req.get('X-Nonce') || '';
            const sig = (req.get('X-Sig') || '').toLowerCase();

            if (!token || !ts || !nonce || !sig) {
                return res.status(401).json({ error: 'Missing HMAC headers' });
            }

            const now = Math.floor(Date.now() / 1000);
            const tsNum = parseInt(ts, 10);
            if (Number.isNaN(tsNum) || Math.abs(now - tsNum) > skewSec) {
                return res.status(401).json({ error: 'Clock skew too large' });
            }
            if (seenNonce(nonce)) {
                return res.status(401).json({ error: 'Replay detected' });
            }

            const rawBody = (req.rawBody && typeof req.rawBody === 'string')
                ? req.rawBody
                : (req.body ? JSON.stringify(req.body) : '');

            const raw = `${req.method.toUpperCase()}\n${req.path}\n${ts}\n${nonce}\n${rawBody}`;
            const digest = crypto.createHmac('sha256', token).update(raw).digest('hex');

            if (digest !== sig) {
                return res.status(401).json({ error: 'Invalid signature' });
            }

            rememberNonce(nonce);
            next();
        } catch (e) {
            return res.status(500).json({ error: 'hmacVerify failure' });
        }
    };
};