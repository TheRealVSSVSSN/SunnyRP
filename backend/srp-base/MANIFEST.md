# Manifest

- Added import package expiry with WebSocket and webhook notifications.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Added import pack expiry configuration |
| src/repositories/importPackRepository.js | M | Added expiresAt handling and expiry helper |
| src/routes/importPack.routes.js | M | Broadcast order lifecycle events |
| src/tasks/importPack.js | A | Scheduler to expire pending orders |
| src/server.js | M | Registered import-pack expiry scheduler |
| src/migrations/078_add_import_pack_expiry.sql | A | Add expires_at/expired_at columns and index |
| openapi/api.yaml | M | Documented expiry fields and event descriptions |
| docs/modules/import-pack.md | M | Documented realtime events and expiry |
| docs/BASE_API_DOCUMENTATION.md | M | Added import pack endpoint summary |
| docs/events-and-rpcs.md | M | Mapped import-pack events |
| docs/db-schema.md | M | Added expires_at/expired_at columns |
| docs/migrations.md | M | Logged import pack expiry migration |
| docs/admin-ops.md | M | Added import pack expiry operations |
| docs/index.md | M | Added import pack update summary |
| docs/progress-ledger.md | M | Logged import pack expiry entry |
| docs/framework-compliance.md | M | Noted import pack module compliance |
| docs/naming-map.md | M | Added import-Pack mappings |
| docs/research-log.md | M | Logged import pack expiry research |
| docs/testing.md | M | Added import pack expiry test notes |
| docs/todo-gaps.md | M | Added gap for editing import pack orders |
| docs/run-docs.md | M | Run summary and outstanding tasks |
