# Manifest

- Renamed coordsaver module to coordinates with WebSocket/webhook events and daily purge scheduler.

| File | Action | Note |
|---|---|---|
| src/routes/coordsaver.routes.js | R -> src/routes/coordinates.routes.js | Renamed and added broadcasts + alias paths |
| src/repositories/coordsaverRepository.js | R -> src/repositories/coordinatesRepository.js | Added purgeOldCoords |
| src/tasks/coordinates.js | A | Daily purge task |
| src/app.js | M | Import renamed routes |
| src/server.js | M | Register coordinates-purge scheduler |
| openapi/api.yaml | M | Rename paths to /coordinates; add deprecated /coords |
| docs/modules/coordinates.md | R | Updated module docs |
| docs/progress-ledger.md | M | Record rename and realtime |
| docs/index.md | M | Note coordinates update |
| docs/framework-compliance.md | M | Update compliance table |
| docs/BASE_API_DOCUMENTATION.md | M | Rename API map |
| docs/events-and-rpcs.md | M | Document realtime events |
| docs/naming-map.md | M | Map coordsaver → coordinates |
| docs/admin-ops.md | M | Note purge scheduler |
| docs/testing.md | M | Update manual test commands |
| docs/research-log.md | M | Log coordinates research |
| docs/migrations.md | M | Clarify coordinate migration |
| docs/run-docs.md | M | Consolidated run summary |
| CHANGELOG.md | M | Add coordinates rename entry |
| MANIFEST.md | M | Update manifest |
