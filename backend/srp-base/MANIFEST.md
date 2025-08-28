# Manifest

- Track recycling job deliveries with realtime push and cleanup scheduler.
- Update OpenAPI validator dependency for install success.

| File | Action | Note |
|---|---|---|
| package.json | M | Bump express-openapi-validator to ^5.5.8 |
| src/routes/recycling.routes.js | A | Delivery logging endpoints |
| src/repositories/recyclingRepository.js | A | Recycling data persistence |
| src/tasks/recycling.js | A | Purge old deliveries |
| src/config/env.js | M | Add recycling retention config |
| src/app.js | M | Mount recycling routes |
| src/server.js | M | Register recycling purge task |
| src/migrations/081_add_recycling_runs.sql | A | Table for recycling runs |
| docs/modules/recycling.md | A | Module documentation |
| docs/naming-map.md | M | Map lmfao → recycling |
| docs/events-and-rpcs.md | M | Map lmfao events to API |
| docs/progress-ledger.md | M | Record recycling entry |
| docs/index.md | M | Note recycling update |
| docs/research-log.md | M | Log recycling research |
| docs/run-docs.md | M | Summarize run |
| docs/framework-compliance.md | M | Add recycling compliance note |
| docs/BASE_API_DOCUMENTATION.md | M | Document recycling endpoints |
| docs/db-schema.md | M | Describe recycling_runs table |
| docs/migrations.md | M | List migration 081 |
| openapi/api.yaml | M | Define recycling schemas and paths |
