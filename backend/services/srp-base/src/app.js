// backend/services/srp-base/src/app.js
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
import { hmacAuth } from './middleware/hmacAuth.js';

import { healthRouter } from './routes/health.routes.js';
import { initMetrics, metricsRouter } from './utils/metrics.js';

import { identityRouter } from './routes/identity.routes.js';
import { adminRouter } from './routes/admin.routes.js';
import { permissionsRouter } from './routes/permissions.routes.js';
import { configRouter } from './routes/config.routes.js';
import { outboxRouter } from './routes/outbox.routes.js';

import { usersRouter } from './routes/users.routes.js';
import { charactersRouter } from './routes/characters.routes.js';

// Optional ping route (keep if present in your repo)
import pingRoutes from './routes/ping.routes.js';

export function buildApp() {
  const app = express();

  if (env.TRUST_PROXY) {
    app.set('trust proxy', 1);
  }

  // Correlation id FIRST so logs/metrics can include it
  app.use(requestId());

  // Security & basics
  app.use(helmet());
  app.use(cors());
  app.use(compression());

  // Logging (after requestId so pino can log it)
  app.use(
    pinoHttp({
      logger,
      customProps: (req) => ({ requestId: req.requestId || null }),
    }),
  );

  // Raw body capture (for HMAC) and JSON parsing
  app.use(captureRawBody());
  app.use(express.json({ limit: '1mb' }));

  // Auth chain
  app.use(authToken());
  if (env.ENABLE_REPLAY_GUARD) app.use(replayGuard());
  if (env.ENABLE_IP_ALLOWLIST) app.use(ipAllowlist());
  // HMAC remains opt-in unless you enable it in env/server.cfg
  if (env.ENABLE_HMAC) {
    app.use(
      hmacAuth({
        enable: true,
        secret: env.HMAC_SECRET || '',
        allowedSkewSec: Number(env.HMAC_SKEW_SEC || 90),
        style: (env.HMAC_STYLE || 'newline'),
      }),
    );
  }

  // Metrics
  if (env.ENABLE_METRICS) {
    initMetrics(app);
    app.use(metricsRouter);
  }

  // Health
  app.use(healthRouter);

  // Feature-gated routers (runtime gates via live config.features)
  app.use(featureGate('identity'), identityRouter);
  app.use(featureGate('admin'), adminRouter);
  app.use(featureGate('permissions'), permissionsRouter);
  app.use(featureGate('config'), configRouter);
  app.use(featureGate('outbox'), outboxRouter);

  // Users & Characters (toggle via features.users / features.characters)
  app.use(featureGate('users'), usersRouter);
  app.use(featureGate('characters'), charactersRouter);

  // Optional ping routes (if present)
  if (typeof pingRoutes === 'function') {
    app.use(pingRoutes());
  }

  // Uniform error envelope LAST
  app.use(errorHandler());

  return app;
}