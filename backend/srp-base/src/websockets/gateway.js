import { Server } from 'socket.io';
import crypto from 'crypto';
import { logger } from '../util/logger.js';
import { dispatch as dispatchWebhook } from '../webhooks/dispatcher.js';

let io;

export function initGateway(server) {
  io = new Server(server, { cors: { origin: '*' } });
  io.use((socket, next) => {
    const { sid, accountId, characterId } = socket.handshake.auth || {};
    if (!sid) return next(new Error('sid required'));
    socket.data = { sid, accountId, characterId };
    next();
  });
  io.on('connection', socket => {
    logger.debug({ sid: socket.data.sid }, 'ws connected');
    socket.on('ping', () => socket.emit('pong'));
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
  if (io) io.emit('event', evt);
  dispatchWebhook(evt).catch(err => logger.error({ err }, 'webhook dispatch failed'));
}
