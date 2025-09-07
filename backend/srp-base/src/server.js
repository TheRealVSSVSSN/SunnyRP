/**
 * SRP Base HTTP Server
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const express = require('express');
const cors = require('cors');
const http = require('http');
const os = require('os');
const { monitorEventLoopDelay } = require('perf_hooks');
const { z } = require('zod');
const requestId = require('./middleware/requestId');
const rateLimit = require('./middleware/rateLimit');
const hmacAuth = require('./middleware/hmacAuth');
const idempotency = require('./middleware/idempotency');
const errorHandler = require('./middleware/errorHandler');
const baseRoutes = require('./routes/base.routes');
const repository = require('./repositories/baseRepository');

function createHttpServer({ env = process.env } = {}) {
  const app = express();
  const port = env.PORT || 4000;
  const monitor = monitorEventLoopDelay({ resolution: 20 });
  monitor.enable();
  let inflight = 0;

  app.use(requestId);
  app.use(express.json());
  app.use(cors());
  app.use(rateLimit());
  app.use((req, res, next) => { inflight++; res.on('finish', () => inflight--); next(); });

  app.get('/v1/health', (req, res) => {
    res.json({ status: 'ok', service: 'srp-base', time: new Date().toISOString() });
  });

  app.get('/v1/ready', (req, res) => {
    const lag = monitor.mean / 1e6;
    const cpu = (os.loadavg()[0] / os.cpus().length) * 100;
    const overloaded = lag > Number(env.SRP_OVERLOAD_EL_LAG_MS || 75) ||
      cpu > Number(env.SRP_OVERLOAD_CPU_PCT || 85) ||
      inflight > Number(env.SRP_OVERLOAD_INFLIGHT || 200);
    res.set('X-SRP-Node-Overloaded', overloaded ? 'true' : 'false');
    res.json({ ready: true, deps: [], load: { cpu: +cpu.toFixed(2), eventLoopLagMs: +lag.toFixed(2), pending: { inflightRequests: inflight } } });
  });

  app.get('/v1/info', (req, res) => {
    const pkg = require('../package.json');
    res.json({ service: 'srp-base', version: pkg.version, compat: { baseline: 'srp-base' } });
  });

  const envelopeSchema = z.object({
    id: z.string(),
    type: z.string(),
    source: z.string(),
    subject: z.string().optional(),
    time: z.string().optional(),
    specversion: z.string().optional(),
    data: z.any()
  });

  const rpc = express.Router();
  rpc.use(hmacAuth);
  rpc.post('/', express.json(), (req, res, next) => {
    const parse = envelopeSchema.safeParse(req.body);
    if (!parse.success) return res.status(400).json({ error: 'invalid_envelope' });
    const envlp = parse.data;
    let result;
    switch (envlp.type) {
      case 'srp.base.characters.create': {
        const { accountId, data } = envlp.data || {};
        result = repository.createCharacter(accountId, data || {});
        break;
      }
      case 'srp.base.characters.list': {
        const { accountId } = envlp.data || {};
        result = repository.listCharacters(accountId);
        break;
      }
      case 'srp.base.characters.select': {
        const { accountId, characterId } = envlp.data || {};
        result = repository.selectCharacter(accountId, characterId);
        break;
      }
      case 'srp.base.characters.delete': {
        const { accountId, characterId } = envlp.data || {};
        result = repository.deleteCharacter(accountId, characterId);
        break;
      }
      default:
        return res.status(501).json({ error: 'not_implemented' });
    }
    return res.json({ ok: true, result });
  });
  app.use('/internal/srp/rpc', rpc);

  app.use(baseRoutes);

  app.use(errorHandler);

  const server = http.createServer(app);
  require('./realtime/websocket')(server);

  return {
    app,
    server,
    start: () => new Promise((resolve) => server.listen(port, resolve)),
    stop: () => new Promise((resolve) => server.close(resolve))
  };
}

module.exports = { createHttpServer };

if (require.main === module) {
  const { start } = createHttpServer({ env: process.env });
  start().then(() => console.log('srp-base listening'));
}
