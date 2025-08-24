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
const accountCharactersRoutes = require('./routes/accountCharacters.routes');
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

// new domain routes for doors, error logging, weapons and shops
const doorsRoutes = require('./routes/doors.routes');
const errorRoutes = require('./routes/error.routes');
const weaponsRoutes = require('./routes/weapons.routes');
const shopsRoutes = require('./routes/shops.routes');
const blipsRoutes = require('./routes/blips.routes');
const crimeSchoolRoutes = require('./routes/crimeSchool.routes');
const zonesRoutes = require('./routes/zones.routes');

// contracts domain route
const contractsRoutes = require('./routes/contracts.routes');

// driving tests and drift school domain routes
const drivingTestsRoutes = require('./routes/drivingTests.routes');
const driftSchoolRoutes = require('./routes/driftschool.routes');
// boatshop domain route
const boatshopRoutes = require('./routes/boatshop.routes');

// broadcaster domain route
const broadcasterRoutes = require('./routes/broadcaster.routes');

// new domain routes for gangs, garages, apartments, police
const gangsRoutes = require('./routes/gangs.routes');
const garagesRoutes = require('./routes/garages.routes');
const apartmentsRoutes = require('./routes/apartments.routes');
const policeRoutes = require('./routes/police.routes');

// weed plants domain routes
const weedPlantsRoutes = require('./routes/weedPlants.routes');
const websitesRoutes = require('./routes/websites.routes');
const assetsRoutes = require('./routes/assets.routes');
const clothesRoutes = require('./routes/clothes.routes');

// notes domain route
const notesRoutes = require('./routes/notes.routes');
// base events domain route
const baseEventsRoutes = require('./routes/baseEvents.routes');

// phone domain route
const phoneRoutes = require('./routes/phone.routes');

// interact sound domain route
const interactSoundRoutes = require('./routes/interactSound.routes');

// wise audio domain route
const wiseAudioRoutes = require('./routes/wiseAudio.routes');

// wise imports domain route
const wiseImportsRoutes = require('./routes/wiseImports.routes');

// wise uc domain route
const wiseUCRoutes = require('./routes/wiseUC.routes');

// wise wheels domain route
const wiseWheelsRoutes = require('./routes/wiseWheels.routes');

// diamond blackjack domain route
const diamondBlackjackRoutes = require('./routes/diamondBlackjack.routes');

// secondary jobs domain route
const secondaryJobsRoutes = require('./routes/secondaryJobs.routes');

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
app.use(accountCharactersRoutes);
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

// mount new domain routes
app.use(doorsRoutes);
app.use(errorRoutes);
app.use(weaponsRoutes);
app.use(shopsRoutes);
app.use(blipsRoutes);
app.use(crimeSchoolRoutes);
app.use(zonesRoutes);
app.use(contractsRoutes);
app.use(drivingTestsRoutes);
app.use(driftSchoolRoutes);
app.use(boatshopRoutes);

// mount broadcaster route
app.use(broadcasterRoutes);

// mount gang, garage, apartment and police routes
app.use(gangsRoutes);
app.use(garagesRoutes);
app.use(apartmentsRoutes);
app.use(policeRoutes);

// mount weed plants routes
app.use(weedPlantsRoutes);

// mount websites routes
app.use(websitesRoutes);
app.use(assetsRoutes);
app.use(clothesRoutes);

// mount notes routes
app.use(notesRoutes);
// mount base events routes
app.use(baseEventsRoutes);

// mount phone routes
app.use(phoneRoutes);

// mount interact sound routes
app.use(interactSoundRoutes);

// mount wise audio routes
app.use(wiseAudioRoutes);

// mount wise imports routes
app.use(wiseImportsRoutes);

// mount wise uc routes
app.use(wiseUCRoutes);

// mount wise wheels routes
app.use(wiseWheelsRoutes);

// mount diamond blackjack routes
app.use(diamondBlackjackRoutes);

// mount secondary jobs routes
app.use(secondaryJobsRoutes);

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