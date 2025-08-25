# Manifest

- Added invoice API with WebSocket/webhook notifications.
- Introduced hourly invoice purge scheduler.

| File | Action | Note |
|---|---|---|
| src/repositories/invoiceRepository.js | A | Manage invoices and settlements |
| src/routes/economy.routes.js | M | Added invoice endpoints and realtime pushes |
| src/tasks/economy.js | A | Purges settled invoices |
| src/server.js | M | Registers invoice purge scheduler |
| src/migrations/067_add_invoices.sql | A | Creates invoices table |
| src/app.js | M | Added CORS and OpenAPI validator |
| src/config/env.js | M | Added `INVOICE_RETENTION_MS` config |
| openapi/api.yaml | M | Documented invoice paths and schemas |
| docs/modules/economy.md | M | Documented invoice APIs and realtime |
| docs/progress-ledger.md | M | Logged banking invoices |
| docs/naming-map.md | M | banking → economy |
| docs/admin-ops.md | M | Invoice table operations |
| docs/db-schema.md | M | Documented invoices table |
| docs/migrations.md | M | Listed invoice migration |
| docs/events-and-rpcs.md | M | Added invoice mapping |
| docs/security.md | M | Invoice auth notes |
| docs/testing.md | M | Added invoice test steps |
| docs/index.md | M | Update summary for invoices |
| docs/research-log.md | M | Logged banking invoice research |
| docs/run-docs.md | M | Run summary updated |
| CHANGELOG.md | M | Release notes for invoices |
| package.json | M | Added cors and OpenAPI validator |
