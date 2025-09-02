import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import crypto from 'node:crypto';
import { app } from '../src/app.js';

test('GET /v1/voice/channels/:id requires auth', async (t) => {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, resolve));
  t.after(() => server.close());

  const { port } = server.address();
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const hmac = crypto.createHmac('sha256', secret).update('').digest('hex');
  const res = await fetch(`http://127.0.0.1:${port}/v1/voice/channels/test`, {
    headers: { 'x-srp-signature': hmac }
  });
  assert.strictEqual(res.status, 401);
});

test('GET /v1/voice/broadcast requires auth', async (t) => {
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, resolve));
  t.after(() => server.close());

  const { port } = server.address();
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const hmac = crypto.createHmac('sha256', secret).update('').digest('hex');
  const res = await fetch(`http://127.0.0.1:${port}/v1/voice/broadcast`, {
    headers: { 'x-srp-signature': hmac }
  });
  assert.strictEqual(res.status, 401);
});
