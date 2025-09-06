# Manifest

## Summary
- Introduced srp-base resource skeleton with HTTP wrappers, failover circuit breaker, and RPC dispatch.
- Added Node internal RPC endpoint and Lua bridge for bidirectional communication.

## Files
| Path | Type | Notes |
|------|------|-------|
| resources/srp-base/fxmanifest.lua | A | resource manifest |
| resources/srp-base/shared/srp.lua | A | export namespace |
| resources/srp-base/server/http.lua | A | HTTP wrappers |
| resources/srp-base/server/http_handler.lua | A | internal HTTP surface |
| resources/srp-base/server/failover.lua | A | circuit breaker and queue |
| resources/srp-base/server/rpc.lua | A | RPC dispatcher |
| resources/srp-base/server/modules/sessions.lua | A | session stub |
| resources/srp-base/server/modules/queue.lua | A | queue stub |
| resources/srp-base/server/modules/voice.lua | A | voice stub |
| resources/srp-base/server/modules/telemetry.lua | A | telemetry stub |
| resources/srp-base/server/modules/ux.lua | A | UX stub |
| resources/srp-base/server/modules/world.lua | A | world stub |
| resources/srp-base/server/modules/jobs.lua | A | jobs stub |
| backend/srp-base/src/routes/internal.js | A | internal RPC endpoint |
| backend/srp-base/src/util/luaBridge.js | A | Node to Lua HTTP bridge |
| backend/srp-base/src/app.js | M | mount internal RPC route |

## Startup/Env
- Set `srp_internal_key` and optional `srp_node_base_url` convars for internal HTTP requests.
