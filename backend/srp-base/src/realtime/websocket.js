const WebSocket = require('ws');
const { v4: uuidv4 } = require('uuid');
const config = require('../config/env');
const logger = require('../utils/logger');

let wssInstance;
let namespaces = new Map();

function broadcast(namespace, event, data) {
  if (!wssInstance) return;
  const payload = JSON.stringify({
    eventId: uuidv4(),
    createdAt: Date.now(),
    ttl: config.wsHeartbeatIntervalMs || 30000,
    type: `${namespace}.${event}`,
    payload: data,
  });
  const clients = namespaces.get(namespace);
  if (!clients) return;
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN && client.bufferedAmount < 1e6) {
      client.send(payload);
    }
  });
}

function init(server) {
  wssInstance = new WebSocket.Server({ server, path: '/ws' });

  wssInstance.on('connection', (ws, req) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      const token = url.searchParams.get('token');
      if (token !== config.apiToken) {
        ws.close();
        return;
      }
      const ns = url.searchParams.get('ns') || 'global';
      ws.namespace = ns;
      if (!namespaces.has(ns)) namespaces.set(ns, new Set());
      namespaces.get(ns).add(ws);
    } catch (err) {
      ws.close();
      return;
    }
    ws.isAlive = true;
    ws.on('close', () => {
      const set = namespaces.get(ws.namespace);
      if (set) set.delete(ws);
    });
    ws.on('pong', () => {
      ws.isAlive = true;
    });
  });

  const interval = setInterval(() => {
    wssInstance.clients.forEach((ws) => {
      if (!ws.isAlive) {
        return ws.terminate();
      }
      ws.isAlive = false;
      ws.ping();
    });
  }, config.wsHeartbeatIntervalMs || 30000);

  wssInstance.broadcast = broadcast;
  wssInstance.on('close', () => {
    clearInterval(interval);
    namespaces = new Map();
  });
  logger.info('WebSocket gateway initialised');
  return wssInstance;
}

module.exports = { init, broadcast };
