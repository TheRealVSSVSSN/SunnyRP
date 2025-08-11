import express from 'express';
import pinoHttp from 'pino-http';
import requestId from '../middleware/requestId.js';
import errorHandler from '../middleware/errorHandler.js';
import { logger } from '../utils/logger.js';
import { applySecurity } from './security.js';

// Existing routes
import healthRoutes from '../routes/health.routes.js';
import playersRoutes from '../routes/players.routes.js';
import permissionsRoutes from '../routes/permissions.routes.js';
import adminRoutes from '../routes/admin.routes.js';
import charactersRoutes from '../routes/characters.routes.js';
import mapRoutes from '../routes/map.routes.js';
import chatRoutes from '../routes/chat.routes.js';
import statusRoutes from '../routes/status.routes.js';
import itemsRoutes from '../routes/items.routes.js';
import inventoryRoutes from '../routes/inventory.routes.js';
import economyRoutes from '../routes/economy.routes.js';
import vehiclesRoutes from '../routes/vehicles.routes.js';
import jobsRoutes from '../routes/jobs.routes.js';
import businessesRoutes from '../routes/businesses.routes.js'; // fixed path
import shopsRoutes from '../routes/shops.routes.js';           // fixed path
import crimeRoutes from '../routes/crime.routes.js';
import phoneRoutes from '../routes/phone.routes.js';
import telemetryRoutes from '../routes/telemetry.routes.js';
import outboxRoutes from '../routes/outbox.routes.js';

// NEW routes
import configRoutes from '../routes/config.routes.js';
import worldRoutes from '../routes/world.routes.js';
import notifyRoutes from '../routes/notify.routes.js';

export function makeApp() {
    const app = express();
    app.disable('x-powered-by');

    // Capture rawBody for HMAC verification (must be BEFORE any routes)
    app.use(express.json({
        limit: '1mb',
        verify: (req, res, buf) => { req.rawBody = buf.toString('utf8'); }
    }));
    app.use(express.urlencoded({
        extended: true,
        limit: '1mb',
        verify: (req, res, buf) => { req.rawBody = buf.toString('utf8'); }
    }));

    app.use(requestId);
    app.use(pinoHttp({ logger }));

    applySecurity(app);

    // Health first
    app.use(healthRoutes);

    // Existing feature routes
    app.use(playersRoutes);
    app.use(permissionsRoutes);
    app.use(adminRoutes);

    app.use(charactersRoutes);

    app.use(mapRoutes);
    app.use(chatRoutes);
    app.use(statusRoutes);

    app.use(itemsRoutes);
    app.use(inventoryRoutes);

    app.use(economyRoutes);
    app.use(vehiclesRoutes);
    app.use(jobsRoutes);

    app.use(businessesRoutes);
    app.use(shopsRoutes);

    app.use(crimeRoutes);
    app.use(phoneRoutes);
    app.use(telemetryRoutes);
    app.use(outboxRoutes);

    // NEW: live config, world state, and notify/Discord endpoints
    app.use('/config', configRoutes);
    app.use('/world', worldRoutes);
    app.use('/notify', notifyRoutes);

    // 404 + error handler
    app.use((req, res) =>
        res.status(404).json({ ok: false, error: { code: 'NOT_FOUND', message: 'No route' } })
    );
    app.use(errorHandler);

    return app;
}