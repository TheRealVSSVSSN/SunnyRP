import crypto from 'crypto';
import { logger } from '../util/logger.js';
import { listEndpointsWithSecrets } from '../repositories/hooks.js';
import {
  insertDeadLetter,
  listDueDeadLetters,
  deleteDeadLetter,
  rescheduleDeadLetter
} from '../repositories/webhookDeadLetters.js';

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

async function send(url, secret, event) {
  const body = JSON.stringify(event);
  const sig = crypto.createHmac('sha256', secret).update(body).digest('hex');
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'x-srp-signature': sig },
    body
  });
  if (!res.ok) throw new Error(`status ${res.status}`);
}

export async function dispatch(event) {
  const jobs = endpoints.map(({ url, secret }) =>
    send(url, secret, event).catch(async err => {
      logger.error({ err, url }, 'webhook failed');
      await insertDeadLetter({ url, secret, payload: event });
    })
  );
  await Promise.allSettled(jobs);
}

export async function retryDeadLetters() {
  const letters = await listDueDeadLetters(10);
  await Promise.allSettled(
    letters.map(async letter => {
      const payload = JSON.parse(letter.payload);
      try {
        await send(letter.url, letter.secret, payload);
        await deleteDeadLetter(letter.id);
      } catch {
        const attempts = letter.attempts + 1;
        const delay = Math.pow(2, attempts) * 60;
        await rescheduleDeadLetter(letter.id, attempts, delay);
      }
    })
  );
}
