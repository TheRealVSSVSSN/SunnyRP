# Manifest

- Added hospital admission realtime events with cleanup scheduler.
- Added taxi request realtime events with expiry scheduler and config TTL.
- Added garage vehicle store/retrieve events with retention scheduler.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Added hospital broadcast settings, `taxi.requestTtlMs` and `garages.retentionMs` configuration |
| src/repositories/taxiRepository.js | M | Added stale request cancellation |
| src/tasks/taxi.js | A | Scheduler to expire taxi requests |
| src/server.js | M | Registered taxi expiry scheduler, hospital sync and garage purge |
| src/routes/taxi.routes.js | M | Broadcast and webhook taxi events |
| src/migrations/074_add_taxi_rides_status_created_index.sql | A | Index on `(status, created_at)` |
| docs/modules/taxi.md | M | Documented scheduler and realtime events |
| docs/events-and-rpcs.md | M | Mapped taxi, hospital and garage events |
| docs/BASE_API_DOCUMENTATION.md | M | Listed taxi, hospital and garage WebSocket events |
| docs/progress-ledger.md | M | Logged taxi, hospital and garage realtime entries |
| docs/framework-compliance.md | M | Noted taxi module compliance, hospital and garage realtime purge |
| docs/admin-ops.md | M | Added taxi index/TTL, hospital env tuning and garage retention/index note |
| docs/db-schema.md | M | Recorded taxi, hospital and garage indexes |
| docs/migrations.md | M | Added migration entries |
| docs/naming-map.md | M | Added es_taxi → taxi mapping |
| docs/index.md | M | Added taxi, hospital and garage update summaries |
| docs/research-log.md | M | Logged taxi, hospital and garage research |
| docs/run-docs.md | M | Run summary and outstanding tasks |
| src/routes/hospital.routes.js | M | Broadcast admission events |
| src/tasks/hospital.js | A | Scheduler to sync and auto-discharge admissions |
| openapi/api.yaml | M | Added 404 response for discharge |
| docs/modules/hospital.md | M | Documented realtime and scheduler |
| src/routes/garages.routes.js | M | Broadcast store/retrieve events and dispatch webhooks |
| src/repositories/garagesRepository.js | M | Added purge helper for retrieved vehicles |
| src/tasks/garages.js | A | Scheduler to purge retrieved vehicles |
| src/migrations/076_add_garage_vehicle_retrieved_index.sql | A | Index on `retrieved_at` |

**Startup Notes:** install dependencies with `npm install` (fails: express-openapi-validator@^4.18.3 not found).
