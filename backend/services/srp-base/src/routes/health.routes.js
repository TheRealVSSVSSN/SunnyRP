// src/routes/health.routes.js
import { Router } from 'express';
import { ok } from '../utils/respond.js';

export const healthRouter = Router();

healthRouter.get('/v1/health', (req, res) => {
    return ok(req, res, { status: 'ok' });
});

healthRouter.get('/v1/ready', (req, res) => {
    // TODO: add DB / Redis checks; return 503 via `fail()` if not ready
    return ok(req, res, { ready: true });
});