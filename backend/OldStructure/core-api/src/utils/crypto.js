import crypto from 'crypto';
import { config } from '../config/index.js';

export function signPayload(ts, nonce, body = '') {
    if (!config.hmac.secret) return null;
    const hmac = crypto.createHmac('sha256', config.hmac.secret);
    hmac.update(String(ts));
    hmac.update(String(nonce));
    hmac.update(body || '');
    return hmac.digest('hex');
}