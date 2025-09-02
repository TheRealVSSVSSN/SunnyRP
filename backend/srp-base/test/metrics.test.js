import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import crypto from 'node:crypto';
import { app } from '../src/app.js';

//[[
// Type: Test
// Name: Metrics endpoint
// Use: Verifies Prometheus metrics exposure
// Created: 2025-09-08
// By: VSSVSSN
//]]
test('GET /metrics returns Prometheus metrics', async (t) => {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, resolve));
  t.after(() => server.close());

  const { port } = server.address();
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const hmac = crypto.createHmac('sha256', secret).update('').digest('hex');

  await fetch(`http://127.0.0.1:${port}/v1/health`, {
    headers: { 'x-srp-signature': hmac }
  });

  const res = await fetch(`http://127.0.0.1:${port}/metrics`, {
    headers: { 'x-srp-signature': hmac }
  });
  assert.strictEqual(res.status, 200);
  const text = await res.text();
  assert.ok(text.includes('http_requests_total'));
});
