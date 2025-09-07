/**
 * SRP Base HTTP Server
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const http = require('http');
const os = require('os');
const { monitorEventLoopDelay } = require('perf_hooks');
const { z } = require('zod');
const requestId = require('./middleware/requestId');
const json = require('./middleware/json');
const cors = require('./middleware/cors');
const rateLimit = require('./middleware/rateLimit');
const hmacAuth = require('./middleware/hmacAuth');
const errorHandler = require('./middleware/errorHandler');
const routes = require('./routes/base.routes');
const repository = require('./repositories/baseRepository');

function enhance(req, res) {
  req.ip = req.socket.remoteAddress;
  res.status = (code) => { res.statusCode = code; return res; };
  res.json = (obj) => { res.setHeader('Content-Type', 'application/json'); res.end(JSON.stringify(obj)); };
  res.send = (data) => { if (typeof data === 'object') { res.json(data); } else { res.end(data); } };
  res.set = res.setHeader.bind(res);
}

function runMiddlewares(req, res, stack, done) {
  let i = 0;
  function next(err) {
    if (err) return errorHandler(err, req, res);
    const mw = stack[i++];
    if (!mw) return done();
    try { mw(req, res, next); } catch (e) { next(e); }
  }
  next();
}

function createHttpServer({ env = process.env } = {}) {
  const port = env.PORT || 4000;
  const monitor = monitorEventLoopDelay({ resolution: 20 });
  monitor.enable();
  let inflight = 0;

  const server = http.createServer((req, res) => {
    enhance(req, res);
    inflight++;
    res.on('finish', () => { inflight--; });
    req.parsedUrl = new URL(req.url, 'http://localhost');
    const globalMw = [requestId, json, cors, rateLimit()];
    runMiddlewares(req, res, globalMw, () => dispatch(req, res));
  });

  function dispatch(req, res) {
    const url = req.parsedUrl;
    try {
      if (req.method === 'GET' && url.pathname === '/v1/health') {
        return res.json({ status: 'ok', service: 'srp-base', time: new Date().toISOString() });
      }
      if (req.method === 'GET' && url.pathname === '/v1/ready') {
        const lag = monitor.mean / 1e6;
        const cpu = (os.loadavg()[0] / os.cpus().length) * 100;
        const overloaded = lag > Number(env.SRP_OVERLOAD_EL_LAG_MS || 75) ||
          cpu > Number(env.SRP_OVERLOAD_CPU_PCT || 85) ||
          inflight > Number(env.SRP_OVERLOAD_INFLIGHT || 200);
        res.setHeader('X-SRP-Node-Overloaded', overloaded ? 'true' : 'false');
        return res.json({ ready: true, deps: [], load: { cpu: +cpu.toFixed(2), eventLoopLagMs: +lag.toFixed(2), pending: { inflightRequests: inflight } } });
      }
      if (req.method === 'GET' && url.pathname === '/v1/info') {
        const pkg = require('../package.json');
        return res.json({ service: 'srp-base', version: pkg.version, compat: { baseline: 'srp-base' } });
      }
      if (req.method === 'POST' && url.pathname === '/internal/srp/rpc') {
        return runMiddlewares(req, res, [hmacAuth], () => handleRpc(req, res));
      }
      for (const r of routes) {
        if (req.method === r.method) {
          const match = url.pathname.match(r.path);
          if (match) {
            const mws = r.middlewares || [];
            return runMiddlewares(req, res, mws, () => r.handler(req, res, match));
          }
        }
      }
      res.status(404).json({ error: 'not_found' });
    } catch (err) {
      errorHandler(err, req, res);
    }
  }

  const envelopeSchema = z.object({
    id: z.string(),
    type: z.string(),
    source: z.string(),
    subject: z.string().optional(),
    time: z.string().optional(),
    specversion: z.string().optional(),
    data: z.any()
  });

  function handleRpc(req, res) {
    const parsed = envelopeSchema.safeParse(req.body || {});
    if (!parsed.success) return res.status(400).json({ error: 'invalid_envelope' });
    const envlp = parsed.data;
    let result;
    switch (envlp.type) {
      case 'srp.base.characters.create':
        result = repository.createCharacter(envlp.data.accountId, envlp.data.data || {});
        break;
      case 'srp.base.characters.list':
        result = repository.listCharacters(envlp.data.accountId);
        break;
      case 'srp.base.characters.select':
        result = repository.selectCharacter(envlp.data.accountId, envlp.data.characterId);
        break;
      case 'srp.base.characters.delete':
        result = repository.deleteCharacter(envlp.data.accountId, envlp.data.characterId);
        break;
      default:
        return res.status(501).json({ error: 'not_implemented' });
    }
    return res.json({ ok: true, result });
  }

  require('./realtime/websocket')(server);

  return {
    start: () => new Promise((resolve) => server.listen(port, resolve)),
    stop: () => new Promise((resolve) => server.close(resolve))
  };
}

module.exports = { createHttpServer };

if (require.main === module) {
  const { start } = createHttpServer({ env: process.env });
  start().then(() => console.log('srp-base listening'));
}
