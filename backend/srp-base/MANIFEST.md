# Manifest

- Added jailbreak expiry scheduler with WebSocket and webhook notifications.

| File | Action | Note |
|---|---|---|
| src/repositories/jailbreakRepository.js | M | Added expireStale query |
| src/tasks/jailbreak.js | A | Scheduler to fail stale attempts with broadcasts |
| src/server.js | M | Registered jailbreak-expire job |
| src/config/env.js | M | Added jailbreak maxActiveMs config |
| src/routes/jailbreak.routes.js | M | Broadcast and dispatch jailbreak events |
| openapi/api.yaml | M | Documented websocket/webhook events for jailbreak |
| src/migrations/079_add_jailbreak_started_index.sql | A | Index on started_at |
| docs/modules/jailbreak.md | M | Documented realtime events and scheduler |
| docs/admin-ops.md | M | Added jailbreak index and scheduler note |
| docs/events-and-rpcs.md | M | Mapped jailbreak events |
| docs/db-schema.md | M | Recorded jailbreak index |
| docs/migrations.md | M | Listed migration 079 |
| docs/index.md | M | Logged jailbreak update |
| docs/progress-ledger.md | M | Recorded jailbreak realtime entry |
| docs/framework-compliance.md | M | Updated jailbreak compliance notes |
| docs/BASE_API_DOCUMENTATION.md | M | Added jailbreak expiry description |
| docs/naming-map.md | M | Added np-jailbreak mapping |
| docs/research-log.md | M | Logged jailbreak research |
| docs/run-docs.md | M | Consolidated documentation for this run |
| docs/testing.md | M | Added jailbreak verification steps |
