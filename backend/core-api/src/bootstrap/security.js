import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import hpp from 'hpp';
import rateLimit from '../middleware/rateLimit.js';
import authToken from '../middleware/authToken.js';
import ipAllowlist from '../middleware/ipAllowlist.js';

export function applySecurity(app) {
    app.use(helmet());
    app.use(cors({ origin: false }));
    app.use(compression());
    app.use(hpp());
    app.use(rateLimit());

    // Protect /ready and /metrics with token (and optional IP allowlist)
    app.use(['/ready', '/metrics'], authToken(true), ipAllowlist());
}