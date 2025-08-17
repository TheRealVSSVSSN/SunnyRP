// src/middleware/ipAllowlist.js
import { fail } from '../utils/respond.js';

/**
 * Simple IP allowlist. ALLOWLIST_IPS is a comma-separated list of host/IPs.
 * In proxied environments, ensure Express trust proxy is configured (not in this sample).
 */
export function ipAllowlist(allowlistCsv) {
    const set = new Set(
        (allowlistCsv || '')
            .split(',')
            .map(s => s.trim())
            .filter(Boolean)
    );

    return (req, res, next) => {
        const ip = req.ip || req.connection?.remoteAddress || '';
        if (!set.size || set.has(ip)) {
            return next();
        }
        return fail(req, res, 'FORBIDDEN', 'IP not allowed');
    };
}