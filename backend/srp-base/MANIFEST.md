# Manifest

- Added realtime job assignment pushes and roster scheduler.

| File | Action | Note |
|---|---|---|
| src/repositories/jobsRepository.js | M | Added on-duty roster query |
| src/routes/jobs.routes.js | M | Broadcast/dispatch `jobs.assigned` and `jobs.duty` |
| src/tasks/jobs.js | A | Scheduler broadcasting `jobs.roster` |
| src/server.js | M | Registered jobs roster sync task |
| openapi/api.yaml | M | Documented job webhook events |
| docs/modules/jobs.md | M | Added WS/webhook and scheduler notes |
| docs/BASE_API_DOCUMENTATION.md | M | Documented job events |
| docs/events-and-rpcs.md | M | Mapped `jobs.*` events |
| docs/framework-compliance.md | M | Updated jobs module compliance |
| docs/index.md | M | Logged jobs update |
| docs/naming-map.md | M | Added jobsystem mapping |
| docs/progress-ledger.md | M | Recorded jobs realtime entry |
| docs/research-log.md | M | Logged jobs research |
| docs/todo-gaps.md | M | Added job progression TODO |
| docs/run-docs.md | A | Consolidated doc summary for this run |
| src/config/env.js | M | Added debug retention and cleanup interval |
| src/repositories/debugRepository.js | M | Added logs/markers persistence helpers |
| src/routes/debug.routes.js | M | Added /v1/debug/logs and /v1/debug/markers APIs |
| src/tasks/debug.js | A | Scheduler purge for markers/logs with WS/webhook emits |
| src/server.js | M | Registered debug maintenance task |
| src/migrations/080_add_debug.sql | A | Created debug_logs and debug_markers tables |
| openapi/api.yaml | M | Added DebugLog/Marker schemas and paths |
| docs/modules/debug.md | M | Expanded debug module docs |
| docs/db-schema.md | M | Documented debug tables |
| docs/migrations.md | M | Logged 080_add_debug.sql |
