# Manifest

- Added world IPL state management with WebSocket broadcasts and scheduler sync.

| File | Action | Note |
|---|---|---|
| src/repositories/iplRepository.js | A | Persist interior proxy states |
| src/routes/world.routes.js | M | Expose IPL endpoints and broadcasts |
| src/tasks/world.js | A | Scheduler to broadcast IPL state |
| src/server.js | M | Register world IPL scheduler |
| src/migrations/068_add_ipls.sql | A | Create `ipl_states` table |
| openapi/api.yaml | M | Document IPL schemas and endpoints |
| docs/BASE_API_DOCUMENTATION.md | M | Describe IPL APIs |
| docs/events-and-rpcs.md | M | Map bob74_ipl events |
| docs/db-schema.md | M | Add `ipl_states` table |
| docs/migrations.md | M | Log migration 068 |
| docs/admin-ops.md | M | Note `ipl_states` table requirement |
| docs/modules/world.md | M | Document IPL routes and repository |
| docs/index.md | M | Summarize bob74_ipl support |
| docs/progress-ledger.md | M | Record bob74_ipl decision |
| docs/framework-compliance.md | M | Add world IPL module evaluation |
| docs/naming-map.md | M | Map bob74_ipl → ipl |
| docs/research-log.md | M | Log bob74_ipl research |
| docs/todo-gaps.md | M | Note OpenAPI world events gap |
| docs/run-docs.md | M | Consolidated run notes |
