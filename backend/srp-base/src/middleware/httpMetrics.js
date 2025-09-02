import client from 'prom-client';
import { register } from '../metrics.js';

//[[
// Type: Middleware
// Name: httpMetrics
// Use: Collects per-route HTTP metrics for Prometheus
// Created: 2025-09-03
// By: VSSVSSN
//]]
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status']
});

const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.005, 0.01, 0.05, 0.1, 0.5, 1, 3]
});

register.registerMetric(httpRequestCounter);
register.registerMetric(httpRequestDuration);

export function httpMetrics(req, res, next) {
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const route = req.route?.path || req.path;
    const labels = { method: req.method, route, status: res.statusCode };
    const duration = Number(process.hrtime.bigint() - start) / 1e9;
    httpRequestCounter.inc(labels);
    httpRequestDuration.observe(labels, duration);
  });
  next();
}
