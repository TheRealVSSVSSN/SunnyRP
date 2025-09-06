# MANIFEST

- `src/server.js` – HTTP service with health, ready, info, and RPC routes.
- `src/routes/base.routes.js` – account character routes with idempotency and WS signals.
- `src/repositories/baseRepository.js` – in-memory store.
- `src/middleware/*` – request utilities (requestId, rateLimit, hmacAuth, idempotency, validate, errorHandler).
- `src/util/luaBridge.js` – loopback bridge to Lua with overload probe.
- `src/realtime/websocket.js` – socket.io namespace `/ws/base` with heartbeat.

## Environment
- `PORT` – HTTP port (default 4000)
- `FX_HTTP_PORT` – FX loopback port
- `SRP_INTERNAL_KEY` – shared secret for internal calls
- `SRP_OVERLOAD_EL_LAG_MS` – event loop lag threshold
- `SRP_OVERLOAD_CPU_PCT` – CPU usage threshold
- `SRP_OVERLOAD_INFLIGHT` – inflight request threshold
