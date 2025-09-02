import crypto from 'crypto';
import { logger } from '../util/logger.js';
import { listEndpointsWithSecrets } from '../repositories/hooks.js';

let endpoints = [];

export async function refreshEndpoints() {
  try {
    endpoints = await listEndpointsWithSecrets();
    const discordUrl = process.env.DISCORD_WEBHOOK_URL;
    if (discordUrl) {
      endpoints.push({ url: discordUrl, secret: process.env.DISCORD_WEBHOOK_SECRET || '' });
    }
  } catch (err) {
    logger.error({ err }, 'failed to load webhook endpoints');
  }
}

async function send(url, secret, event, attempt = 0) {
  const body = JSON.stringify(event);
  const sig = crypto.createHmac('sha256', secret).update(body).digest('hex');
  try {
    const res = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json', 'x-srp-signature': sig }, body });
    if (!res.ok) throw new Error(`status ${res.status}`);
  } catch (err) {
    if (attempt < 3) {
      const delay = Math.pow(2, attempt) * 1000 + Math.random() * 1000;
      await new Promise(r => setTimeout(r, delay));
      return send(url, secret, event, attempt + 1);
    }
    logger.error({ err, url }, 'webhook failed');
  }
}

export async function dispatch(event) {
  for (const { url, secret } of endpoints) {
    await send(url, secret, event);
  }
}