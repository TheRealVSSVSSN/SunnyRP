// src/routes/health.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { pingDB } from '../repositories/db.js';
import { env } from '../config/env.js';
import { createClient } from 'redis';

export const healthRouter = Router();

healthRouter.get('/v1/health', (req, res) => {
    return ok(req, res, { status: 'ok' });
});

healthRouter.get('/v1/ready', async (req, res) => {
    try {
        await pingDB(); // DB must be reachable for readiness

        if (env.REDIS_URL) {
            const client = createClient({ url: env.REDIS_URL });
            await client.connect();
            await client.ping();
            await client.quit();
        }

        return ok(req, res, { ready: true });
    } catch (e) {
        return fail(req, res, 'DEPENDENCY_DOWN', 'A dependency is not reachable');
    }
});