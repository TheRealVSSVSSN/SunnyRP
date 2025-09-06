// Updated: 2024-11-28
import express from 'express';
import cors from 'cors';
import { requestId } from './middleware/requestId.js';
import { rateLimit } from './middleware/rateLimit.js';
import { hmacAuth } from './middleware/hmacAuth.js';
import { errorHandler } from './middleware/errorHandler.js';
import baseRoutes from './routes/base.routes.js';
import { assertValid } from './middleware/validate.js';
import pkg from '../package.json' assert { type: 'json' };

/**
 * Name: server
 * Description: Express HTTP server exposing health, info, and RPC endpoints.
 * Created: 2024-11-27
 * By: VSSVSSN
 */
export function createHttpServer({ env = process.env } = {}) {
  const app = express();
  const port = Number(env.PORT) || 4000;

  app.use(requestId);
  app.use((req, res, next) => {
    const start = Date.now();
    res.on('finish', () => {
      const latency = Date.now() - start;
      console.log(JSON.stringify({ route: req.originalUrl, status: res.statusCode, latency, requestId: req.id }));
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
    res.json({ ready: true, deps: [] });
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
      res.json({ ok: true, result: envelope.data });
    } catch (e) {
      res.status(e.status || 400).json({ error: e.message || 'invalid_envelope' });
    }
  });

  app.use('/v1/accounts', baseRoutes);

  app.use((req, res) => {
    res.status(404).json({ error: 'not_found' });
  });

  app.use(errorHandler);

  const server = app.listen(port, () => {
    console.log(`srp-base listening on ${port}`);
  });
  return server;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  createHttpServer({ env: process.env });
}
