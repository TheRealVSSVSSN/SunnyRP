# Run Summary – 2025-08-25

## Modules
- Assets realtime broadcast and cleanup scheduler
- Properties API consolidating apartments, garages and rentals

## Migrations
- 065_add_assets_created_index.sql
- 066_add_properties.sql

## Documentation Updated
- docs/index.md
- docs/progress-ledger.md
- docs/framework-compliance.md
- docs/events-and-rpcs.md
- docs/db-schema.md
- docs/migrations.md
- docs/admin-ops.md
- docs/naming-map.md
- docs/modules/properties.md
- docs/research-log.md
- docs/todo-gaps.md
- docs/BASE_API_DOCUMENTATION.md

## Outstanding TODO/Gaps

| Item | Owner | Priority | Blockers |
|---|---|---|---|
| Migrate existing apartment and garage consumers to new properties API | backend | high | client updates |
| Link interior templates and garage capacity to properties | backend | medium | design of interior data |
| Dispatch property events to external webhooks | backend | medium | webhook endpoint adoption |
| Paginate and search property listings | backend | low | none |
