// backend/services/srp-base/src/middleware/hmacAuth.js
import crypto from 'node:crypto';
import { err } from '../utils/respond.js';

export function hmacAuth(opts = {}) {
    const {
        enable = false,
        secret = '',
        allowedSkewSec = 90,
        headerSig = 'x-sig',
        headerTs = 'x-ts',
        headerNonce = 'x-nonce',
        style = 'newline', // 'newline' | 'pipe'
    } = opts;

    return (req, res, next) => {
        if (!enable) return next();

        const ts = req.get(headerTs);
        const nonce = req.get(headerNonce);
        const sig = req.get(headerSig);

        if (!ts || !nonce || !sig) {
            return err(res, 'AUTH_HMAC_MISSING', 'Missing HMAC headers', null, 401);
        }

        const now = Math.floor(Date.now() / 1000);
        const tsInt = parseInt(ts, 10);
        if (!Number.isFinite(tsInt) || Math.abs(now - tsInt) > allowedSkewSec) {
            return err(res, 'AUTH_HMAC_TS', 'Timestamp out of acceptable skew', null, 401);
        }

        const method = (req.method || '').toUpperCase();
        const path = req.originalUrl || req.url || '';
        const rawBody = req.rawBody || '';

        let canonical;
        if (style === 'pipe') {
            canonical = `${method}|${path}|${rawBody}|${ts}|${nonce}`;
        } else {
            canonical = `${method}\n${path}\n${ts}\n${nonce}\n${rawBody}`;
        }

        const mac = crypto.createHmac('sha256', secret).update(canonical).digest('hex');
        const a = Buffer.from(sig, 'utf8');
        const b = Buffer.from(mac, 'utf8');
        if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) {
            return err(res, 'AUTH_HMAC_BADSIG', 'Invalid signature', null, 401);
        }

        return next();
    };
}