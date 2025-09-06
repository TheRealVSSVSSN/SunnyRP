const { Server } = require('socket.io');

function init(server) {
  const io = new Server(server, { path: '/ws/base' });
  const nsp = io.of('/ws/base');
  nsp.use((socket, next) => {
    const { sid, accountId } = socket.handshake.auth || socket.handshake.query || {};
    if (!sid || !accountId) return next(new Error('unauthorized'));
    socket.data.sid = sid;
    socket.data.accountId = accountId;
    next();
  });
  nsp.on('connection', (socket) => {
    socket.on('ping', () => socket.emit('pong'));
  });
  return io;
}

module.exports = { init };
