# Manifest – 2025-08-25

## Summary
- Added webhook endpoint management and InteractSound broadcast with retention purge.

## File Changes
| Path | Status | Notes |
|---|---|---|
| `src/repositories/interactSoundRepository.js` | M | Fix query; add purge helper |
| `src/routes/interactSound.routes.js` | M | WebSocket broadcast and webhook dispatch |
| `src/realtime/websocket.js` | M | Export broadcast helper |
| `src/hooks/dispatcher.js` | M | Dead-letter logging and sink management |
| `src/routes/hooks.routes.js` | A | Admin CRUD for webhook sinks |
| `src/bootstrap/scheduler.js` | M | Drift-corrected scheduling with lastRun |
| `src/tasks/interactSound.js` | A | Purge old sound play records |
| `src/server.js` | M | Register interactSound purge task |
| `src/config/env.js` | M | Added interactSound retention config |
| `src/migrations/060_add_world_timecycle.sql` | R | Renamed from 059 to resolve duplicate |
| `openapi/api.yaml` | M | Documented webhook endpoints |
| `docs/index.md` | M | Logged InteractSound and hooks updates |
| `docs/progress-ledger.md` | M | Added InteractSound cluster entry |
| `docs/framework-compliance.md` | M | Updated for webhook CRUD |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented hooks endpoints |
| `docs/events-and-rpcs.md` | M | InteractSound broadcast mapping |
| `docs/db-schema.md` | M | Sound play retention note |
| `docs/migrations.md` | M | Renamed world timecycle migration |
| `docs/admin-ops.md` | M | Documented webhook management |
| `docs/modules/interactSound.md` | M | Broadcast and purge details |
| `docs/modules/hooks.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged InteractSound reference |
| `docs/run-docs.md` | M | Combined summary |

## Startup Notes
- Run `node src/bootstrap/migrate.js` to apply migration `060_add_world_timecycle.sql`.
