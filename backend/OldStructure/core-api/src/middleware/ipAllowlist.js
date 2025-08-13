import ip from 'ip';
import { config } from '../config/index.js';
export default function ipAllowlist() {
    const set = new Set(config.allowlist);
    return (req, res, next) => {
        if (!set.size) return next();
        const remote = req.ip || req.connection.remoteAddress || '';
        const clean = remote.startsWith('::ffff:') ? remote.substring(7) : remote;
        if (set.has(clean) || set.has(ip.address())) return next();
        return res.status(403).json({ ok: false, error: { code: 'FORBIDDEN', message: 'IP not allowed' } });
    };
}