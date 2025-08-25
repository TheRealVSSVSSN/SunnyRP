# Manifest

- Added hourly purge and expiry events for Wise Wheels spins.
- Indexed `wise_wheels_spins.created_at` for efficient retention cleanup.
- Broadcast asset create/delete events and scheduled asset retention cleanup.
- Added unified properties backend with lease expiry scheduler.

| File | Action | Note |
|---|---|---|
| src/tasks/wiseWheels.js | A | Purges expired spins and emits events |
| src/repositories/wiseWheelsRepository.js | M | Added `purgeOldSpins` helper |
| src/server.js | M | Registers schedulers including `wise-wheels-expire` and `assets-prune` |
| src/migrations/064_add_wise_wheels_created_index.sql | A | Indexes `created_at` |
| src/migrations/065_add_assets_created_index.sql | A | Indexes assets `created_at` |
| src/routes/assets.routes.js | M | WebSocket and webhook pushes |
| src/repositories/assetsRepository.js | M | Added `deleteOlderThan` helper |
| src/tasks/assets.js | A | Prunes stale assets |
| docs/modules/assets.md | M | Documented realtime and retention |
| docs/progress-ledger.md | M | Logged assets realtime update |
| docs/index.md | M | Run summary for assets realtime |
| docs/BASE_API_DOCUMENTATION.md | M | Added `ASSET_RETENTION_MS` config |
| docs/db-schema.md | M | Documented new assets index |
| docs/migrations.md | M | Listed migration |
| docs/admin-ops.md | M | Index and retention notes |
| docs/events-and-rpcs.md | M | Added asset event mapping |
| docs/framework-compliance.md | M | Updated evaluation |
| docs/naming-map.md | M | Added asset mappings |
| docs/run-docs.md | M | Summary of this run |
| docs/research-log.md | M | Logged assets research |
| CHANGELOG.md | M | Release notes for assets retention |
| src/repositories/propertiesRepository.js | A | Property persistence helpers |
| src/routes/properties.routes.js | A | `/v1/properties` endpoints |
| src/tasks/properties.js | A | Hourly lease expiry task |
| src/server.js | M | Registers `properties-expire` task |
| src/app.js | M | Mounts properties routes |
| src/migrations/066_add_properties.sql | A | Properties table |
| openapi/api.yaml | M | Documented properties paths and schemas |
| docs/modules/properties.md | A | Module docs |
| docs/events-and-rpcs.md | M | Mapped property events |
| docs/db-schema.md | M | Documented properties table |
| docs/migrations.md | M | Listed properties migration |
| docs/admin-ops.md | M | Properties table notes |
| docs/naming-map.md | M | apartments/garages → properties |
| docs/research-log.md | M | Logged properties research |
| docs/index.md | M | Update summary for properties module |
| docs/progress-ledger.md | M | Logged properties module |
| docs/framework-compliance.md | M | Evaluation update |
| docs/todo-gaps.md | A | Outstanding tasks |
| docs/run-docs.md | M | Run summary updated |
| docs/BASE_API_DOCUMENTATION.md | M | Documented properties endpoints |
