/**
 * Lua Bridge Utility
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const http = require('http');

function callLua(path, { method = 'POST', body = {}, headers = {} } = {}) {
  const port = process.env.FX_HTTP_PORT || 30120;
  const data = Buffer.from(JSON.stringify(body));
  return new Promise((resolve, reject) => {
    const req = http.request({
      host: '127.0.0.1',
      port,
      path: `/srp-base${path}`,
      method,
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length,
        'X-SRP-Internal-Key': process.env.SRP_INTERNAL_KEY || 'change_me',
        ...headers
      }
    }, (res) => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        resolve({ status: res.statusCode, body: Buffer.concat(chunks).toString(), headers: res.headers });
      });
    });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

function isOverloaded() {
  const port = process.env.PORT || 4000;
  return new Promise((resolve, reject) => {
    http.get({ host: '127.0.0.1', port, path: '/v1/ready' }, (res) => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const overloaded = res.headers['x-srp-node-overloaded'] === 'true';
        let body = {};
        try { body = JSON.parse(Buffer.concat(chunks).toString() || '{}'); } catch (e) {}
        resolve({ overloaded, body });
      });
    }).on('error', reject);
  });
}

module.exports = { callLua, isOverloaded };
