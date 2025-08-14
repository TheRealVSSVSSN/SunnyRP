// src/utils/metrics.js
import client from 'prom-client';
import { Router } from 'express';

export const metricsRouter = Router();

export function initMetrics() {
    client.collectDefaultMetrics();
}

metricsRouter.get('/v1/metrics', async (_req, res) => {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
});