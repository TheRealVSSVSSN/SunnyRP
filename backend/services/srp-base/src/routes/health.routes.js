// src/routes/health.routes.js
import { Router } from 'express';
import { ok, fail } from '../utils/respond.js';
import { pingDB } from '../repositories/db.js';

export const healthRouter = Router();

healthRouter.get('/v1/health', (req, res) => {
    return ok(req, res, { status: 'ok' });
});

healthRouter.get('/v1/ready', async (req, res) => {
    try {
        await pingDB(); // DB must be reachable for readiness
        return ok(req, res, { ready: true });
    } catch (e) {
        return fail(req, res, 'DEPENDENCY_DOWN', 'Database not reachable');
    }
});