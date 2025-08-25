# Manifest – 2025-08-25

## Summary
- Added webhook endpoint management and InteractSound broadcast with retention purge.
- Added dispatch alert APIs with WebSocket/webhook push and hourly retention purge.

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
| `src/config/env.js` | M | Added interactSound and dispatch retention config |
| `src/migrations/060_add_world_timecycle.sql` | R | Renamed from 059 to resolve duplicate |
| `src/migrations/061_add_dispatch_alert_index.sql` | A | Index on dispatch_alerts.created_at |
| `src/repositories/dispatchRepository.js` | M | Add purge helper |
| `src/routes/dispatch.routes.js` | M | WS/webhook broadcast and structured responses |
| `src/tasks/dispatch.js` | A | Purge old dispatch alerts |
| `src/server.js` | M | Register dispatch purge task |
| `openapi/api.yaml` | M | Document dispatch endpoints |
| `docs/index.md` | M | Logged dispatch update |
| `docs/progress-ledger.md` | M | Added dispatch entry |
| `docs/framework-compliance.md` | M | Note dispatch workflow gap and module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented dispatch endpoints |
| `docs/events-and-rpcs.md` | M | Map dispatch resource |
| `docs/db-schema.md` | M | Document dispatch_alerts table |
| `docs/migrations.md` | M | Logged dispatch index migration |
| `docs/admin-ops.md` | M | Dispatch retention config |
| `docs/modules/interactSound.md` | M | Broadcast and purge details |
| `docs/modules/hooks.md` | A | Module documentation |
| `docs/modules/dispatch.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged dispatch references |
| `docs/run-docs.md` | M | Combined summary update |

## Startup Notes
- Run `node src/bootstrap/migrate.js` to apply migrations `060_add_world_timecycle.sql` and `061_add_dispatch_alert_index.sql`.
