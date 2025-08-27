# Manifest

- Added ped WebSocket and webhook broadcasts with health regeneration scheduler.

| File | Action | Note |
|---|---|---|
| src/repositories/pedsRepository.js | M | Added health regeneration helper |
| src/routes/peds.routes.js | M | Broadcast ped updates via WebSocket and webhooks |
| src/realtime/websocket.js | M | Introduced namespaces and typed envelopes |
| src/tasks/peds.js | A | Scheduler task for ped health regeneration |
| src/server.js | M | Registered peds-health-regen scheduler |
| docs/modules/peds.md | M | Documented realtime events and scheduler |
| docs/BASE_API_DOCUMENTATION.md | M | Added peds WebSocket info |
| docs/events-and-rpcs.md | M | Mapped isPed events to SRP API |
| docs/admin-ops.md | M | Listed character_peds table and regen task |
| docs/index.md | M | Logged isPed update summary |
| docs/progress-ledger.md | M | Recorded isPed realtime entry |
| docs/framework-compliance.md | M | Added peds module compliance note |
| docs/naming-map.md | M | Mapped isPed → peds |
| docs/research-log.md | M | Logged isPed resource research |
| docs/todo-gaps.md | M | Added ped attributes outstanding item |
| docs/run-docs.md | M | Consolidated documentation for this run |
