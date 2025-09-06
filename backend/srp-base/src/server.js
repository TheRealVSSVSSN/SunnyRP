import http from 'http';
import { requestId } from './middleware/requestId.js';
import { rateLimit } from './middleware/rateLimit.js';
import { hmacAuth } from './middleware/hmacAuth.js';
import { errorHandler } from './middleware/errorHandler.js';
import { handleBaseRoutes } from './routes/base.routes.js';

function parseJson(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', chunk => { data += chunk; });
    req.on('end', () => {
      if (!data) return resolve(undefined);
      try { resolve(JSON.parse(data)); } catch (e) { reject(Object.assign(new Error('invalid_json'), { status:400 })); }
    });
    req.on('error', reject);
  });
}

export function createHttpServer({ env = process.env } = {}) {
  const port = Number(env.PORT) || 4000;
  const server = http.createServer(async (req, res) => {
    const start = Date.now();
    try {
      await requestId(req, res);
      await rateLimit(req, res);
      // CORS headers
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-Request-Id, X-SRP-Internal-Key, Idempotency-Key');
      if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }
      if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
        req.body = await parseJson(req);
      }
      const url = new URL(req.url, `http://${req.headers.host}`);
      if (req.method === 'GET' && url.pathname === '/v1/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'ok', service: 'srp-base', time: new Date().toISOString() }));
      } else if (req.method === 'GET' && url.pathname === '/v1/ready') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ ready: true, deps: [] }));
      } else if (req.method === 'GET' && url.pathname === '/v1/info') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ service: 'srp-base', version: '0.1.0', compat: { baseline: 'srp-base' } }));
      } else if (req.method === 'POST' && url.pathname === '/internal/srp/rpc') {
        hmacAuth(req, env);
        const envelope = req.body;
        if (!envelope || typeof envelope !== 'object') {
          throw Object.assign(new Error('invalid_envelope'), { status: 400 });
        }
        // echo back for now
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ ok: true, result: envelope.data }));
      } else if (await handleBaseRoutes(req, res, url)) {
        // handled
      } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'not_found' }));
      }
    } catch (err) {
      errorHandler(err, req, res);
    } finally {
      const latency = Date.now() - start;
      const log = { route: req.url, status: res.statusCode, latency, requestId: req.id };
      console.log(JSON.stringify(log));
    }
  });
  server.listen(port, () => {
    console.log(`srp-base listening on ${port}`);
  });
  return server;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  createHttpServer({ env: process.env });
}
