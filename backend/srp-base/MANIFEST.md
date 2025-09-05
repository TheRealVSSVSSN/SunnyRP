# Manifest

## Summary
- Implemented session lifecycle with login password, CID assignment, and hospitalization flows.
- Added world zone and barrier management.
- Introduced UX module for chat, voting, taskbar progress, and broadcast messaging.
- Extended telemetry with RCON logging, remote code execution, restart scheduling, and debug hooks.
- Introduced jobs module with primary and secondary job management.
- Added weather synchronization module with persistent state and real-time broadcast.
- Added sessions whitelist and hardcap management with persistence, REST routes, WebSocket events, and tests.
- Added coordinate saving, spawn logging, population metrics, broadcaster role management, and expanded notification endpoints.
- Added infinity entity streaming with REST endpoints and scheduler purge, and enforced broadcast participation limits.

- Refactored WebSocket gateway with per-domain namespaces, handshake validation, and broadcast rate limiting.

## Files
| Path | Type | Notes |
|------|------|-------|
| docs/index.md | M | summarize new modules |
| src/repositories/sessions.js | M | add login, CID, hospital functions |
| src/routes/sessions.js | M | add login, CID, hospital endpoints |
| src/migrations/0016_session_lifecycle.sql | A | session password, cids, hospitalizations |
| src/repositories/world.js | M | add zone and barrier persistence |
| src/routes/world.js | M | zone and barrier REST API |
| src/migrations/0017_world_zones.sql | A | world_zones and world_barriers tables |
| src/repositories/ux.js | A | chat and voting persistence |
| src/routes/ux.js | A | chat, voting, taskbar, broadcast API |
| src/migrations/0018_ux.sql | A | chat_messages and votes tables |
| src/repositories/telemetry.js | M | rcon, exec, restart, debug persistence |
| src/routes/telemetry.js | M | rcon, exec, restart, debug endpoints |
| src/migrations/0019_telemetry_extended.sql | A | rcon_logs, exec_logs, restart_schedule, debug_logs |
| src/bootstrap/scheduler.js | M | restart scheduler task |
| src/app.js | M | register ux router |
| docs/BASE_API_DOCUMENTATION.md | M | document new endpoints |
| docs/events-and-rpcs.md | M | add new events |
| docs/framework-compliance.md | M | note sessions lifecycle, world zones, ux, telemetry extensions |
| docs/gap-closure-report.md | M | mark gaps closed |
| docs/todo-gaps.md | M | remove outstanding gaps |
| docs/run-docs.md | M | record implementation |
| docs/progress-ledger.md | M | log work |
| docs/db-schema.md | M | document new tables |
| docs/migrations.md | M | list new migrations |
| docs/naming-map.md | M | map new terms |
| test/sessions-cid.test.js | A | require auth for CID endpoint |
| test/world-zones.test.js | A | require auth for world zones |
| test/ux-chat.test.js | A | require auth for chat endpoint |
| test/telemetry-rcon.test.js | A | require auth for rcon endpoint |
| docs/index.md | M | note outstanding modules |
| src/repositories/jobs.js | A | character job persistence |
| src/routes/jobs.js | A | job assignment REST API |
| src/repositories/world.js | A | weather state persistence |
| src/routes/world.js | A | weather REST API |
| src/migrations/0014_jobs.sql | A | jobs and character_jobs tables |
| src/migrations/0015_weather.sql | A | weather_state table |
| docs/BASE_API_DOCUMENTATION.md | M | document sessions, jobs, and weather endpoints |
| docs/events-and-rpcs.md | M | add sessions, jobs, and weather events |
| docs/framework-compliance.md | M | note whitelist, jobs, and weather support |
| docs/gap-closure-report.md | M | mark jobs and weather gaps closed |
| docs/todo-gaps.md | M | remove jobs and weather gaps |
| docs/run-docs.md | M | record jobs and weather implementation |
| docs/index.md | M | summarize jobs and weather modules |
| docs/progress-ledger.md | M | log jobs and weather work |
| docs/naming-map.md | M | map whitelist, jobs, and weather terms |
| docs/db-schema.md | M | add job and weather tables |
| docs/migrations.md | M | add jobs and weather migrations |
| test/jobs.test.js | A | require auth for jobs endpoints |
| test/world.test.js | A | require auth for weather endpoints |
| src/repositories/sessions.js | A | whitelist and hardcap persistence |
| src/routes/sessions.js | A | whitelist and hardcap REST API |
| src/migrations/0013_sessions.sql | A | users_whitelist and session_limits tables |
| docs/BASE_API_DOCUMENTATION.md | M | document sessions endpoints |
| docs/events-and-rpcs.md | M | add sessions events |
| docs/framework-compliance.md | M | note whitelist and hardcap support |
| docs/gap-closure-report.md | M | mark sessions gap closed |
| docs/todo-gaps.md | M | remove whitelist gap |
| docs/run-docs.md | M | record sessions implementation |
| docs/index.md | M | summarize sessions module |
| docs/progress-ledger.md | M | log sessions work |
| docs/research-summary.md | A | summarize whitelist/hardcap findings |
| docs/research-log.md | M | log whitelist and hardcap files |
| docs/coverage-map.md | M | refresh resource scan counts |
| docs/naming-map.md | M | map whitelist and hardcap terms |
| docs/db-schema.md | M | add whitelist and hardcap tables |
| docs/migrations.md | M | add sessions migration |
| test/sessions.test.js | A | require auth for sessions endpoints |
| src/repositories/world.js | M | add coordinate persistence |
| src/repositories/sessions.js | M | spawn logging |
| src/repositories/scoreboard.js | M | population counting |
| src/repositories/voice.js | M | broadcast state |
| src/routes/world.js | M | coordinate endpoints |
| src/routes/sessions.js | M | spawn and population endpoints |
| src/routes/voice.js | M | broadcast endpoints |
| src/routes/ux.js | M | notification and meter endpoints |
| src/migrations/0020_world_coords_voice_broadcast.sql | A | coordinate, spawn, broadcast tables |
| docs/BASE_API_DOCUMENTATION.md | M | document new endpoints |
| docs/events-and-rpcs.md | M | document new events |
| docs/framework-compliance.md | M | note coordinate, spawn, broadcast, notifications |
| docs/gap-closure-report.md | M | record closed gaps |
| docs/run-docs.md | M | record coordinate and notification work |
| docs/research-summary.md | M | add broadcaster and coord notes |
| docs/research-log.md | M | log broadcaster and notify resources |
| docs/naming-map.md | M | map coordsaver, spawnmanager, taskbar variants, pNotify |
| docs/coverage-map.md | M | update broadcaster mapping |
| docs/db-schema.md | M | add coordinate, spawn, broadcast tables |
| docs/migrations.md | M | add new migration |
| docs/testing.md | M | note new tests |
| docs/index.md | M | summarize new modules |
| docs/progress-ledger.md | M | log coordinate and notification work |

## Startup/Env
- Requires `JWT_SECRET`, `SRP_HMAC_SECRET`, and MySQL connection settings.
| src/repositories/world.js | M | add infinity entity persistence |
| src/repositories/voice.js | M | broadcast list and limit |
| src/routes/world.js | M | infinity entity endpoints |
| src/routes/voice.js | M | broadcast list and limit |
| src/server.js | M | purge infinity entities |
| src/migrations/0021_infinity_entities.sql | A | infinity entity table |
| test/voice.test.js | M | require auth for broadcast list |
| test/world.test.js | M | require auth for infinity entity endpoint |
| docs/BASE_API_DOCUMENTATION.md | M | add broadcast list and infinity endpoints |
| docs/events-and-rpcs.md | M | add infinity entity event |
| docs/framework-compliance.md | M | note broadcast limit and infinity purge |
| docs/research-summary.md | M | update infinity and broadcaster notes |
| docs/research-log.md | M | record infinity and broadcaster files |
| docs/naming-map.md | M | map infinity and broadcast |
| docs/coverage-map.md | M | note broadcast limit and entity streaming |
| docs/gap-closure-report.md | M | record infinity and broadcast limit gaps closed |
| docs/run-docs.md | M | note broadcast limit and infinity entity work |
| docs/index.md | M | mention broadcast limit and infinity streaming |
| docs/progress-ledger.md | M | log broadcast limit and infinity streaming |
| docs/db-schema.md | M | add infinity_entities table |
| docs/migrations.md | M | add infinity_entities migration |
| docs/modules/voice.md | M | document broadcast endpoints |
| docs/modules/world.md | A | world module doc |
| README.md | A | service overview |
| src/repositories/characters.js | M | validate character ownership |
| src/websockets/gateway.js | M | domain namespaces, validation, rate limiting |
| src/server.js | M | mount domain namespaces |
| docs/events-and-rpcs.md | M | document namespace paths |
| docs/index.md | M | note gateway refactor |
| docs/run-docs.md | M | log gateway refactor |
| docs/framework-compliance.md | M | note handshake validation and namespaces |
| docs/naming-map.md | M | map socket namespace term |
| docs/coverage-map.md | M | mention namespace change |
| docs/gap-closure-report.md | M | mark gateway gap closed |
| docs/progress-ledger.md | M | record gateway work |
| docs/testing.md | M | note gateway tests |
