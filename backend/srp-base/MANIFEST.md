# Manifest

- Added hourly purge and expiry events for Wise Wheels spins.
- Indexed `wise_wheels_spins.created_at` for efficient retention cleanup.

| File | Action | Note |
|---|---|---|
| src/tasks/wiseWheels.js | A | Purges expired spins and emits events |
| src/repositories/wiseWheelsRepository.js | M | Added `purgeOldSpins` helper |
| src/server.js | M | Registers `wise-wheels-expire` scheduler |
| src/migrations/064_add_wise_wheels_created_index.sql | A | Indexes `created_at` |
| openapi/api.yaml | M | Documented spin expiry events |
| docs/modules/wise-wheels.md | M | Described purge scheduler |
| docs/progress-ledger.md | M | Logged spin retention update |
| docs/index.md | M | Run summary for Wise Wheels expiry |
| docs/BASE_API_DOCUMENTATION.md | M | Added expiry note |
| docs/db-schema.md | M | Documented new index |
| docs/migrations.md | M | Listed migration |
| docs/admin-ops.md | M | Index and scheduler notes |
| docs/events-and-rpcs.md | M | Added `spin.expired` mapping |
| docs/framework-compliance.md | M | Updated evaluation |
| docs/testing.md | M | Added purge test note |
| docs/research-log.md | M | Logged reference sources |
| docs/run-docs.md | M | Summary of this run |
| CHANGELOG.md | M | Release notes for spin expiry |
