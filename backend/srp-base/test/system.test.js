import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import crypto from 'node:crypto';
import { app } from '../src/app.js';

//[[
// Type: Test
// Name: System readiness and info endpoints
// Use: Verifies /v1/ready and /v1/info responses
// Created: 2025-09-08
// By: VSSVSSN
//]]
test('GET /v1/ready and /v1/info return service details', async (t) => {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, resolve));
  t.after(() => server.close());

  const { port } = server.address();
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const hmac = crypto.createHmac('sha256', secret).update('').digest('hex');

  const readyRes = await fetch(`http://127.0.0.1:${port}/v1/ready`, {
    headers: { 'x-srp-signature': hmac }
  });
  assert.strictEqual(readyRes.status, 200);
  const ready = await readyRes.json();
  assert.strictEqual(ready.ready, true);
  assert.ok(Array.isArray(ready.deps));

  const infoRes = await fetch(`http://127.0.0.1:${port}/v1/info`, {
    headers: { 'x-srp-signature': hmac }
  });
  assert.strictEqual(infoRes.status, 200);
  const info = await infoRes.json();
  assert.strictEqual(info.service, 'srp-base');
  assert.strictEqual(info.compat?.baseline, 'srp-base');
});
