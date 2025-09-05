import { Server } from 'socket.io';
import crypto from 'crypto';
import { logger } from '../util/logger.js';
import { dispatch as dispatchWebhook } from '../webhooks/dispatcher.js';
import { ownsCharacter } from '../repositories/characters.js';

let io;
const namespaces = {};
const limiters = {};
const RATE_LIMIT = Number(process.env.WS_RATE_LIMIT) || 100;

function allow(domain) {
  const now = Date.now();
  const limiter = limiters[domain] || { count: 0, reset: now + 1000 };
  if (now > limiter.reset) {
    limiter.count = 0;
    limiter.reset = now + 1000;
  }
  if (limiter.count >= RATE_LIMIT) return false;
  limiter.count++;
  limiters[domain] = limiter;
  return true;
}

export function initGateway(server, domains = []) {
  io = new Server(server, { cors: { origin: '*' }, path: '/ws' });
  const middleware = async (socket, next) => {
    try {
      const { sid, accountId, characterId } = socket.handshake.auth || {};
      if (!sid || !accountId || !characterId) {
        return next(new Error('authorization required'));
      }
      const valid = await ownsCharacter(Number(accountId), Number(characterId));
      if (!valid) return next(new Error('unauthorized'));
      socket.data = {
        sid,
        accountId: Number(accountId),
        characterId: Number(characterId)
      };
      next();
    } catch (err) {
      next(err);
    }
  };
  domains.forEach(domain => {
    const ns = io.of(`/${domain}`);
    ns.use(middleware);
    ns.on('connection', socket => {
      logger.debug({ sid: socket.data.sid, domain }, 'ws connected');
      socket.on('ping', () => socket.emit('pong'));
    });
    namespaces[domain] = ns;
  });
}

export function emitEvent(domain, action, subject, data) {
  const evt = {
    id: `evt_${crypto.randomUUID()}`,
    type: `srp.${domain}.${action}`,
    source: 'srp-base',
    subject,
    time: new Date().toISOString(),
    specversion: '1.0',
    data
  };
  const ns = namespaces[domain];
  if (ns && allow(domain)) {
    ns.emit('event', evt);
  }
  dispatchWebhook(evt).catch(err => logger.error({ err }, 'webhook dispatch failed'));
}
