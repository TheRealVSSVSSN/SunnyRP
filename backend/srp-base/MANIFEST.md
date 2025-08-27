# Manifest

- Added emotes realtime sync with WebSocket/webhook events and retention purge.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Added `EMOTE_RETENTION_MS` setting |
| src/repositories/emotesRepository.js | M | Purge helper returning expired favorites |
| src/routes/emotes.routes.js | M | Broadcast/dispatch favorite add/remove |
| src/tasks/emotes.js | A | Hourly purge broadcasts `favoriteExpired` |
| src/server.js | M | Registered `emotes-purge` scheduler |
| openapi/api.yaml | M | Documented realtime events and retention purge |
| docs/modules/emotes.md | M | Added scheduler and event notes |
| docs/index.md | M | Logged emotes realtime update |
| docs/progress-ledger.md | M | Recorded emotes realtime entry |
| docs/framework-compliance.md | M | Updated compliance and outstanding items |
| docs/events-and-rpcs.md | M | Listed emote event mappings |
| docs/BASE_API_DOCUMENTATION.md | M | Noted emote push events |
| docs/admin-ops.md | M | Documented `emotes-purge` scheduler |
| docs/naming-map.md | M | Added emotes mapping |
| docs/research-log.md | M | Logged emotes research attempt |
| docs/run-docs.md | M | Consolidated run summary |
| docs/todo-gaps.md | M | Added emotes TODO items |
| CHANGELOG.md | M | Added emotes realtime entry |

**Startup Notes:** install dependencies with `npm install` (fails: express-openapi-validator@^4.18.3 not found).
