import { query } from '../db/index.js';

export async function listEndpoints() {
  return query('SELECT id, url, created_at AS createdAt FROM webhook_endpoints', []);
}

export async function listEndpointsWithSecrets() {
  return query('SELECT id, url, secret FROM webhook_endpoints', []);
}

export async function createEndpoint({ url, secret }) {
  const res = await query('INSERT INTO webhook_endpoints (url, secret) VALUES (?, ?)', [url, secret]);
  return { id: res.insertId, url };
}

export async function deleteEndpoint(id) {
  await query('DELETE FROM webhook_endpoints WHERE id = ?', [id]);
}
