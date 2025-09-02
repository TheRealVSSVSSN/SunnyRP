import client from 'prom-client';

//[[
// Type: Module
// Name: metrics
// Use: Exposes Prometheus metrics register and handler
// Created: 2025-09-01
// By: VSSVSSN
//]]
const register = new client.Registry();
client.collectDefaultMetrics({ register });

export async function metricsHandler(req, res) {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
}

export { register };
