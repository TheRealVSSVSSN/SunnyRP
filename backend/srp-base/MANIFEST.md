# srp-base Manifest

Version: 1.0.2

## Files
- src/server.js
- src/util/luaBridge.js
- src/middleware/*.js
- src/routes/base.routes.js
- src/repositories/baseRepository.js
- src/realtime/websocket.js
- package.json
- .env.example
- README.md

## Environment Variables
- `PORT` – HTTP port (default 4000)
- `FX_HTTP_PORT` – FiveM HTTP port (default 30120)
- `SRP_INTERNAL_KEY` – shared secret for internal calls
- `SRP_OVERLOAD_EL_LAG_MS` – event loop lag threshold
- `SRP_OVERLOAD_CPU_PCT` – CPU threshold
- `SRP_OVERLOAD_INFLIGHT` – inflight requests threshold

## Failover
Node exposes `/v1/ready` with overload hints. Lua resource switches to failover when `X-SRP-Node-Overloaded` is `true` or when the node is unreachable.
