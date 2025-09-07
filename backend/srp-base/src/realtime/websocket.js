/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const { Server } = require('socket.io');

module.exports = (httpServer) => {
  const io = new Server(httpServer, { path: '/ws/base' });
  io.use((socket, next) => {
    const { sid, accountId } = socket.handshake.query;
    if (!sid || !accountId) return next(new Error('invalid_handshake'));
    socket.data.sid = sid;
    socket.data.accountId = accountId;
    socket.data.characterId = socket.handshake.query.characterId;
    next();
  });
  io.on('connection', (socket) => {
    socket.emit('ready');
  });
  return io;
};
