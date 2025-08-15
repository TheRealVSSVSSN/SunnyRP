// src/app.js
import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import pinoHttp from 'pino-http';

import { env } from './config/env.js';
import { logger } from './utils/logger.js';
import { captureRawBody } from './middleware/rawBody.js';
import { requestId } from './middleware/requestId.js';
import { authToken } from './middleware/authToken.js';
import { replayGuard } from './middleware/replayGuard.js';
import { ipAllowlist } from './middleware/ipAllowlist.js';
import { featureGate } from './middleware/featureGate.js';
import { errorHandler } from './middleware/errorHandler.js';

import { healthRouter } from './routes/health.routes.js';
import { initMetrics, metricsRouter } from './utils/metrics.js';

import { identityRouter } from './routes/identity.routes.js';
import { adminRouter } from './routes/admin.routes.js';
import { permissionsRouter } from './routes/permissions.routes.js';
import { configRouter } from './routes/config.routes.js';
import { outboxRouter } from './routes/outbox.routes.js';

export function buildApp() {
    const app = express();

    // trust proxy for real client IPs if behind reverse proxy
    if (env.TRUST_PROXY) {
        app.set('trust proxy', true);
    }

    // raw body must come before json parsing for HMAC verification
    app.use(captureRawBody());
    app.use(express.json({ limit: '1mb' }));

    app.use(helmet());
    app.use(cors({ origin: false }));
    app.use(compression());
    app.use(pinoHttp({ logger }));

    app.use(requestId());
    app.use(authToken(env.API_TOKEN));

    if (env.ENABLE_IP_ALLOWLIST) {
        app.use(ipAllowlist(env.ALLOWLIST_IPS));
    }

    if (env.ENABLE_REPLAY_GUARD) {
        app.use(replayGuard());
    }

    app.use(healthRouter);

    if (env.ENABLE_METRICS) {
        initMetrics();
        app.use(metricsRouter);
    }

    // Feature-gated routers (runtime toggleable via config 'features' map)
    app.use(featureGate('identity'), identityRouter);
    app.use(featureGate('admin'), adminRouter);
    app.use(featureGate('permissions'), permissionsRouter);
    app.use(featureGate('config'), configRouter);
    app.use(featureGate('outbox'), outboxRouter);

    // uniform error envelope
    app.use(errorHandler());

    return app;
}