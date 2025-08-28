# Manifest

- Added active K9 roster push with WebSocket/webhook events and scheduler.

| File | Action | Note |
|---|---|---|
| src/repositories/k9Repository.js | M | Added `listActive` helper |
| src/routes/k9.routes.js | M | Active list route + events/webhooks |
| src/tasks/k9.js | A | Scheduler broadcasting active roster |
| src/server.js | M | Registered k9 broadcast task |
| openapi/api.yaml | M | Documented `GET /v1/k9s/active` |
| docs/modules/k9.md | M | Documented new endpoint/events |
| docs/BASE_API_DOCUMENTATION.md | M | Added K9 active roster notes |
| docs/events-and-rpcs.md | M | Mapped K9 events and route |
| docs/framework-compliance.md | M | Updated K9 module compliance |
| docs/index.md | M | Logged K9 update |
| docs/naming-map.md | M | Added k9 mapping |
| docs/progress-ledger.md | M | Recorded K9 realtime entry |
| docs/research-log.md | M | Logged k9 resource research |
| docs/todo-gaps.md | M | Added K9 handler assignment TODO |
| docs/run-docs.md | M | Consolidated documentation |
