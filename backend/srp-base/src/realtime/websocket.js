/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const { WebSocketServer } = require('ws');

module.exports = (httpServer) => {
  const wss = new WebSocketServer({ server: httpServer, path: '/ws/base' });
  wss.on('connection', (ws, req) => {
    const url = new URL(req.url, 'http://localhost');
    const sid = url.searchParams.get('sid');
    const accountId = url.searchParams.get('accountId');
    if (!sid || !accountId) {
      ws.close(1008, 'invalid_handshake');
      return;
    }
    ws.sid = sid;
    ws.accountId = accountId;
    ws.characterId = url.searchParams.get('characterId');
    ws.send(JSON.stringify({ event: 'ready' }));
  });
  return wss;
};
