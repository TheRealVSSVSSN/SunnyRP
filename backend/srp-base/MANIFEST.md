# MANIFEST

- `src/server.js` – Express HTTP server with health, ready, info, and RPC endpoints.
- `src/routes/base.routes.js` – account character routes.
- `src/repositories/baseRepository.js` – in-memory data store.
- `src/middleware/*` – request handling utilities.
- `src/util/luaBridge.js` – bridge to FX loopback.
- `src/realtime/websocket.js` – minimal WebSocket server with heartbeat.

## Environment
- `PORT` – HTTP port (default 4000)
- `FX_HTTP_PORT` – FX loopback port
- `SRP_INTERNAL_KEY` – shared secret for internal calls
