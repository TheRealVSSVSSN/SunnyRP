# Manifest

- Added camera photo realtime events and scheduled retention purge.
- Added vehicle HUD state API with WebSocket broadcasts and hourly cleanup.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Camera retention and cleanup settings |
| src/repositories/cameraRepository.js | M | Add purge helper |
| src/routes/camera.routes.js | M | Broadcast and dispatch events |
| src/tasks/camera.js | A | Purge old photos |
| src/server.js | M | Register camera purge scheduler |
| src/migrations/069_add_camera_photos_created_index.sql | A | Index camera_photos.created_at |
| openapi/api.yaml | M | Add camera event extensions |
| docs/BASE_API_DOCUMENTATION.md | M | Document camera events and retention |
| docs/events-and-rpcs.md | M | Map camera events |
| docs/db-schema.md | M | Note camera_photos indexes |
| docs/migrations.md | M | Log migration 069 |
| docs/modules/camera.md | M | Describe realtime and purge |
| docs/progress-ledger.md | M | Record camera realtime entry |
| docs/index.md | M | Summarize camera realtime support |
| docs/naming-map.md | M | Map np-camera → camera |
| docs/research-log.md | M | Log camera resource attempt |
| docs/run-docs.md | A | Consolidated run notes |
| src/repositories/vehicleStatusRepository.js | A | Persist vehicle HUD state |
| src/migrations/070_add_character_vehicle_status.sql | A | Vehicle HUD state table |
| src/tasks/hud.js | A | Prune stale vehicle HUD state |
| src/routes/hud.routes.js | M | Add vehicle state endpoints and broadcasts |
| src/server.js | M | Register HUD state cleanup scheduler |
| openapi/api.yaml | M | Document vehicle state schemas and paths |
| docs/BASE_API_DOCUMENTATION.md | M | Add vehicle state endpoints |
| docs/admin-ops.md | M | Note vehicle status table |
| docs/db-schema.md | M | Document vehicle status schema |
| docs/events-and-rpcs.md | M | Map vehicle state events |
| docs/framework-compliance.md | M | Note vehicle state compliance |
| docs/index.md | M | Summarize HUD vehicle state support |
| docs/migrations.md | M | Log migration 070 |
| docs/modules/hud.md | M | Document vehicle state API |
| docs/naming-map.md | M | Map carandplayerhud → hud |
| docs/progress-ledger.md | M | Record carandplayerhud entry |
| docs/research-log.md | M | Log carandplayerhud research |
| docs/run-docs.md | M | Summarize hud run |
| docs/todo-gaps.md | M | Track pending HUD vitals work |
