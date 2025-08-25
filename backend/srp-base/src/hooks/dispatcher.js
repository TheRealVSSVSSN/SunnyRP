const crypto = require('crypto');
const logger = require('../utils/logger');
const config = require('../config/env');

const sinks = [];

function register(type, url, secret, enabled = true) {
  sinks.push({ type, url, secret, enabled });
}

async function sendWithRetry(sink, body, attempt = 0) {
  if (attempt > config.webhook.maxRetries) {
    logger.error({ sink: sink.type }, 'Webhook delivery failed, dropping');
    return;
  }
  const signature = crypto.createHmac('sha256', sink.secret || '').update(body).digest('hex');
  try {
    const res = await fetch(sink.url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-Signature': signature },
      body,
    });
    if (!res.ok) throw new Error(`status ${res.status}`);
  } catch (err) {
    const backoff = config.webhook.retryBaseMs * 2 ** attempt + Math.random() * 100;
    setTimeout(() => sendWithRetry(sink, body, attempt + 1), backoff);
  }
}

function dispatch(event, payload) {
  const body = JSON.stringify({ event, payload, createdAt: Date.now() });
  sinks.filter((s) => s.enabled).forEach((sink) => sendWithRetry(sink, body));
}

// Scaffolded Discord sink – disabled by default
if (config.webhook.discord.url) {
  register('discord', config.webhook.discord.url, config.webhook.discord.secret, config.webhook.discord.enabled);
}

module.exports = { register, dispatch };
