# Manifest

- Broadcast timecycle overrides and auto-expire expired presets.

| File | Action | Note |
|---|---|---|
| src/routes/world.routes.js | M | Emit timecycle set/clear events |
| src/tasks/timecycle.js | A | Scheduler clearing expired overrides |
| src/server.js | M | Register timecycle-expiry task |
| docs/naming-map.md | M | Map koillove → climate-overrides |
| docs/events-and-rpcs.md | M | Document world.timecycle.* events |
| docs/modules/world.md | M | Add realtime and scheduler notes |
| docs/index.md | M | Log climate-overrides update |
| docs/progress-ledger.md | M | Record climate-overrides realtime entry |
| docs/framework-compliance.md | M | Noted timecycle realtime compliance |
| docs/research-log.md | M | Added koillove reference |
| docs/run-docs.md | M | Run summary |
| CHANGELOG.md | M | Added climate-overrides entry |
