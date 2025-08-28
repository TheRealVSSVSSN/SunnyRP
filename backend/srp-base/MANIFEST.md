# Manifest

- Track recycling job deliveries with realtime push and cleanup scheduler.
- Update OpenAPI validator dependency for install success.
- Persist and broadcast vehicle control state with cleanup scheduler.

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
| src/routes/vehicles.routes.js | M | Add control state endpoints |
| src/repositories/vehicleControlRepository.js | A | Persist vehicle control state |
| src/tasks/vehicleControl.js | A | Purge stale control records |
| src/config/env.js | M | Add vehicle control retention config |
| src/server.js | M | Register vehicle control cleanup task |
| src/migrations/082_add_vehicle_control_states.sql | A | Vehicle control states table |
| docs/modules/vehicles.md | M | Document control endpoints |
| docs/BASE_API_DOCUMENTATION.md | M | Add control API mapping |
| docs/db-schema.md | M | Describe vehicle_control_states table |
| docs/migrations.md | M | List migration 082 |
| docs/events-and-rpcs.md | M | Map lux_vehcontrol events |
| docs/naming-map.md | M | Map lux_vehcontrol to vehicle-control |
| docs/progress-ledger.md | M | Record vehicle control entry |
| docs/index.md | M | Note vehicle control update |
| docs/framework-compliance.md | M | Add vehicle control module note |
| docs/research-log.md | M | Log lux_vehcontrol research |
| docs/run-docs.md | M | Summarize vehicle control run |
| openapi/api.yaml | M | Define vehicle control schemas and paths |
