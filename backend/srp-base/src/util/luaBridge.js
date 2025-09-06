// Updated: 2024-11-28
import http from 'http';

/**
 * Sends requests to the FiveM HTTP handler on loopback.
 */
export function callLua(path, { method = 'POST', body = {}, headers = {} } = {}) {
  const port = process.env.FX_HTTP_PORT || 30120;
  const data = Buffer.from(JSON.stringify(body));
  const options = {
    host: '127.0.0.1',
    port,
    path: `/srp-base${path}`,
    method,
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': data.length,
      'X-SRP-Internal-Key': process.env.SRP_INTERNAL_KEY || 'change_me',
      ...headers,
    },
  };
  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      const chunks = [];
      res.on('data', (c) => chunks.push(c));
      res.on('end', () => {
        resolve({ status: res.statusCode, body: Buffer.concat(chunks).toString() });
      });
    });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}
