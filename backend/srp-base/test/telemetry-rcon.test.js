import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import crypto from 'node:crypto';
import { app } from '../src/app.js';

test('POST /v1/telemetry/rcon requires auth', async (t) => {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, resolve));
  t.after(() => server.close());
  const { port } = server.address();
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const body = JSON.stringify({ command: 'status' });
  const hmac = crypto.createHmac('sha256', secret).update(body).digest('hex');
  const res = await fetch(`http://127.0.0.1:${port}/v1/telemetry/rcon`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-srp-signature': hmac },
    body
  });
  assert.strictEqual(res.status, 401);
});
