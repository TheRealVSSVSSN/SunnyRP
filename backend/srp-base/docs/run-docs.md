# Run Documentation – 2025-08-27

## Changed Docs
- docs/admin-ops.md
- docs/BASE_API_DOCUMENTATION.md
- docs/db-schema.md
- docs/events-and-rpcs.md
- docs/index.md
- docs/modules/furniture.md
- docs/naming-map.md
- docs/progress-ledger.md
- docs/research-log.md
- docs/testing.md
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
| Add admin endpoints for cron job management | backend | low | none |
| Bulk sync endpoint for favorite emotes | backend | low | design |
| Allow labeling/ordering of favorite emotes | backend | low | design |
