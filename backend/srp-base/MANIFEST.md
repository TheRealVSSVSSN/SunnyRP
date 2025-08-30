# Manifest

- EMS vehicle spawn logging with realtime push and purge scheduler.
- Track recycling job deliveries with realtime push and cleanup scheduler.
- Update OpenAPI validator dependency for install success.
- Persist and broadcast vehicle control state with cleanup scheduler.
- Webhook dispatch for interior proxy updates.
- Dynamic minimap blip service with scheduler and WS broadcasts.
- Admin noclip toggle with audit log and realtime broadcast.
- Admin unban endpoints with ban status query and audit log.
- Base event filter and composite index for targeted analytics.
- Mechanic work orders backend with realtime push and scheduler.
- Player contract notifications via WebSocket/webhooks with expiry scheduler.

- Broadcast messages API with realtime push and purge scheduler.
- Allow photo description updates with realtime push.
- Command definitions API with realtime push.
- Crime school progress tracking with realtime push and retention scheduler.
- Dance animation definitions with realtime push and purge scheduler.

- Dealer offers backend with realtime push and purge scheduler.

| File | Action | Note |
|---|---|---|
| src/routes/broadcast.routes.js | R | Rename broadcaster to broadcast with message endpoints |
| src/repositories/broadcastRepository.js | A | Store and list broadcast messages |
| src/tasks/broadcast.js | A | Purge old broadcast messages |
| src/server.js | M | Register broadcast purge task |
| src/app.js | M | Mount broadcast routes |
| src/config/env.js | M | Add broadcast retention config |
| src/migrations/092_add_broadcast_messages.sql | A | Broadcast messages table |
| openapi/api.yaml | M | Document broadcast endpoints |
| docs/modules/broadcast.md | R | Document broadcast module |
| docs/index.md | M | Log broadcast update |
| docs/progress-ledger.md | M | Record np-broadcaster entry |
| docs/framework-compliance.md | M | Rename broadcast module compliance |
| docs/BASE_API_DOCUMENTATION.md | M | Add broadcast API mapping |
| docs/events-and-rpcs.md | M | Map broadcast events |
| docs/admin-ops.md | M | Broadcast operations note |
| docs/security.md | M | Update broadcast auth note |
| docs/testing.md | M | Broadcast endpoint tests |
| docs/research-log.md | M | Log broadcast research |
| docs/naming-map.md | M | Map np-broadcaster |
| docs/db-schema.md | M | Document broadcast_messages table |
| docs/migrations.md | M | List migration 092 |
| docs/run-docs.md | M | Summarize broadcast run |
| MANIFEST.md | M | Update manifest |
| CHANGELOG.md | M | Log broadcast feature |
| src/repositories/jobsRepository.js | M | Added on-duty roster query |
| src/routes/jobs.routes.js | M | Broadcast/dispatch `jobs.assigned` and `jobs.duty` |
| src/tasks/jobs.js | A | Scheduler broadcasting `jobs.roster` |
| src/server.js | M | Registered jobs roster sync task |
| openapi/api.yaml | M | Documented job webhook events |
| docs/modules/jobs.md | M | Added WS/webhook and scheduler notes |
| docs/BASE_API_DOCUMENTATION.md | M | Documented job events |
| docs/events-and-rpcs.md | M | Mapped `jobs.*` events |
| docs/framework-compliance.md | M | Updated jobs module compliance |
| docs/index.md | M | Logged jobs update |
| docs/naming-map.md | M | Added jobsystem mapping |
| docs/progress-ledger.md | M | Recorded jobs realtime entry |
| docs/research-log.md | M | Logged jobs research |
| docs/todo-gaps.md | M | Added job progression TODO |
| docs/run-docs.md | A | Consolidated doc summary for this run |
| src/repositories/baseEventsRepository.js | M | Optional event type filter |
| src/routes/baseEvents.routes.js | M | Added `eventType` query param |
| src/migrations/090_add_base_event_logs_type_index.sql | A | Index on `(event_type, created_at)` |
| docs/modules/baseevents.md | M | Documented filter and index |
| docs/db-schema.md | M | Noted base_event_logs index |
| docs/migrations.md | M | Logged 090_add_base_event_logs_type_index.sql |
| docs/progress-ledger.md | M | Recorded np-base extension |
| docs/index.md | M | Logged base event filter update |
| docs/research-log.md | M | Noted np-base research attempt |
| src/config/env.js | M | Added debug retention and cleanup interval |
| src/repositories/debugRepository.js | M | Added logs/markers persistence helpers |
| src/routes/debug.routes.js | M | Added /v1/debug/logs and /v1/debug/markers APIs |
| src/tasks/debug.js | A | Scheduler purge for markers/logs with WS/webhook emits |
| src/server.js | M | Registered debug maintenance task |
| src/migrations/080_add_debug.sql | A | Created debug_logs and debug_markers tables |
| openapi/api.yaml | M | Added DebugLog/Marker schemas and paths |
| docs/modules/debug.md | M | Expanded debug module docs |
| docs/db-schema.md | M | Documented debug tables |
| docs/migrations.md | M | Logged 080_add_debug.sql |
| src/repositories/k9Repository.js | M | Added `listActive` helper |
| src/routes/k9.routes.js | M | Active list route + events/webhooks |
| src/tasks/k9.js | A | Scheduler broadcasting active roster |
| src/server.js | M | Registered k9 broadcast task |
| openapi/api.yaml | M | Documented `GET /v1/k9s/active` |
| docs/modules/k9.md | M | Documented new endpoint/events |
| docs/BASE_API_DOCUMENTATION.md | M | Added K9 active roster notes |
| docs/events-and-rpcs.md | M | Mapped K9 events and route |
| docs/framework-compliance.md | M | Updated K9 module compliance |
| docs/index.md | M | Logged K9 update |
| docs/naming-map.md | M | Added k9 mapping |
| docs/progress-ledger.md | M | Recorded K9 realtime entry |
| docs/research-log.md | M | Logged k9 resource research |
| docs/todo-gaps.md | M | Added K9 handler assignment TODO |
| docs/run-docs.md | M | Consolidated documentation |
| package.json | M | Bump express-openapi-validator to ^5.5.8 |
| src/routes/recycling.routes.js | A | Delivery logging endpoints |
| src/repositories/recyclingRepository.js | A | Recycling data persistence |
| src/tasks/recycling.js | A | Purge old deliveries |
| src/config/env.js | M | Add recycling retention config |
| src/app.js | M | Mount recycling routes |
| src/server.js | M | Register recycling purge task |
| src/migrations/081_add_recycling_runs.sql | A | Table for recycling runs |
| docs/modules/recycling.md | A | Module documentation |
| docs/naming-map.md | M | Map lmfao → recycling |
| docs/events-and-rpcs.md | M | Map lmfao events to API |
| docs/progress-ledger.md | M | Record recycling entry |
| docs/index.md | M | Note recycling update |
| docs/research-log.md | M | Log recycling research |
| docs/run-docs.md | M | Summarize run |
| docs/framework-compliance.md | M | Add recycling compliance note |
| docs/BASE_API_DOCUMENTATION.md | M | Document recycling endpoints |
| docs/db-schema.md | M | Describe recycling_runs table |
| docs/migrations.md | M | List migration 081 |
| openapi/api.yaml | M | Define recycling schemas and paths |
| src/routes/vehicles.routes.js | M | Add control state endpoints |
| src/repositories/vehicleControlRepository.js | A | Persist vehicle control state |
| src/tasks/vehicleControl.js | A | Purge stale control records |
| src/config/env.js | M | Add vehicle control retention config |
| src/server.js | M | Register vehicle control cleanup task |
| src/migrations/082_add_vehicle_control_states.sql | A | Vehicle control states table |
| docs/modules/vehicles.md | M | Document control endpoints |
| docs/BASE_API_DOCUMENTATION.md | M | Add control API mapping |
| docs/db-schema.md | M | Describe vehicle_control_states table |
| docs/migrations.md | M | List migration 082 |
| docs/events-and-rpcs.md | M | Map lux_vehcontrol events |
| docs/naming-map.md | M | Map lux_vehcontrol to vehicle-control |
| docs/progress-ledger.md | M | Record vehicle control entry |
| docs/index.md | M | Note vehicle control update |
| docs/framework-compliance.md | M | Add vehicle control module note |
| docs/research-log.md | M | Log lux_vehcontrol research |
| docs/run-docs.md | M | Summarize vehicle control run |
| openapi/api.yaml | M | Define vehicle control schemas and paths |
| src/routes/world.routes.js | M | Dispatch webhooks for IPL set/remove |
| openapi/api.yaml | M | Document IPL webhook behaviour |
| docs/modules/world.md | M | Note `world.ipl.*` events |
| docs/events-and-rpcs.md | M | Map bob74_ipl to `world.ipl.updated` via webhooks |
| docs/index.md | M | Logged mapmanager update |
| docs/naming-map.md | M | Added mapmanager mapping |
| docs/progress-ledger.md | M | Recorded mapmanager entry |
| docs/research-log.md | M | Logged mapmanager research |
| docs/run-docs.md | M | Added mapmanager run summary |
| CHANGELOG.md | M | Document IPL webhook addition |
| src/repositories/emsVehiclesRepository.js | A | Log EMS vehicle spawns |
| src/tasks/emsVehicles.js | A | Purge old EMS vehicle spawns |
| src/config/env.js | M | Add emsVehicles retention config |
| src/migrations/083_add_ems_vehicle_spawns.sql | A | Table for EMS vehicle spawn logs |
| src/routes/ems.routes.js | M | Add vehicle spawn route |
| src/server.js | M | Register EMS vehicle purge task |
| openapi/api.yaml | M | Document EMS vehicle spawn endpoint |
| docs/modules/ems.md | M | Document spawn route and event |
| docs/index.md | M | Log EMS vehicles update |
| docs/progress-ledger.md | M | Add medicgarage entry |
| docs/framework-compliance.md | M | Note EMS vehicle spawn compliance |
| docs/BASE_API_DOCUMENTATION.md | M | Describe EMS vehicle spawn API |
| docs/events-and-rpcs.md | M | Map medicgarage events |
| docs/db-schema.md | M | Document ems_vehicle_spawns table |
| docs/migrations.md | M | List migration 083 |
| docs/admin-ops.md | M | Add ems_vehicle_spawns operational notes |
| docs/testing.md | M | Add EMS vehicle spawn test |
| docs/naming-map.md | M | Map medicgarage → ems-vehicles |
| docs/research-log.md | M | Log medicgarage research |
| docs/run-docs.md | M | Summarize medicgarage run |
| src/repositories/minimapRepository.js | A | Persist minimap blips |
| src/routes/minimap.routes.js | A | Minimap blip CRUD endpoints |
| src/tasks/minimap.js | A | Broadcast blip list over WebSocket |
| src/server.js | M | Register minimap broadcast task |
| src/app.js | M | Mount minimap routes |
| src/migrations/084_add_hacking_attempts.sql | R | Renumber migration |
| src/migrations/085_add_minimap_blips.sql | A | Create minimap_blips table |
| openapi/api.yaml | M | Document minimap endpoints |
| docs/modules/minimap.md | A | Module documentation |
| docs/BASE_API_DOCUMENTATION.md | M | Document minimap endpoints |
| docs/events-and-rpcs.md | M | Map minimap events |
| docs/db-schema.md | M | Document minimap_blips table |
| docs/migrations.md | M | List migrations 084 and 085 |
| docs/admin-ops.md | M | Operational notes for minimap_blips |
| docs/security.md | M | Minimap auth notes |
| docs/testing.md | M | Minimap endpoint tests |
| docs/index.md | M | Log minimap update |
| docs/progress-ledger.md | M | Record minimap entry |
| docs/naming-map.md | M | Map minimap → minimap |
| docs/research-log.md | M | Log minimap research |
| docs/run-docs.md | M | Summarize minimap run |
| src/repositories/adminRepository.js | M | Add noclip logging helper |
| src/routes/admin.routes.js | M | Add `/v1/admin/noclip` endpoint |
| src/migrations/086_add_noclip_events.sql | A | Noclip audit table |
| openapi/api.yaml | M | Document noclip endpoint |
| docs/modules/admin.md | M | Document ban and noclip APIs |
| docs/index.md | M | Log noclip update |
| docs/progress-ledger.md | M | Record noclip entry |
| docs/naming-map.md | M | Map noclip events |
| docs/events-and-rpcs.md | M | Map noclip resource |
| docs/db-schema.md | M | Describe `noclip_events` table |
| docs/migrations.md | M | List migration 086 |
| docs/admin-ops.md | M | Add noclip operational note |
| docs/security.md | M | Note scope check for noclip |
| docs/framework-compliance.md | M | Add admin module compliance |
| docs/BASE_API_DOCUMENTATION.md | M | Document noclip API |
| docs/research-log.md | M | Log noclip research |
| docs/run-docs.md | M | Summarize noclip run |
| src/repositories/adminRepository.js | M | Unban and ban status helpers |
| src/routes/admin.routes.js | M | Unban/ban status endpoints & WS broadcasts |
| src/migrations/088_add_unban_events.sql | A | Unban audit table |
| openapi/api.yaml | M | Document unban and ban status endpoints |
| docs/modules/admin.md | M | Describe unban features |
| docs/BASE_API_DOCUMENTATION.md | M | Document admin unban API |
| docs/events-and-rpcs.md | M | Map admin ban events |
| docs/naming-map.md | M | Map np-admin unban & status |
| docs/admin-ops.md | M | Add unban audit note |
| docs/db-schema.md | M | Document bans and unban_events tables |
| docs/migrations.md | M | Log migration 088 |
| docs/index.md | M | Add admin unban update |
| docs/progress-ledger.md | M | Record admin unban entry |
| docs/research-log.md | M | Log np-admin research |
| docs/framework-compliance.md | M | Update admin module compliance |
| docs/run-docs.md | M | Summarize admin unban run |
| CHANGELOG.md | M | Log admin unban features |
| src/repositories/mechanicRepository.js | A | Persist mechanic work orders |
| src/routes/mechanic.routes.js | A | Mechanic order endpoints |
| src/tasks/mechanic.js | A | Scheduler to complete orders |
| src/server.js | M | Register mechanic task |
| src/app.js | M | Mount mechanic routes |
| src/migrations/091_add_mechanic_orders.sql | A | Mechanic orders table |
| openapi/api.yaml | M | Document mechanic endpoints |
| docs/modules/mechanic.md | A | Module documentation |
| docs/index.md | M | Note mechanic update |
| docs/progress-ledger.md | M | Record mechanic entry |
| docs/framework-compliance.md | M | Rename repository reference |
| docs/BASE_API_DOCUMENTATION.md | M | Document mechanic API |
| docs/events-and-rpcs.md | M | Map np-bennys events |
| docs/db-schema.md | M | Document mechanic_orders table |
| docs/migrations.md | M | List migration 091 |
| docs/admin-ops.md | M | Operational note for mechanic orders |
| docs/research-log.md | M | Log np-bennys research |
| docs/naming-map.md | M | Map np-bennys → mechanic |
| docs/run-docs.md | M | Summarize mechanic run |
| CHANGELOG.md | M | Log mechanic module |
| MANIFEST.md | M | Update manifest |
| src/repositories/cameraRepository.js | M | Update photo metadata |
| src/routes/camera.routes.js | M | Add PATCH endpoint |
| openapi/api.yaml | M | Document photo update |
| docs/modules/camera.md | M | Document photo update |
| docs/index.md | M | Log camera metadata update |
| docs/progress-ledger.md | M | Record camera extension |
| docs/BASE_API_DOCUMENTATION.md | M | Add camera PATCH endpoint |
| docs/events-and-rpcs.md | M | Map photo.updated event |
| docs/naming-map.md | M | Map camera:Activate2 |
| docs/research-log.md | M | Log np-camera research |
| docs/run-docs.md | M | Summarize camera run |
| MANIFEST.md | M | Update manifest |
| CHANGELOG.md | M | Record camera metadata update |
| src/routes/commands.routes.js | A | Command definition routes |
| src/repositories/commandsRepository.js | A | Command persistence |
| src/migrations/093_add_commands.sql | A | Command definitions table |
| docs/modules/commands.md | A | Document commands module |
| docs/index.md | M | Log commands update |
| docs/progress-ledger.md | M | Record np-commands entry |
| docs/framework-compliance.md | M | Add commands module compliance |
| docs/events-and-rpcs.md | M | Map np-commands resource |
| docs/admin-ops.md | M | Add commands table note |
| docs/naming-map.md | M | Map np-commands |
| docs/research-log.md | M | Log np-commands research |
| docs/db-schema.md | M | Document commands table |
| docs/migrations.md | M | List migration 093 |
| docs/run-docs.md | M | Summarize commands run |
| openapi/api.yaml | M | Document command endpoints |
| docs/BASE_API_DOCUMENTATION.md | M | Document commands API |
| src/repositories/contractsRepository.js | M | Add purgeExpired helper |
| src/tasks/contracts.js | A | Purge expired contracts task |
| src/config/env.js | M | Add contract retention config |
| src/server.js | M | Register contracts purge task |
| src/routes/contracts.routes.js | M | Broadcast contract events |
| src/migrations/094_add_contracts_created_index.sql | A | Index on contracts.created_at |
| docs/modules/contracts.md | M | Document realtime and scheduler |
| docs/index.md | M | Log contracts update |
| docs/progress-ledger.md | M | Record np-contracts entry |
| docs/framework-compliance.md | M | Add contracts module compliance |
| docs/BASE_API_DOCUMENTATION.md | M | Document contract endpoints |
| docs/events-and-rpcs.md | M | Map np-contracts events |
| docs/db-schema.md | M | Document contracts table |
| docs/migrations.md | M | List migration 094 |
| docs/admin-ops.md | M | Note contract retention config |
| docs/security.md | M | Note contract route auth |
| docs/testing.md | M | Add contract tests |
| docs/naming-map.md | M | Map np-contracts |
| docs/research-log.md | M | Log np-contracts research |
| docs/run-docs.md | M | Summarize contracts run |
| CHANGELOG.md | M | Log contract realtime/purge |
| MANIFEST.md | M | Update manifest |
| src/repositories/crimeSchoolRepository.js | M | Character-scoped progress persistence |
| src/routes/crimeSchool.routes.js | A | Crime school progress endpoints |
| src/tasks/crimeSchool.js | A | Purge expired progress entries |
| src/config/env.js | M | Crime school retention settings |
| src/server.js | M | Register crime school purge task |
| src/migrations/095_update_crime_school_character_fk.sql | A | Rename column and add FK/index |
| openapi/api.yaml | M | Document crime school endpoints |
| docs/modules/crime-school.md | A | Document crime school module |
| docs/index.md | M | Log crime school update |
| docs/progress-ledger.md | M | Record np-crimeschool entry |
| docs/framework-compliance.md | M | Add crime school compliance note |
| docs/BASE_API_DOCUMENTATION.md | M | Document crime school API |
| docs/events-and-rpcs.md | M | Map np-crimeschool events |
| docs/db-schema.md | M | Describe crime_school table |
| docs/migrations.md | M | List migration 095 |
| docs/admin-ops.md | M | Add crime school operational note |
| docs/security.md | M | Crime school auth note |
| docs/testing.md | M | Crime school endpoint tests |
| docs/naming-map.md | M | Map np-crimeschool |
| docs/research-log.md | M | Log np-crimeschool research |
| docs/run-docs.md | M | Summarize crimeschool run |
| docs/todo-gaps.md | M | Add crime school TODO |
| src/repositories/dealersRepository.js | A | Persist dealer offers |
| src/routes/dealers.routes.js | A | Dealer offer endpoints |
| src/tasks/dealers.js | A | Purge expired dealer offers |
| src/server.js | M | Register dealer purge task |
| src/app.js | M | Mount dealer routes |
| src/migrations/096_add_dealer_offers.sql | A | Dealer offers table |
| openapi/api.yaml | M | Document dealer offer paths |
| docs/modules/dealers.md | A | Dealer module doc |
| docs/index.md | M | Log np-dealer update |
| docs/progress-ledger.md | M | Record np-dealer entry |
| docs/naming-map.md | M | Map np-dealer |
| docs/events-and-rpcs.md | M | Map dealer events |
| docs/db-schema.md | M | Document dealer_offers table |
| docs/migrations.md | M | List migration 096 |
| docs/admin-ops.md | M | Add dealer-offer operational note |
| docs/testing.md | M | Dealer offer tests |
| docs/framework-compliance.md | M | Add dealer outstanding item |
| docs/BASE_API_DOCUMENTATION.md | M | Document dealer endpoints |
| docs/research-log.md | M | Log np-dealer research |
| docs/run-docs.md | M | Summarize np-dealer run |
| docs/todo-gaps.md | M | Add dealer purchase TODO |
| CHANGELOG.md | M | Log dealer offer feature |
| MANIFEST.md | M | Update manifest |
| src/routes/dances.routes.js | A | Manage dance animations |
| src/repositories/dancesRepository.js | A | Persist dance animations |
| src/tasks/dances.js | A | Purge disabled animations |
| src/config/env.js | M | Add dances retention config |
| src/server.js | M | Register dances purge task |
| src/app.js | M | Mount dances routes |
| src/migrations/096_add_dance_animations.sql | A | Dance animations table |
| openapi/api.yaml | M | Document dance animation endpoints |
| docs/modules/dances.md | A | Module documentation |
| docs/index.md | M | Note dances update |
| docs/progress-ledger.md | M | Record np-dances entry |
| docs/framework-compliance.md | M | Add dances module compliance |
| docs/BASE_API_DOCUMENTATION.md | M | Document dances API |
| docs/events-and-rpcs.md | M | Map np-dances events |
| docs/db-schema.md | M | Describe dance_animations table |
| docs/migrations.md | M | List migration 096 |
| docs/admin-ops.md | M | Add dance animations operational note |
| docs/security.md | M | Include dances route auth |
| docs/testing.md | M | Dances endpoint tests |
| docs/research-log.md | M | Log np-dances research |
| docs/run-docs.md | M | Summarize dances run |
| docs/naming-map.md | M | Map np-dances |
| MANIFEST.md | M | Update manifest |
| CHANGELOG.md | M | Log dances module |