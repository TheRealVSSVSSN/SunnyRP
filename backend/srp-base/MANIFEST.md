# Manifest

- Added EMS realtime shift & record events with scheduler.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | EMS broadcast and shift duration config |
| src/routes/ems.routes.js | M | Emit WebSocket/webhook events |
| src/tasks/ems.js | A | Scheduled shift sync and broadcasts |
| src/server.js | M | Registered `ems-shift-sync` scheduler |
| docs/modules/ems.md | M | Documented realtime events and scheduler |
| docs/events-and-rpcs.md | M | Mapped EMS events |
| docs/naming-map.md | M | Added emspack→ems mapping |
| docs/progress-ledger.md | M | Logged EMS realtime entry |
| docs/index.md | M | Added EMS update |
| docs/research-log.md | M | Logged EMS research |
| docs/run-docs.md | M | Summarized EMS changes |

**Startup Notes:** install dependencies with `npm install` (fails: express-openapi-validator@^4.18.3 not found).
