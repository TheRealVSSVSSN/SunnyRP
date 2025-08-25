# Manifest

- Base events now broadcast to WebSocket clients and purge old logs hourly.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Add `BASE_EVENT_RETENTION_MS` |
| src/repositories/baseEventsRepository.js | M | Add stale log deletion helper |
| src/routes/baseEvents.routes.js | M | Broadcast `base-events.logged` |
| src/tasks/baseEvents.js | A | Purge old base event logs |
| src/server.js | M | Register base-events purge scheduler |
| docs/modules/baseevents.md | M | Document WebSocket and retention |
| docs/index.md | M | Log base event enhancements |
| docs/progress-ledger.md | M | Record baseevents update |
| docs/framework-compliance.md | M | Note WebSocket and scheduler |
| docs/BASE_API_DOCUMENTATION.md | M | Mention WebSocket broadcast |
| docs/events-and-rpcs.md | M | Map broadcast event |
| docs/db-schema.md | M | Note purge scheduler |
| docs/admin-ops.md | M | Add retention config |
| docs/research-log.md | M | Log baseevents research |
| docs/naming-map.md | M | Map baseevents/np-base → base-events |
| docs/run-docs.md | M | Summarize run |
