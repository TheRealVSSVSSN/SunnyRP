const express = require('express');
const cors = require('cors');
const http = require('http');
const os = require('os');
const { monitorEventLoopDelay } = require('perf_hooks');
const requestId = require('./middleware/requestId');
const rateLimit = require('./middleware/rateLimit');
const hmacAuth = require('./middleware/hmacAuth');
const validate = require('./middleware/validate');
const errorHandler = require('./middleware/errorHandler');
const baseRoutes = require('./routes/base.routes');
const websocket = require('./realtime/websocket');

function createHttpServer({ env = process.env } = {}) {
  const app = express();
  const server = http.createServer(app);
  websocket.init(server);
  const elMonitor = monitorEventLoopDelay();
  elMonitor.enable();
  let inflight = 0;

  app.use(requestId);
  app.use((req, res, next) => { inflight++; res.on('finish', () => inflight--); next(); });
  app.use(express.json());
  app.use(cors());
  app.use(rateLimit());

  app.get('/v1/health', (req, res) => {
    res.json({ status: 'ok', service: 'srp-base', time: new Date().toISOString() });
  });

  app.get('/v1/ready', (req, res) => {
    const cpu = (os.loadavg()[0] / os.cpus().length) * 100;
    const lag = elMonitor.mean / 1e6;
    const overload =
      cpu > Number(env.SRP_OVERLOAD_CPU_PCT || 85) ||
      lag > Number(env.SRP_OVERLOAD_EL_LAG_MS || 75) ||
      inflight > Number(env.SRP_OVERLOAD_INFLIGHT || 200);
    res.setHeader('X-SRP-Node-Overloaded', overload ? 'true' : 'false');
    res.json({ ready: true, deps: [], load: { cpu: Math.round(cpu), eventLoopLagMs: Math.round(lag), pending: { inflightRequests: inflight } } });
  });

  app.get('/v1/info', (req, res) => {
    const pkg = require('../package.json');
    res.json({ service: 'srp-base', version: pkg.version, compat: { baseline: 'srp-base' } });
  });

  app.post(
    '/internal/srp/rpc',
    hmacAuth,
    validate((req) => {
      const body = req.body || {};
      if (!body.id || !body.type || !body.time || !body.specversion) {
        throw new Error('invalid_envelope');
      }
    }),
    (req, res) => {
      res.json({ ok: true, result: null });
    }
  );

  app.use(baseRoutes);
  app.use(errorHandler);

  const port = env.PORT || 4000;
  server.listen(port, () => console.log(`srp-base listening on ${port}`));
  return { app, server };
}

module.exports = { createHttpServer };

if (require.main === module) {
  createHttpServer({});
}
