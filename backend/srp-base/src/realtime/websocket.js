const WebSocket = require('ws');
const { v4: uuidv4 } = require('uuid');
const config = require('../config/env');
const logger = require('../utils/logger');

function init(server) {
  const wss = new WebSocket.Server({ server, path: '/ws' });

  wss.on('connection', (ws, req) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      const token = url.searchParams.get('token');
      if (token !== config.apiToken) {
        ws.close();
        return;
      }
    } catch (err) {
      ws.close();
      return;
    }
    ws.isAlive = true;
    ws.on('pong', () => {
      ws.isAlive = true;
    });
  });

  const interval = setInterval(() => {
    wss.clients.forEach((ws) => {
      if (!ws.isAlive) {
        return ws.terminate();
      }
      ws.isAlive = false;
      ws.ping();
    });
  }, config.wsHeartbeatIntervalMs || 30000);

  wss.broadcast = function broadcast(topic, event, data) {
    const payload = JSON.stringify({
      eventId: uuidv4(),
      createdAt: Date.now(),
      ttl: config.wsHeartbeatIntervalMs || 30000,
      topic,
      event,
      data,
    });
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN && client.bufferedAmount < 1e6) {
        client.send(payload);
      }
    });
  };

  wss.on('close', () => clearInterval(interval));
  logger.info('WebSocket gateway initialised');
  return wss;
}

module.exports = { init };
