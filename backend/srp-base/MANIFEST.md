# Manifest

- Boatshop module gains realtime WebSocket/webhook events and scheduled catalog broadcasts.
- Express middleware reordered with global rate limiting.
- Removed legacy duplicate `app.js` and `server.js` at repository root.

| File | Action | Note |
|---|---|---|
| src/app.js | M | Order middleware and add global rate limiter |
| src/routes/boatshop.routes.js | M | Broadcast purchase events |
| src/tasks/boatshop.js | A | Scheduler to push catalog |
| src/server.js | M | Register boatshop scheduler |
| openapi/api.yaml | M | Document boatshop realtime behaviour |
| docs/modules/boatshop.md | M | Note scheduler and events |
| docs/events-and-rpcs.md | M | Map boatshop events |
| docs/BASE_API_DOCUMENTATION.md | M | Describe boatshop pushes |
| docs/testing.md | M | Add WebSocket verification step |
| docs/admin-ops.md | M | Mention catalog scheduler |
| docs/progress-ledger.md | M | Log boatshop realtime extension |
| docs/index.md | M | Update run summary |
| docs/naming-map.md | M | Map boatshop name |
| docs/research-log.md | M | Record boatshop research |
| docs/run-docs.md | A | Consolidated run notes |
| app.js | D | Remove duplicate root file |
| server.js | D | Remove duplicate root file |
