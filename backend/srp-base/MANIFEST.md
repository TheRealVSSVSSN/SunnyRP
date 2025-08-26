# Manifest

- Added connect queue priority WebSocket/webhook notifications and expiry purge.

| File | Action | Note |
|---|---|---|
| src/repositories/connectqueueRepository.js | M | Add purgeExpired helper |
| src/tasks/connectqueue.js | A | Purge expired priorities and broadcast |
| src/routes/connectqueue.routes.js | M | Broadcast and dispatch priority updates |
| src/server.js | M | Register connectqueue-expiry scheduler |
| docs/modules/connectqueue.md | M | Document realtime and scheduler |
| docs/events-and-rpcs.md | M | Map connectqueue priority events |
| docs/progress-ledger.md | M | Record connectqueue realtime entry |
| docs/admin-ops.md | M | Mention scheduler and webhooks |
| docs/BASE_API_DOCUMENTATION.md | M | Note events and scheduler |
| docs/framework-compliance.md | M | Update connectqueue compliance |
| docs/index.md | M | Note connectqueue update |
| docs/naming-map.md | M | Map connectqueue |
| docs/run-docs.md | M | Summary of run |
| docs/research-log.md | M | Log connectqueue research |
| docs/todo-gaps.md | M | Add queue priority admin TODO |
| CHANGELOG.md | M | Connect queue realtime & expiry entry |
| MANIFEST.md | M | Update manifest |
