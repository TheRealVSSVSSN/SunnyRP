# Manifest

- Added ready notifier scheduler and delivery endpoint for Wise Imports.
- Introduced `updated_at` column and status index for import orders.
- Documented new endpoints and database changes across docs.

| File | Action | Note |
|---|---|---|
| src/tasks/wiseImports.js | A | Periodically marks pending orders ready |
| src/repositories/wiseImportsRepository.js | M | Status transitions and delivery logic |
| src/routes/wiseImports.routes.js | M | Delivery endpoint & pushes |
| src/bootstrap/scheduler.js | M | Persist last run via cron jobs |
| src/repositories/cronRepository.js | M | Added `updateLastRun` helper |
| src/migrations/063_update_wise_import_orders.sql | A | Adds `updated_at` column & status index |
| src/server.js | M | Registers Wise Imports scheduler |
| openapi/api.yaml | M | Schemas and deliver path |
| docs/modules/wise-imports.md | M | Documented scheduler and delivery |
| docs/progress-ledger.md | M | Logged Wise Imports ready notifier |
| docs/index.md | M | Run summary for Wise Imports update |
| docs/BASE_API_DOCUMENTATION.md | M | Added deliver endpoint |
| docs/db-schema.md | M | Documented updated_at column |
| docs/migrations.md | M | Listed new migration |
| docs/admin-ops.md | M | Note on status index |
| docs/events-and-rpcs.md | M | Updated event mapping |
| docs/framework-compliance.md | M | Outstanding work for Wise Imports |
| docs/testing.md | M | Curl example for delivery |
| docs/research-log.md | M | Logged reference sources |
| docs/run-docs.md | M | Summary of this run |
| CHANGELOG.md | M | Release notes for scheduler & delivery |
