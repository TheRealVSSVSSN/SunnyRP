# Run Docs – 2025-08-30 (np-bennys)

## Summary
- Added mechanic work orders backend with realtime events and scheduler.
- Reference resources unavailable; proceeding with internal consistency only.

## Updated Documentation
- `docs/modules/mechanic.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/admin-ops.md`
- `docs/research-log.md`
- `docs/naming-map.md`
- `CHANGELOG.md`
- `MANIFEST.md`

## Update – 2025-08-30 (broadcast)

- Added broadcast messages backend with WebSocket/webhook push and hourly purge scheduler.

### Updated Documentation
- `docs/modules/broadcast.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/admin-ops.md`
- `docs/security.md`
- `docs/testing.md`
- `docs/research-log.md`
- `docs/naming-map.md`
- `CHANGELOG.md`
- `MANIFEST.md`

## Update – 2025-08-30 (np-dealer)

- Added dealer offer backend with WebSocket/webhook events and minute purge scheduler.

### Updated Documentation
- `docs/modules/dealers.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/admin-ops.md`
- `docs/testing.md`
- `docs/naming-map.md`
- `docs/research-log.md`
- `openapi/api.yaml`
- `CHANGELOG.md`
- `MANIFEST.md`


## Update – 2025-08-30 (np-camera)

- Added photo description update endpoint with realtime WebSocket/webhook events.

### Updated Documentation
- `docs/modules/camera.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/naming-map.md`
- `docs/research-log.md`
- `openapi/api.yaml`

## Update – 2025-08-30 (np-commands)

- Added command definition backend with realtime WebSocket/webhook events.

### Updated Documentation
- `docs/modules/commands.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/events-and-rpcs.md`
- `docs/admin-ops.md`
- `docs/naming-map.md`
- `docs/research-log.md`
- `openapi/api.yaml`
- `CHANGELOG.md`
- `MANIFEST.md`
- `docs/BASE_API_DOCUMENTATION.md`

## Update – 2025-08-30 (np-contracts)

- Added contract lifecycle WebSocket/webhook events and hourly purge scheduler.

### Updated Documentation
- `docs/modules/contracts.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/admin-ops.md`
- `docs/security.md`
- `docs/testing.md`
- `docs/naming-map.md`
- `docs/research-log.md`
- `CHANGELOG.md`
- `MANIFEST.md`

## Update – 2025-08-30 (np-crimeschool)

- Added crime school progress backend with realtime push and purge scheduler.

### Updated Documentation
- `docs/modules/crime-school.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/admin-ops.md`
- `docs/security.md`
- `docs/testing.md`
- `docs/naming-map.md`
- `docs/research-log.md`
- `openapi/api.yaml`
- `MANIFEST.md`
- `CHANGELOG.md`

## Update – 2025-08-30 (np-dances)

- Added dance animation definitions backend with realtime push and purge scheduler.

### Updated Documentation
- `docs/modules/dances.md`
- `docs/index.md`
- `docs/progress-ledger.md`
- `docs/framework-compliance.md`
- `docs/BASE_API_DOCUMENTATION.md`
- `docs/events-and-rpcs.md`
- `docs/db-schema.md`
- `docs/migrations.md`
- `docs/admin-ops.md`
- `docs/security.md`
- `docs/testing.md`
- `docs/research-log.md`
- `docs/naming-map.md`
- `openapi/api.yaml`
- `MANIFEST.md`
- `CHANGELOG.md`

## Outstanding Items
- Migrate existing apartment and garage consumers to new properties API
- Link interior templates and garage capacity to properties
- Dispatch property events to external webhooks
- Paginate and search property listings
- Document world event endpoints in OpenAPI
- Integrate player vitals (hunger, thirst, stress) into HUD module
- Add admin bulk adjustment endpoints for queue priorities
- Add admin endpoints for cron job management
- Bulk sync endpoint for favorite emotes
- Allow labeling/ordering of favorite emotes
- Implement call-sign management for police officers
- Add altitude and location tracking for helicopter flights
- Support editing existing import pack orders
- Persist additional ped attributes such as position and appearance
- Implement paycheck and grade progression logic for jobs
- Allow assigning handlers via K9 API
- Document hacking endpoints in BASE_API_DOCUMENTATION and events-and-rpcs
- Add db-schema entry for hacking_attempts table
- Record mhacking research sources in research-log.md
- Add pagination for `/v1/minimap/blips`
- Develop crime school curriculum and reward logic
- Support dealer offer purchase flow and stock management
