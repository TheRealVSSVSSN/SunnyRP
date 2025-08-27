# Run Summary – 2025-08-26

## Modules
- Coordinates: renamed from coordsaver with WebSocket/webhook events and daily purge scheduler.

## Documentation Updated
- docs/progress-ledger.md
- docs/events-and-rpcs.md
- docs/modules/coordinates.md
- docs/admin-ops.md
- docs/BASE_API_DOCUMENTATION.md
- docs/framework-compliance.md
- docs/naming-map.md
- docs/index.md
- docs/testing.md
- docs/research-log.md
- docs/migrations.md
- docs/run-docs.md

## Outstanding TODO/Gaps
| Item | Owner | Priority | Blockers |
|---|---|---|---|
| Migrate existing apartment and garage consumers to new properties API | backend | high | client updates |
| Link interior templates and garage capacity to properties | backend | medium | design of interior data |
| Dispatch property events to external webhooks | backend | medium | webhook endpoint adoption |
| Paginate and search property listings | backend | low | none |
| Document world event endpoints in OpenAPI | backend | medium | spec alignment |
| Integrate player vitals (hunger, thirst, stress) into HUD module | backend | medium | gameplay design |
| Add admin bulk adjustment endpoints for queue priorities | backend | low | none |
