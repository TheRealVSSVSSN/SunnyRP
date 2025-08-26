# Manifest

- Added chat message WebSocket/webhook broadcasts and retention purge.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Add CHAT_RETENTION_MS setting |
| src/repositories/chatRepository.js | M | Add deletion helper |
| src/tasks/chat.js | A | Purge old messages |
| src/routes/chat.routes.js | M | Broadcast and dispatch chat messages |
| src/server.js | M | Register chat-purge scheduler |
| src/migrations/072_add_chat_messages_created_index.sql | A | Index chat_messages.created_at |
| openapi/api.yaml | M | Document chat message broadcast |
| docs/admin-ops.md | M | Mention chat retention and scheduler |
| docs/db-schema.md | M | Document chat_message indexes |
| docs/events-and-rpcs.md | M | Map chat.message event |
| docs/modules/chat.md | M | Describe realtime and purge |
| docs/migrations.md | M | Log migration 072 |
| docs/framework-compliance.md | M | Update chat compliance |
| docs/progress-ledger.md | M | Record chat realtime entry |
| docs/naming-map.md | M | Map chat → chat |
| docs/research-log.md | M | Log chat research |
| docs/run-docs.md | M | Consolidated run notes |
| CHANGELOG.md | M | Chat realtime & retention entry |
| MANIFEST.md | M | Update manifest |
