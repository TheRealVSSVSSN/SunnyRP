# Manifest

- Added taxi request realtime events with expiry scheduler and config TTL.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Introduced `taxi.requestTtlMs` configuration |
| src/repositories/taxiRepository.js | M | Added stale request cancellation |
| src/tasks/taxi.js | A | Scheduler to expire taxi requests |
| src/server.js | M | Registered taxi expiry scheduler |
| src/routes/taxi.routes.js | M | Broadcast and webhook taxi events |
| src/migrations/074_add_taxi_rides_status_created_index.sql | A | Index on `(status, created_at)` |
| docs/modules/taxi.md | M | Documented scheduler and realtime events |
| docs/events-and-rpcs.md | M | Mapped taxi events |
| docs/BASE_API_DOCUMENTATION.md | M | Listed taxi WebSocket events |
| docs/progress-ledger.md | M | Logged taxi realtime entry |
| docs/framework-compliance.md | M | Noted taxi module compliance |
| docs/admin-ops.md | M | Added taxi index and TTL note |
| docs/db-schema.md | M | Recorded taxi index |
| docs/migrations.md | M | Added migration entry |
| docs/naming-map.md | M | Added es_taxi → taxi mapping |
| docs/index.md | M | Added taxi update summary |
| docs/research-log.md | M | Logged taxi research |
| docs/run-docs.md | M | Run summary and outstanding tasks |

**Startup Notes:** install dependencies with `npm install` (fails: express-openapi-validator@^4.18.3 not found).
