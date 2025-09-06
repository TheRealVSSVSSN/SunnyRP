// Updated: 2024-11-28
import crypto from 'crypto';

export function createWebSocketServer(server) {
  const clients = new Set();
  server.on('upgrade', (req, socket) => {
    if (req.headers['upgrade'] !== 'websocket') {
      socket.end('HTTP/1.1 400 Bad Request');
      return;
    }
    const key = req.headers['sec-websocket-key'];
    const accept = crypto
      .createHash('sha1')
      .update(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')
      .digest('base64');
    const headers = [
      'HTTP/1.1 101 Switching Protocols',
      'Upgrade: websocket',
      'Connection: Upgrade',
      `Sec-WebSocket-Accept: ${accept}`,
      '\r\n',
    ];
    socket.write(headers.join('\r\n'));
    socket.isAlive = true;
    socket.on('pong', () => {
      socket.isAlive = true;
    });
    socket.on('data', (buffer) => {
      const opcode = buffer[0] & 0x0f;
      if (opcode === 0x8) {
        socket.end();
      } else if (opcode === 0x9) {
        socket.write(Buffer.from([0x8a, 0x00]));
      }
    });
    socket.on('close', () => {
      clients.delete(socket);
    });
    clients.add(socket);
  });

  setInterval(() => {
    for (const ws of clients) {
      if (!ws.isAlive) {
        ws.end();
        clients.delete(ws);
        continue;
      }
      ws.isAlive = false;
      ws.write(Buffer.from([0x89, 0x00]));
      if (ws.writableLength > 1_048_576) {
        ws.end();
        clients.delete(ws);
      }
    }
  }, 30000);
}
