// 2025-02-14
import express from 'express';
import cors from 'cors';
import os from 'os';
import http from 'http';
import { monitorEventLoopDelay } from 'perf_hooks';
import pkg from '../package.json' assert { type: 'json' };
import { requestId } from './middleware/requestId.js';
import { rateLimit } from './middleware/rateLimit.js';
import { hmacAuth } from './middleware/hmacAuth.js';
import { errorHandler } from './middleware/errorHandler.js';
import { assertValid } from './middleware/validate.js';
import { idempotency, saveIdempotency } from './middleware/idempotency.js';
import baseRoutes from './routes/base.routes.js';
import { createWebSocketServer } from './realtime/websocket.js';

/**
 * Creates and starts the HTTP server.
 */
export function createHttpServer({ env = process.env } = {}) {
  const app = express();
  const port = Number(env.PORT) || 4000;
  const thresholds = {
    lag: Number(env.SRP_OVERLOAD_EL_LAG_MS) || 75,
    cpu: Number(env.SRP_OVERLOAD_CPU_PCT) || 85,
    inflight: Number(env.SRP_OVERLOAD_INFLIGHT) || 200,
  };

  const lagMonitor = monitorEventLoopDelay({ resolution: 20 });
  lagMonitor.enable();
  let inflight = 0;

  app.use(requestId);
  app.use((req, res, next) => {
    inflight++;
    const start = process.hrtime.bigint();
    res.on('finish', () => {
      inflight--;
      const latency = Number(process.hrtime.bigint() - start) / 1e6;
      console.log(
        JSON.stringify({
          route: req.originalUrl,
          status: res.statusCode,
          latency,
          requestId: req.id,
        })
      );
      saveIdempotency(req, res, res.locals.body || '');
    });
    next();
  });
  app.use(rateLimit);
  app.use(cors());
  app.use(express.json());

  app.get('/v1/health', (req, res) => {
    res.json({ status: 'ok', service: 'srp-base', time: new Date().toISOString() });
  });

  app.get('/v1/ready', (req, res) => {
    const cpu = (os.loadavg()[0] / os.cpus().length) * 100;
    const lag = Math.round(lagMonitor.mean / 1e6);
    const overloaded = lag > thresholds.lag || cpu > thresholds.cpu || inflight > thresholds.inflight;
    res.set('X-SRP-Node-Overloaded', String(overloaded));
    res.json({
      ready: true,
      deps: [],
      load: {
        cpu: Number(cpu.toFixed(2)),
        eventLoopLagMs: lag,
        pending: { inflightRequests: inflight },
      },
    });
  });

  app.get('/v1/info', (req, res) => {
    res.json({ service: 'srp-base', version: pkg.version, compat: { baseline: 'srp-base' } });
  });

  const envelopeSchema = {
    id: { type: 'string', required: true },
    type: { type: 'string', required: true },
    source: { type: 'string', required: true },
    subject: { type: 'string', required: true },
    time: { type: 'string', required: true },
    specversion: { type: 'string', required: true },
    data: { type: 'object', required: true },
  };

  app.post('/internal/srp/rpc', hmacAuth(env), (req, res) => {
    try {
      assertValid(envelopeSchema, req.body || {});
      const envelope = req.body;
      res.locals.body = JSON.stringify({ ok: true, result: envelope.data });
      res.type('application/json').send(res.locals.body);
    } catch (e) {
      res.status(e.status || 400).json({ error: e.message || 'invalid_envelope' });
    }
  });

  app.use('/v1/accounts', baseRoutes);

  app.use((req, res) => {
    res.status(404).json({ error: 'not_found' });
  });

  app.use(errorHandler);

  const server = http.createServer(app);
  const ws = createWebSocketServer(server);
  app.set('ws', ws);

  server.listen(port, () => console.log(`srp-base listening on ${port}`));
  return server;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  createHttpServer({ env: process.env });
}
