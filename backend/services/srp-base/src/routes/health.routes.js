// backend/services/srp-base/src/routes/health.routes.js
import { Router } from 'express';
import { ok } from '../utils/respond.js';

export const healthRouter = Router();

healthRouter.get('/v1/healthz', (req, res) => {
    ok(res, {
        service: 'srp-base',
        uptime_s: Math.floor(process.uptime()),
        now: new Date().toISOString(),
    });
});