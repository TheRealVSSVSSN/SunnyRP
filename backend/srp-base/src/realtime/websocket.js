// 2025-02-14
import { Server } from 'socket.io';

/**
 * Attaches a socket.io server with namespace /ws/base.
 */
export function createWebSocketServer(server) {
  const io = new Server(server, { path: '/ws' });
  const nsp = io.of('/ws/base');
  nsp.use((socket, next) => {
    const { sid, accountId, characterId } = socket.handshake.query;
    if (!sid || !accountId) return next(new Error('unauthorized'));
    socket.data = { sid, accountId, characterId };
    next();
  });
  nsp.on('connection', (socket) => {
    socket.on('ping', () => socket.emit('pong'));
  });
  setInterval(() => {
    for (const socket of nsp.sockets.values()) {
      if (socket.conn.transport.socket.writableLength > 1_048_576) {
        socket.disconnect(true);
      }
    }
  }, 30000);
  return nsp;
}
