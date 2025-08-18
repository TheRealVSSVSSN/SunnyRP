const express = require('express');
const config = require('./config/env');
const logger = require('./utils/logger');
const requestId = require('./middleware/requestId');
const authMiddleware = require('./middleware/auth');
const { createRateLimiter } = require('./middleware/rateLimit');
const idempotencyMiddleware = require('./middleware/idempotency');
const { sendError } = require('./utils/respond');

// Routers
const healthRoutes = require('./routes/health.routes');
const configRoutes = require('./routes/config.routes');
const usersRoutes = require('./routes/users.routes');
const charactersRoutes = require('./routes/characters.routes');
const permissionsRoutes = require('./routes/permissions.routes');
const playersRoutes = require('./routes/players.routes');
const outboxRoutes = require('./routes/outbox.routes');
const adminRoutes = require('./routes/admin.routes');

// extended domain routes merged from former microservices
const dispatchRoutes = require('./routes/dispatch.routes');
const evidenceRoutes = require('./routes/evidence.routes');
const emsRoutes = require('./routes/ems.routes');
const keysRoutes = require('./routes/keys.routes');
const lootRoutes = require('./routes/loot.routes');

// additional domain routes merged from other microservices
const inventoryRoutes = require('./routes/inventory.routes');
const economyRoutes = require('./routes/economy.routes');
const vehiclesRoutes = require('./routes/vehicles.routes');
const worldRoutes = require('./routes/world.routes');
const jobsRoutes = require('./routes/jobs.routes');

const app = express();

// Capture raw body for HMAC signature verification
app.use(
  express.json({
    verify: (req, res, buf) => {
      req.rawBody = buf;
    },
  }),
);

// Attach requestId and traceId to res.locals
app.use(requestId);

// Authentication & security (IP allowlist, API token, HMAC)
app.use(authMiddleware);

// Idempotency (must run before body is consumed in routes)
app.use(idempotencyMiddleware);

// Health and metrics (public)
app.use(healthRoutes);

// Feature gating can be implemented here if desired by
// conditionally mounting routers based on config.features entries.
// For now we mount all routers unconditionally.
app.use(configRoutes);
app.use(usersRoutes);
app.use(charactersRoutes);
app.use(permissionsRoutes);
app.use(playersRoutes);
app.use(outboxRoutes);
app.use(adminRoutes);

// mount extended domain routes
app.use(dispatchRoutes);
app.use(evidenceRoutes);
app.use(emsRoutes);
app.use(keysRoutes);
app.use(lootRoutes);

// mount additional domain routes
app.use(inventoryRoutes);
app.use(economyRoutes);
app.use(vehiclesRoutes);
app.use(worldRoutes);
app.use(jobsRoutes);

// Rate limiting on admin endpoints (simple example).  Limit to 10
// requests per minute per IP.  In a production environment this
// would be more granular and backed by Redis.
const adminLimiter = createRateLimiter({ windowMs: 60_000, max: 10 });
app.use('/v1/admin', adminLimiter);

// 404 handler
app.use((req, res) => {
  sendError(res, { code: 'NOT_FOUND', message: 'Endpoint not found' }, 404, res.locals.requestId, res.locals.traceId);
});

// Error handler
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  logger.error({ err }, 'Unhandled error');
  sendError(res, { code: 'INTERNAL_ERROR', message: 'Internal server error' }, 500, res.locals.requestId, res.locals.traceId);
});

module.exports = app;