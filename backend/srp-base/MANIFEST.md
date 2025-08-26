# Manifest

- Added camera photo realtime events and scheduled retention purge.

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
