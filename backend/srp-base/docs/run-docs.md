# Run Summary – 2025-08-27

## Modules
- ems: realtime shift & record events with scheduled shift sync.

## Documentation Updated
- docs/progress-ledger.md
- docs/events-and-rpcs.md
- docs/modules/ems.md
- docs/index.md
- docs/research-log.md
- docs/naming-map.md
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
