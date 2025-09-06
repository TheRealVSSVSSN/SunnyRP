# srp-base Manifest

## Added
- src/server.js
- src/util/luaBridge.js
- src/middleware/requestId.js
- src/middleware/rateLimit.js
- src/middleware/hmacAuth.js
- src/middleware/idempotency.js
- src/middleware/validate.js
- src/middleware/errorHandler.js
- src/routes/base.routes.js
- src/repositories/baseRepository.js
- src/realtime/websocket.js
- package.json
- .env.example
- README.md

## Environment Variables
- `PORT` server port
- `FX_HTTP_PORT` FiveM HTTP handler port
- `SRP_INTERNAL_KEY` shared secret
- `SRP_OVERLOAD_EL_LAG_MS` event loop lag threshold
- `SRP_OVERLOAD_CPU_PCT` CPU threshold
- `SRP_OVERLOAD_INFLIGHT` inflight request threshold
