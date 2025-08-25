# Manifest – Sprint 2025‑08‑19

This manifest summarises the files added or modified in this sprint
for the `srp‑base` Node.js service.  Only files that changed are
listed here.  Files not mentioned were left untouched.

| Path | Status | Notes |
|---|---|---|
| `src/repositories/jobsRepository.js` | M | Added `countPlayersForJob` and `getJobByName` helpers to support the broadcaster module. |
| `src/routes/broadcaster.routes.js` | A | New route for assigning the broadcaster job while enforcing a maximum number of concurrent broadcasters. |
| `src/app.js` | M | Mounted the new broadcaster route. |
| `DOCS/progress-ledger.md` | A | Progress log for processed legacy resources and decisions. |
| `DOCS/index.md` | A | Sprint overview summarising tasks and outcomes. |
| `DOCS/modules/broadcaster.md` | A | Per‑module documentation describing the broadcaster API. |
| `DOCS/framework-compliance.md` | A | Added framework compliance rubric and evaluation for the Node.js service. |
| `DOCS/progress-ledger.md` | M | Added entries for `np‑errorlog`, `LockDoors` and `np‑density`. |
| `DOCS/index.md` | M | Added sprint 2025‑08‑19 overview and summary. |

Legend: **A** = Added, **M** = Modified.

# Updates for 2025-08-24 (PolyZone)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/zonesRepository.js` | A | Repository for zone definitions. |
| `src/routes/zones.routes.js` | A | REST endpoints for zones. |
| `src/migrations/025_add_zones.sql` | A | Create zones table. |
| `src/app.js` | M | Mounted zones routes. |
| `openapi/api.yaml` | M | Added Zone schemas and `/v1/zones` paths. |
| `docs/index.md` | M | Logged PolyZone update. |
| `docs/progress-ledger.md` | M | Added PolyZone entry. |
| `docs/framework-compliance.md` | M | Noted zones module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented zones endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped PolyZone events. |
| `docs/db-schema.md` | M | Documented zones table. |
| `docs/migrations.md` | M | Listed migration 025. |
| `docs/admin-ops.md` | M | Zones table check. |
| `docs/security.md` | M | Zones security note. |
| `docs/testing.md` | M | Added zones curl examples. |
| `docs/modules/zones.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged PolyZone research. |
| `CHANGELOG.md` | M | Added PolyZone entry. |

Legend: **A** = Added, **M** = Modified.

# Additional updates for the second part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `DOCS/progress-ledger.md` | M | Added entries for koilWeatherSync, mapmanager, chat, cron, minimap, np‑admin, np‑barriers and deferred np‑base. |
| `DOCS/index.md` | M | Added second part of the sprint overview summarising additional skip decisions. |

# Additional updates for the third part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/contractsRepository.js` | A | New repository for persisting and retrieving player contracts. |
| `src/routes/contracts.routes.js` | A | New route exposing `/v1/contracts` CRUD operations (list, create, accept, decline). |
| `src/migrations/008_add_contracts.sql` | A | Migration creating the `contracts` table with sender_id, receiver_id, amount, info, status and timestamps. |
| `src/app.js` | M | Mounted the contracts router alongside existing domain routes. |
| `openapi/api.yaml` | M | Added a `Contract` schema and paths for `/v1/contracts` and its subresources. |
| `DOCS/progress-ledger.md` | M | Added entries for np‑camera, np‑cid, np‑contracts, np‑dances, np‑dealer and np‑dirtymoney. |
| `DOCS/index.md` | M | Added third part of sprint overview summarising contracts implementation and additional skip decisions. |

# Additional updates for the fourth part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/drivingTestsRepository.js` | A | New repository for creating and retrieving driving test records.
| `src/routes/drivingTests.routes.js` | A | New routes exposing `/v1/driving-tests` (list & create) and `/v1/driving-tests/{id}` (retrieve) endpoints.
| `src/routes/driftschool.routes.js` | A | New route to handle drift school payments via `/v1/driftschool/pay`.
| `src/migrations/009_add_driving_tests.sql` | A | Migration creating the `driving_tests` table with appropriate indexes and columns.
| `src/app.js` | M | Mounted the driving tests and drift school routers.
| `openapi/api.yaml` | M | Added `DrivingTest` and `DriftSchoolPayment` schemas and new paths for driving tests and drift school payment.
| `DOCS/progress-ledger.md` | M | Added entries for `np-driftschool`, `np-driving-instructor` and `np-drugdeliveries`.
| `DOCS/index.md` | M | Added fourth part of sprint overview detailing driving tests and drift school features.

# Additional updates for the sixth part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/websitesRepository.js` | A | New repository for creating and listing player websites, supporting the Gurgle phone app. |
| `src/routes/websites.routes.js` | A | New routes exposing `/v1/websites` (GET and POST) for listing and creating websites. |
| `src/migrations/011_add_websites.sql` | A | Migration creating the `websites` table with owner, name, keywords, description and timestamps. |
| `src/app.js` | M | Mounted the new websites routes. |
| `openapi/api.yaml` | M | Added `Website` and `WebsiteCreateRequest` schemas and a `/v1/websites` path definition. |
| `DOCS/progress-ledger.md` | M | Added entries for `np-firedepartment`, `np-fish`, `np-furniture`, `np-fx`, `np-gangs`, `np-gangweapons`, `np-golf`, `np-gunmeta`, `np-gunmetaDLC`, `np-gunmetas`, `np-gurgle`, `np-gym`, `np-heatmap`, `np-hospitalization` and `np-hunting`. |
| `DOCS/index.md` | M | Added a sixth part of the sprint overview covering the websites API and new skip/defer decisions. |

# Additional updates for the seventh part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `DOCS/progress-ledger.md` | M | Added entries for `np-infinity`, `np-interior`, `np-inventory`, `np-jewelrob`, `np-jobmanager`, `np-keypad`, `np-keys`, `np-lockpicking`, `np-lootsystem` and `np-login`. |
| `DOCS/index.md` | M | Added a seventh part of the sprint overview summarising skip and defer decisions for these resources. |
| `MANIFEST.md` | M | Updated to record documentation changes for Part 7. |
| `CHANGELOG.md` | M | Added notes for Part 7. |

# Additional updates for the eighth part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/notesRepository.js` | A | New repository to persist notes dropped in the world, with CRUD helpers. |
| `src/routes/notes.routes.js` | A | New routes exposing `/v1/notes` (GET and POST) and `/v1/notes/{id}` (DELETE). |
| `src/migrations/012_add_notes.sql` | A | Migration creating the `notes` table with coordinates and timestamps. |
| `src/app.js` | M | Mounted the notes routes. |
| `openapi/api.yaml` | M | Added `Note` and `NoteCreateRequest` schemas and new paths for notes. |
| `DOCS/progress-ledger.md` | M | Added entries 58–63 to document skip decisions and the creation of the notes API. |
| `DOCS/index.md` | M | Added Part 8 sprint overview detailing the notes API and skip decisions. |
| `DOCS/modules/notes.md` | A | New module documentation describing the notes domain, endpoints, schema and troubleshooting. |
| `MANIFEST.md` | M | Updated to include Part 8 file additions and modifications. |
| `CHANGELOG.md` | M | Appended Part 8 notes describing the new notes API and updated docs. |

# Additional updates for the 2025‑08‑20 sprint

| Path | Status | Notes |
|---|---|---|
| `src/migrations/013_add_vehicle_harness.sql` | A | Migration adding a `harness` column to the `vehicles` table and indexing the `plate` column to support harness and plate-change APIs. |
| `src/repositories/vehiclesRepository.js` | M | Added `getHarnessByPlate`, `updateHarnessByPlate` and `changePlate` functions to manage harness durability and plate updates. |
| `src/routes/vehicles.routes.js` | M | Added new endpoints: `GET/PATCH /v1/vehicles/harness/{plate}` and `POST /v1/vehicles/plate-change` to retrieve/update harness and change plates. |
| `src/repositories/secondaryJobsRepository.js` | A | New repository to persist secondary job assignments. |
| `src/routes/secondaryJobs.routes.js` | A | New routes exposing `/v1/secondary-jobs` (GET, POST, DELETE) for managing secondary jobs. |
| `src/migrations/014_add_secondary_jobs.sql` | A | Migration creating the `secondary_jobs` table with indexes on `player_id`. |
| `src/app.js` | M | Mounted the secondary jobs router. |
| `openapi/api.yaml` | M | Added schemas (`VehicleHarness`, `HarnessUpdateRequest`, `PlateChangeRequest`, `SecondaryJob`, `SecondaryJobCreateRequest`) and path definitions for harness/plate and secondary job endpoints. |
| `DOCS/progress-ledger.md` | M | Added entries 64‑79 documenting skip decisions for `np-o*` resources and the creation of vehicle harness and secondary jobs APIs. |
| `DOCS/index.md` | M | Added sprint overview for 2025‑08‑20 describing the harness and secondary jobs features and skip decisions. |

# Additional updates for the 2025‑08‑20 documentation refresh

| Path | Status | Notes |
|---|---|---|
| `README.md` | M | Added a **Domain Endpoints** section summarising all major REST endpoints and their purposes, along with guidance on authentication, idempotency and response envelopes. |

# Additional updates for the 2025‑08‑21 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/ammoRepository.js` | A | New repository to retrieve and update player ammunition counts using an upsert query. |
| `src/routes/ammo.routes.js` | A | New routes exposing `/v1/players/{playerId}/ammo` for listing and updating ammunition. |
| `src/migrations/015_add_player_ammo.sql` | A | Migration creating the `player_ammo` table with composite primary key and index on `player_id`. |
| `openapi/api.yaml` | M | Moved the website POST definition to `/v1/websites`, removed the erroneous POST under the ammo path, and added documentation for the ammo endpoints. |
| `DOCS/progress-ledger.md` | M | Added entries 80–105 with skip/defer decisions and the creation of the ammo API. |
| `DOCS/index.md` | M | Added a new sprint overview (2025‑08‑21) summarising the ammunition API and additional skip decisions. |
| `DOCS/modules/ammo.md` | A | New module documentation describing the ammo domain, endpoints, repository and migration. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Added a **Weapons & Ammo** section summarising the new ammo endpoints. |
| `MANIFEST.md` | M | Updated to include this section and list new files/changes. |
| `CHANGELOG.md` | M | Appended notes for the 2025‑08‑21 sprint covering the ammo API and documentation updates. |

# Additional updates for the 2025‑08‑21 sprint (Part 2)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/phoneRepository.js` | A | Query helpers to list and create tweets. |
| `src/routes/phone.routes.js` | A | New endpoints `/v1/phone/tweets` for listing and creating tweets. |
| `src/migrations/019_add_tweets.sql` | A | Migration creating `tweets` table with index on time. |
| `src/app.js` | M | Mounted the phone routes. |
| `openapi/api.yaml` | M | Added `Tweet` schemas and `/v1/phone/tweets` path. |
| `docs/modules/phone.md` | A | Module documentation for phone tweets API. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented phone tweet endpoints. |
# Updates for 2025-08-24 (Carwash)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/carwashRepository.js` | A | Repository for car wash logs and dirt levels. |
| `src/routes/carwash.routes.js` | A | REST endpoints for car washes and vehicle dirt. |
| `src/migrations/038_add_carwash.sql` | A | Tables for carwash transactions and vehicle cleanliness. |
| `src/app.js` | M | Mounted carwash routes. |
| `openapi/api.yaml` | M | Documented carwash schemas and paths. |
| `docs/index.md` | M | Logged carwash update. |
| `docs/progress-ledger.md` | M | Added carwash entry. |
| `docs/framework-compliance.md` | M | Noted carwash module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented carwash endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped carwash events. |
| `docs/db-schema.md` | M | Described carwash tables. |
| `docs/migrations.md` | M | Listed migration 038. |
| `docs/admin-ops.md` | M | Added carwash tables check. |
| `docs/security.md` | M | Added security note for carwash. |
| `docs/testing.md` | M | Added carwash curl examples. |
| `docs/modules/carwash.md` | A | Module documentation for carwash. |
| `docs/research-log.md` | M | Logged carwash research. |
| `CHANGELOG.md` | M | Added carwash entry. |
| `docs/progress-ledger.md` | M | Added rows 106–135 covering remaining resources and phone API creation. |
| `docs/index.md` | M | Added sprint overview for resources `pNotify` through `yarn`. |

# Additional updates for the 2025‑08‑22 cleanup

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Added length constraints for tweet fields. |
| `src/routes/phone.routes.js` | M | Added length validation and removed redundant body parser. |
| `docs/modules/phone.md` | M | Documented tweet field limits. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Replaced legacy server references. |
| `docs/index.md` | M | Replaced legacy server references. |
| `docs/modules/broadcaster.md` | M | Replaced legacy server references. |
| `docs/progress-ledger.md` | M | Replaced legacy server references. |
| `src/routes/broadcaster.routes.js` | M | Reworded comments to remove legacy brand. |
| `src/routes/websites.routes.js` | M | Reworded comments to remove legacy brand. |
| `CHANGELOG.md` | M | Logged cleanup and validation changes. |

# Additional updates for the 2025‑08‑23 spec fix

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Moved character ID parameter to path level and added operationIds/400 responses to phone tweets. |
| `docs/modules/phone.md` | M | Documented 400 INVALID_INPUT responses. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Mentioned possible 400 errors on phone tweet endpoints. |
| `docs/progress-ledger.md` | M | Logged OpenAPI spec cleanup entry. |
# Additional updates for the 2025-08-22 canonicalization run

| Path | Status | Notes |
|---|---|---|
| `src/migrations/019_add_tweets.sql` | R | Renamed from `018_add_tweets.sql` to resolve migration number collision. |
| `src/openapi/api.yaml` | D | Removed duplicate specification; `openapi/api.yaml` is now canonical. |
| `openapi/api.yaml` | M | Removed stray security block and aligned with canonical content. |
| `src/routes/broadcaster.routes.js` | M | Cleared merge marker and tidied documentation. |
| `docs/modules/evidence.md` | M | Resolved merge conflict and cleaned structure. |
| `docs/modules/phone.md` | M | Updated migration reference to `019_add_tweets.sql`. |
| `MANIFEST.md` | M | Recorded canonicalization changes. |
| `CHANGELOG.md` | M | Logged canonicalization actions. |

# Additional updates for the 2025-08-23 broadcaster documentation

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Documented `/v1/broadcast/attempt` and added `JobAssignment` schema. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Added broadcaster endpoint description. |
| `docs/progress-ledger.md` | M | Removed duplicate `np‑evidence` entry. |
| `MANIFEST.md` | M | Recorded broadcaster spec and ledger cleanup. |
| `CHANGELOG.md` | M | Logged broadcaster path addition and ledger cleanup. |

# Additional updates for the 2025-08-23 broadcaster follow-up

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Added operationId and error responses for broadcaster attempt. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Clarified broadcaster error cases. |
| `docs/modules/broadcaster.md` | M | Documented standard envelope and error codes; ensured newline. |
| `MANIFEST.md` | M | Recorded broadcaster follow-up changes. |
| `CHANGELOG.md` | M | Logged broadcaster follow-up changes. |

# Additional updates for the 2025-08-22 admin bans

| Path | Status | Notes |
|---|---|---|
| `src/repositories/adminRepository.js` | A | Repository to persist player bans. |
| `src/routes/admin.routes.js` | M | Store bans via repository and validate inputs. |
| `src/migrations/020_add_bans.sql` | A | Migration creating the `bans` table with optional expiry. |
| `openapi/api.yaml` | M | Documented admin ban endpoint with security and response envelope. |
| `docs/modules/admin.md` | A | Module documentation for admin ban API. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Updated admin ban description to note persistence. |
| `docs/index.md` | M | Added sprint overview for admin bans feature. |
| `docs/progress-ledger.md` | M | Logged admin ban API creation. |
| `docs/research-log.md` | M | Noted reference repository access failure. |

# Additional updates for the 2025-08-23 evidence schema fix

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Defined `EvidenceItem` schemas referenced by evidence routes. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Removed merge artifact in broadcaster section. |
| `docs/index.md` | M | Logged evidence schema fix. |
| `docs/progress-ledger.md` | M | Recorded OpenAPI evidence entry. |
| `docs/research-log.md` | M | Noted reference repository access failure. |

# Updates for 2025-08-23 (DiamondBlackjack)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/diamondBlackjackRepository.js` | A | Persist blackjack hand history. |
| `src/routes/diamondBlackjack.routes.js` | A | Endpoints for recording and listing hands. |
| `src/migrations/021_add_diamond_blackjack.sql` | A | Creates `diamond_blackjack_hands` table. |
| `src/app.js` | M | Mounted diamond blackjack routes. |
| `openapi/api.yaml` | M | Added schemas and paths for diamond blackjack. |
| `docs/index.md` | M | Reset with new sprint overview. |
| `docs/progress-ledger.md` | M | Reset ledger with DiamondBlackjack entry. |
| `docs/framework-compliance.md` | M | Noted diamond blackjack module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented diamond blackjack endpoints. |
| `docs/events-and-rpcs.md` | A | Mapped blackjack events to API. |
| `docs/db-schema.md` | A | Documented `diamond_blackjack_hands` table. |
| `docs/migrations.md` | A | Listed migration files including 021. |
| `docs/admin-ops.md` | A | Operations notes including migration command. |
| `docs/security.md` | A | Security notes for new endpoints. |
| `docs/testing.md` | A | Manual verification guidance. |
| `docs/modules/diamondBlackjack.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged research sources. |
| `CHANGELOG.md` | M | Added diamond blackjack entry. |

# Updates for 2025-08-23 (InteractSound)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/interactSoundRepository.js` | A | Log sound play history. |
| `src/routes/interactSound.routes.js` | A | Endpoints for recording and listing plays. |
| `src/migrations/022_add_interact_sound.sql` | A | Creates `interact_sound_plays` table. |
| `src/app.js` | M | Mounted interact sound routes. |
| `openapi/api.yaml` | M | Added schemas and paths for interact sound plays. |
| `docs/index.md` | M | Noted interact sound module. |
| `docs/progress-ledger.md` | M | Added InteractSound entry. |
| `docs/framework-compliance.md` | M | Noted interact sound compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented interact sound endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped interact sound events to API. |
| `docs/db-schema.md` | M | Documented `interact_sound_plays` table. |
| `docs/migrations.md` | M | Listed migration 022. |
| `docs/admin-ops.md` | M | Added table check for interact sound. |
| `docs/security.md` | M | Mentioned interact sound security. |
| `docs/testing.md` | M | Added interact sound test guidance. |
| `docs/modules/interactSound.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged InteractSound research. |

# Updates for 2025-08-24 (LockDoors)

| Path | Status | Notes |
|---|---|---|
| `openapi/api.yaml` | M | Documented door schemas and paths. |
| `docs/index.md` | M | Added LockDoors update note. |
| `docs/progress-ledger.md` | M | Logged LockDoors resource extension. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Added door API descriptions. |
| `docs/events-and-rpcs.md` | M | Mapped door events to API routes. |
| `docs/db-schema.md` | M | Documented `doors` table. |
| `docs/admin-ops.md` | M | Added doors table check. |
| `docs/security.md` | M | Noted authentication for door routes. |
| `docs/testing.md` | M | Added curl examples for door endpoints. |
| `docs/framework-compliance.md` | M | Added doors module compliance row. |
| `docs/modules/doors.md` | A | Module documentation for doors. |
| `docs/research-log.md` | M | Logged LockDoors research. |
# Updates for 2025-08-24 PolicePack

| Path | Status | Notes |
|---|---|---|
| `src/repositories/evidenceChainRepository.js` | A | Track evidence custody chain. |
| `src/repositories/characterSelectionRepository.js` | A | Persist active character selection. |
| `src/repositories/characterRepository.js` | M | Add delete support. |
| `src/routes/accountCharacters.routes.js` | A | Account character list/create/select/delete endpoints. |
| `src/routes/evidence.routes.js` | M | Custody chain endpoints. |
| `src/app.js` | M | Mount account character routes. |
| `src/migrations/023_add_evidence_chain.sql` | A | Create evidence_chain table. |
| `src/migrations/024_add_character_selections.sql` | A | Create character_selections table. |
| `openapi/api.yaml` | M | Document custody and account character endpoints. |
| `docs/index.md` | M | Logged PolicePack update. |
| `docs/progress-ledger.md` | M | Added PolicePack entry. |
| `docs/framework-compliance.md` | M | Added PolicePack row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Added PolicePack API descriptions. |
| `docs/events-and-rpcs.md` | M | Mapped PolicePack events. |
| `docs/db-schema.md` | M | Documented new tables. |
| `docs/migrations.md` | M | Listed migrations 023–024. |
| `docs/admin-ops.md` | M | Added table checks. |
| `docs/security.md` | M | Notes on PolicePack routes. |
| `docs/testing.md` | M | Added manual tests. |
| `docs/modules/evidence.md` | M | Custody chain endpoints. |
| `docs/modules/characters.md` | A | Character selection module. |
| `docs/research-log.md` | M | Logged research limitations. |

Legend: **A** = Added, **M** = Modified.

# Updates for 2025-08-24 (Wise Audio)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/wiseAudioRepository.js` | A | Repository for character audio tracks. |
| `src/routes/wiseAudio.routes.js` | A | Endpoints for listing and creating audio tracks. |
| `src/migrations/026_add_wise_audio.sql` | A | Create wise_audio_tracks table. |
| `src/app.js` | M | Mounted wise audio routes. |
| `openapi/api.yaml` | M | Added Wise Audio schemas and paths. |
| `docs/index.md` | M | Logged Wise Audio update. |
| `docs/progress-ledger.md` | M | Added Wise Audio entry. |
| `docs/framework-compliance.md` | M | Added Wise Audio compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented Wise Audio endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped Wise Audio events. |
| `docs/db-schema.md` | M | Documented wise_audio_tracks table. |
| `docs/migrations.md` | M | Listed migration 026. |
| `docs/admin-ops.md` | M | Added table check for wise_audio_tracks. |
| `docs/security.md` | M | Wise Audio security note. |
| `docs/testing.md` | M | Added wise audio curl examples. |
| `docs/modules/wise-audio.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged Wise Audio research. |
| `CHANGELOG.md` | M | Added Wise Audio entry. |
| `MANIFEST.md` | M | Recorded Wise Audio changes. |

Legend: **A** = Added, **M** = Modified.

# Updates for 2025-08-24 (Wise Imports)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/wiseImportsRepository.js` | A | Repository for vehicle import orders. |
| `src/routes/wiseImports.routes.js` | A | Endpoints for listing and creating import orders. |
| `src/migrations/027_add_wise_imports.sql` | A | Create wise_import_orders table. |
| `src/app.js` | M | Mounted wise imports routes. |
| `openapi/api.yaml` | M | Added Wise Imports schemas and paths. |
| `docs/index.md` | M | Logged Wise Imports update. |
| `docs/progress-ledger.md` | M | Added Wise Imports entry. |
| `docs/framework-compliance.md` | M | Added Wise Imports compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented Wise Imports endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped Wise Imports events. |
| `docs/db-schema.md` | M | Documented wise_import_orders table. |
| `docs/migrations.md` | M | Listed migration 027. |
| `docs/admin-ops.md` | M | Added table check for wise_import_orders. |
| `docs/security.md` | M | Wise Imports security note. |
| `docs/testing.md` | M | Added wise imports curl examples. |
| `docs/modules/wise-imports.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged Wise Imports research. |
| `CHANGELOG.md` | M | Added Wise Imports entry. |
| `MANIFEST.md` | M | Recorded Wise Imports changes. |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-24 (Wise-UC)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/wiseUCRepository.js` | A | Repository for undercover profiles. |
| `src/routes/wiseUC.routes.js` | A | Endpoints for creating and retrieving undercover profiles. |
| `src/migrations/028_add_wise_uc.sql` | A | Create wise_uc_profiles table. |
| `src/app.js` | M | Mounted wise uc routes. |
| `openapi/api.yaml` | M | Added Wise UC schemas and paths. |
| `docs/index.md` | M | Logged Wise-UC update. |
| `docs/progress-ledger.md` | M | Added Wise-UC entry. |
| `docs/framework-compliance.md` | M | Added Wise UC compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented Wise UC endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped Wise UC events. |
| `docs/db-schema.md` | M | Documented wise_uc_profiles table. |
| `docs/migrations.md` | M | Listed migration 028. |
| `docs/admin-ops.md` | M | Added table check for wise_uc_profiles. |
| `docs/security.md` | M | Wise UC security note. |
| `docs/testing.md` | M | Added wise uc curl examples. |
| `docs/modules/wise-uc.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged Wise-UC research. |
| `CHANGELOG.md` | M | Added Wise-UC entry. |
| `MANIFEST.md` | M | Recorded Wise-UC changes. |

Legend: **A** = Added, **M** = Modified.
# Update – 2025-08-24 (WiseGuy-Vanilla)

| Path | Status | Notes |
|---|---|---|
| `src/routes/characters.routes.js` | D | Removed legacy unscoped character routes. |
| `src/app.js` | M | Dropped import and mount of legacy character routes. |
| `openapi/api.yaml` | M | Removed `/v1/characters` paths. |
| `docs/index.md` | M | Logged removal of legacy character endpoints. |
| `docs/progress-ledger.md` | M | Added WiseGuy-Vanilla entry. |
| `docs/framework-compliance.md` | M | Noted consolidation of character module. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented account-scoped character API only. |
| `docs/events-and-rpcs.md` | M | Mapped WiseGuy-Vanilla to account character endpoints. |
| `docs/modules/characters.md` | M | Added note about legacy endpoint removal. |
| `docs/research-log.md` | M | Logged WiseGuy-Vanilla research. |

Legend: **A** = Added, **M** = Modified, **D** = Deleted.

# Update – 2025-08-24 (WiseGuy-Wheels)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/wiseWheelsRepository.js` | A | Repository for wheel spin history. |
| `src/routes/wiseWheels.routes.js` | A | Endpoints for listing and recording wheel spins. |
| `src/migrations/029_add_wise_wheels.sql` | A | Create wise_wheels_spins table. |
| `src/app.js` | M | Mounted wise wheels routes. |
| `openapi/api.yaml` | M | Added Wise Wheels schemas and paths. |
| `docs/index.md` | M | Logged Wise Wheels update. |
| `docs/progress-ledger.md` | M | Added WiseGuy-Wheels entry. |
| `docs/framework-compliance.md` | M | Added Wise Wheels compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented Wise Wheels endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped WiseGuy-Wheels events. |
| `docs/db-schema.md` | M | Documented wise_wheels_spins table. |
| `docs/migrations.md` | M | Listed migration 029. |
| `docs/admin-ops.md` | M | Added table check for wise_wheels_spins. |
| `docs/security.md` | M | Wise Wheels security note. |
| `docs/testing.md` | M | Added wise wheels curl examples. |
| `docs/modules/wise-wheels.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged WiseGuy-Wheels research. |
| `MANIFEST.md` | M | Recorded WiseGuy-Wheels changes. |
| `CHANGELOG.md` | M | Added Wise Wheels entry. |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-24 (assets_clothes)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/clothesRepository.js` | A | Repository for character outfit records. |
| `src/routes/clothes.routes.js` | A | Endpoints for listing, creating and deleting outfits. |
| `src/migrations/031_add_clothes.sql` | A | Create clothes table. |
| `src/app.js` | M | Mounted clothes routes. |
| `openapi/api.yaml` | M | Added Clothing schemas and `/v1/clothes` paths. |
| `docs/index.md` | M | Logged assets_clothes update. |
| `docs/progress-ledger.md` | M | Added assets_clothes entry. |
| `docs/framework-compliance.md` | M | Added clothes module compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented clothes endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped assets_clothes events. |
| `docs/db-schema.md` | M | Documented clothes table. |
| `docs/migrations.md` | M | Listed migration 031. |
| `docs/admin-ops.md` | M | Added clothes table check. |
| `docs/security.md` | M | Added clothes security note. |
| `docs/testing.md` | M | Added clothes curl examples. |
| `docs/modules/clothes.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged assets_clothes research. |
| `CHANGELOG.md` | M | Added assets_clothes entry. |
| `MANIFEST.md` | M | Recorded assets_clothes changes. |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-24 (maps, furnished-shells, hair-pack, mh65c, motel, shoes-pack, yuzler)

| Path | Status | Notes |
|---|---|---|
| `docs/index.md` | M | Logged asset-only resources evaluation. |
| `docs/progress-ledger.md` | M | Added entries for asset-only resources. |
| `docs/events-and-rpcs.md` | M | Noted absence of events for asset-only resources. |
| `docs/research-log.md` | M | Recorded asset pack research references. |
| `MANIFEST.md` | M | Recorded documentation-only update. |
| `CHANGELOG.md` | M | Logged asset pack skip decisions. |

Legend: **A** = Added, **M** = Modified.
# Update – 2025-08-24 (apartments)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/apartmentsRepository.js` | M | Character-scoped queries and assignments |
| `src/routes/apartments.routes.js` | M | Accept characterId and filter by resident |
| `src/migrations/032_add_apartment_residents_character_fk.sql` | A | Convert apartment_residents to character_id |
| `openapi/api.yaml` | M | Added apartment schemas and paths |
| `docs/index.md` | M | Logged apartments update |
| `docs/progress-ledger.md` | M | Added apartments entry |
| `docs/framework-compliance.md` | M | Added apartments row |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented apartment endpoints |
| `docs/events-and-rpcs.md` | M | Mapped apartment events |
| `docs/db-schema.md` | M | Documented apartments tables |
| `docs/migrations.md` | M | Listed migration 032 |
| `docs/admin-ops.md` | M | Table check for apartments |
| `docs/security.md` | M | Apartments security note |
| `docs/testing.md` | M | Added apartments curl examples |
| `docs/modules/apartments.md` | A | Module documentation |
| `CHANGELOG.md` | M | Added apartments entry |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-24 (banking)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/economyRepository.js` | M | Renamed columns to character scope and added transaction listing |
| `src/routes/economy.routes.js` | M | Character-scoped banking endpoints and validation |
| `src/migrations/033_update_economy_character_scoping.sql` | A | Rename economy tables to character_id |
| `openapi/api.yaml` | M | Added banking schemas and paths |
| `docs/index.md` | M | Logged banking update |
| `docs/progress-ledger.md` | M | Added banking entry |
| `docs/framework-compliance.md` | M | Added economy module compliance row |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented banking endpoints |
| `docs/events-and-rpcs.md` | M | Mapped banking events |
| `docs/db-schema.md` | M | Documented accounts and transactions tables |
| `docs/migrations.md` | M | Listed migration 033 |
| `docs/admin-ops.md` | M | Added accounts and transactions checks |
| `docs/security.md` | M | Added economy security note |
| `docs/testing.md` | M | Added banking curl examples |
| `docs/modules/economy.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged banking research |
| `CHANGELOG.md` | M | Added banking entry |
| `MANIFEST.md` | M | Recorded banking changes |

Legend: **A** = Added, **M** = Modified.
# Update – 2025-08-24 (baseevents)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/baseEventsRepository.js` | A | Repository for logging and retrieving base events. |
| `src/routes/baseEvents.routes.js` | A | Endpoints for recording and listing base events. |
| `src/migrations/034_add_base_event_logs.sql` | A | Create base_event_logs table. |
| `src/app.js` | M | Mounted base events routes. |
| `openapi/api.yaml` | M | Added BaseEventLog schemas and `/v1/base-events` paths. |
| `docs/index.md` | M | Logged baseevents update. |
| `docs/progress-ledger.md` | M | Added baseevents entry. |
| `docs/framework-compliance.md` | M | Added baseevents compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented base events endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped baseevents events. |
| `docs/db-schema.md` | M | Documented base_event_logs table. |
| `docs/migrations.md` | M | Listed migration 034. |
| `docs/admin-ops.md` | M | Added base_event_logs table check. |
| `docs/security.md` | M | Added base events security note. |
| `docs/testing.md` | M | Added base events curl examples. |
| `docs/modules/baseevents.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged baseevents research. |
| `CHANGELOG.md` | M | Added baseevents entry. |

# Updates for 2025-08-24 (Boatshop)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/boatshopRepository.js` | A | Boat catalog and purchase logic. |
| `src/routes/boatshop.routes.js` | A | Endpoints for listing and purchasing boats. |
| `src/migrations/035_add_boatshop.sql` | A | Create boatshop_boats table. |
| `src/app.js` | M | Mounted boatshop routes. |
| `openapi/api.yaml` | M | Added Boat schema and boatshop paths. |
| `docs/index.md` | M | Logged boatshop update. |
| `docs/progress-ledger.md` | M | Added boatshop entry. |
| `docs/framework-compliance.md` | M | Added boatshop compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented boatshop endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped boatshop events. |
| `docs/db-schema.md` | M | Documented boatshop_boats table. |
| `docs/migrations.md` | M | Listed migration 035. |
| `docs/admin-ops.md` | M | Added boatshop table check. |
| `docs/security.md` | M | Added boatshop security note. |
| `docs/testing.md` | M | Added boatshop curl examples. |
| `docs/modules/boatshop.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged boatshop research. |
| `CHANGELOG.md` | M | Added boatshop entry. |

# Update – 2025-08-24 (bob74_ipl)

| Path | Status | Notes |
|---|---|---|
| `docs/index.md` | M | Logged bob74_ipl evaluation |
| `docs/progress-ledger.md` | M | Added bob74_ipl entry |
| `docs/events-and-rpcs.md` | M | Noted absence of bob74_ipl events |
| `docs/research-log.md` | M | Recorded bob74_ipl research |
| `MANIFEST.md` | M | Recorded bob74_ipl documentation update |
| `CHANGELOG.md` | M | Logged bob74_ipl skip decision |

# Update – 2025-08-24 (camera)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/cameraRepository.js` | A | Photo storage queries. |
| `src/routes/camera.routes.js` | A | Camera photo endpoints. |
| `src/migrations/036_add_camera_photos.sql` | A | Create camera_photos table. |
| `src/app.js` | M | Mounted camera routes. |
| `openapi/api.yaml` | M | Added CameraPhoto schemas and paths. |
| `docs/index.md` | M | Logged camera update. |
| `docs/progress-ledger.md` | M | Added camera entry. |
| `docs/framework-compliance.md` | M | Noted camera module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented camera endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped camera events. |
| `docs/db-schema.md` | M | Documented camera_photos table. |
| `docs/migrations.md` | M | Listed migration 036. |
| `docs/admin-ops.md` | M | Added camera table check. |
| `docs/security.md` | M | Camera security note. |
| `docs/testing.md` | M | Camera curl examples. |
| `docs/modules/camera.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged camera research. |
| `CHANGELOG.md` | M | Added camera entry. |
# Update – 2025-08-24 (carandplayerhud)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/hudRepository.js` | A | Store and retrieve HUD preferences. |
| `src/routes/hud.routes.js` | A | Endpoints for HUD preferences. |
| `src/migrations/037_add_character_hud_preferences.sql` | A | Create character_hud_preferences table. |
| `src/app.js` | M | Mounted hud routes. |
| `openapi/api.yaml` | M | Added HUD schemas and paths. |
| `docs/index.md` | M | Logged carandplayerhud update. |
| `docs/progress-ledger.md` | M | Added carandplayerhud entry. |
| `docs/framework-compliance.md` | M | Noted hud module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented hud endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped carandplayerhud events. |
| `docs/db-schema.md` | M | Documented character_hud_preferences table. |
| `docs/migrations.md` | M | Listed migration 037. |
| `docs/admin-ops.md` | M | Added hud table check. |
| `docs/security.md` | M | Hud security note. |
| `docs/testing.md` | M | Hud curl examples. |
| `docs/modules/hud.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged carandplayerhud research. |
| `CHANGELOG.md` | M | Added carandplayerhud entry. |
| `MANIFEST.md` | M | Recorded carandplayerhud update. |

# Update – 2025-08-24 (chat)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/chatRepository.js` | A | Store and retrieve chat messages. |
| `src/routes/chat.routes.js` | A | Chat message endpoints. |
| `src/migrations/039_add_chat_messages.sql` | A | Create chat_messages table. |
| `src/app.js` | M | Mounted chat routes. |
| `openapi/api.yaml` | M | Added ChatMessage schemas and paths. |
| `docs/index.md` | M | Logged chat update. |
| `docs/progress-ledger.md` | M | Added chat entry. |
| `docs/framework-compliance.md` | M | Added chat module compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented chat endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped chat events. |
| `docs/db-schema.md` | M | Documented chat_messages table. |
| `docs/migrations.md` | M | Listed migration 039. |
| `docs/admin-ops.md` | M | Added chat table check. |
| `docs/security.md` | M | Chat security note. |
| `docs/testing.md` | M | Added chat curl examples. |
| `docs/modules/chat.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged chat research. |
| `CHANGELOG.md` | M | Added chat entry. |
| `MANIFEST.md` | M | Recorded chat update. |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-24 (connectqueue)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/connectqueueRepository.js` | A | Manage account queue priorities. |
| `src/routes/connectqueue.routes.js` | A | API endpoints for queue priorities. |
| `src/migrations/040_add_queue_priorities.sql` | A | Create queue_priorities table. |
| `src/app.js` | M | Mounted connect queue routes. |
| `openapi/api.yaml` | M | Documented connect queue schemas and paths. |
| `docs/index.md` | M | Logged connectqueue update. |
| `docs/progress-ledger.md` | M | Added connectqueue entry. |
| `docs/framework-compliance.md` | M | Added connectqueue compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented connectqueue endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped connectqueue events. |
| `docs/db-schema.md` | M | Documented queue_priorities table. |
| `docs/migrations.md` | M | Listed migration 040. |
| `docs/admin-ops.md` | M | Added queue_priorities table check. |
| `docs/security.md` | M | Connect queue security note. |
| `docs/testing.md` | M | Added connectqueue curl examples. |
| `docs/modules/connectqueue.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged connectqueue research. |

# Update – 2025-08-24 (Cron)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/cronRepository.js` | A | Manage cron job records. |
| `src/routes/cron.routes.js` | A | Cron job endpoints. |
| `src/migrations/041_add_cron_jobs.sql` | A | Create cron_jobs table. |
| `src/app.js` | M | Mounted cron routes. |
| `openapi/api.yaml` | M | Added CronJob schemas and paths. |
| `docs/index.md` | M | Logged Cron update. |
| `docs/progress-ledger.md` | M | Added Cron entry. |
| `docs/framework-compliance.md` | M | Added cron module compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented cron endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped cron events. |
| `docs/db-schema.md` | M | Documented cron_jobs table. |
| `docs/migrations.md` | M | Listed migration 041. |
| `docs/admin-ops.md` | M | Added cron table check. |
| `docs/security.md` | M | Cron security note. |
| `docs/testing.md` | M | Added cron curl examples. |
| `docs/modules/cron.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged cron research. |

# Update – 2025-08-24 (coordsaver)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/coordsaverRepository.js` | A | Coordinate storage queries. |
| `src/routes/coordsaver.routes.js` | A | Coordinate endpoints. |
| `src/migrations/041_add_character_coords.sql` | A | Create character_coords table. |
| `src/app.js` | M | Mounted coordsaver routes. |
| `openapi/api.yaml` | M | Added coordinate schemas and paths. |
| `docs/index.md` | M | Logged coordsaver update. |
| `docs/progress-ledger.md` | M | Added coordsaver entry. |
| `docs/framework-compliance.md` | M | Added coordsaver compliance row. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented coordsaver endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped coordsaver events. |
| `docs/db-schema.md` | M | Documented character_coords table. |
| `docs/migrations.md` | M | Listed migration 041. |
| `docs/admin-ops.md` | M | Added character_coords table check. |
| `docs/security.md` | M | Coordsaver security note. |
| `docs/testing.md` | M | Added coordsaver curl examples. |
| `docs/modules/coordsaver.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged coordsaver research. |
| `CHANGELOG.md` | M | Added coordsaver entry. |
| `MANIFEST.md` | M | Recorded coordsaver update. |

# Updates for 2025-08-24 (drz_interiors)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/interiorsRepository.js` | A | Repository for apartment interior layouts. |
| `src/routes/interiors.routes.js` | A | Endpoints for saving and fetching interiors. |
| `src/migrations/042_add_cron_jobs.sql` | R | Renamed from 041 to resolve numbering conflict. |
| `src/migrations/043_add_interiors.sql` | A | Create interiors table. |
| `src/app.js` | M | Mounted interiors routes and cleaned merge marker. |
| `openapi/api.yaml` | M | Added Interior schemas and paths. |
| `docs/index.md` | M | Logged drz_interiors update. |
| `docs/progress-ledger.md` | M | Added drz_interiors entry. |
| `docs/migrations.md` | M | Listed migrations 042 and 043. |
| `docs/db-schema.md` | M | Documented interiors table. |
| `docs/framework-compliance.md` | M | Noted interiors module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented interiors endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped interiors events. |
| `docs/admin-ops.md` | M | Added interiors table check. |
| `docs/security.md` | M | Added interiors security note. |
| `docs/testing.md` | M | Added interiors curl examples. |
| `docs/modules/interiors.md` | A | Module documentation for interiors. |
| `docs/research-log.md` | M | Logged drz_interiors research. |
# Update – 2025-08-24 (emotes)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/emotesRepository.js` | A | Repository for character favorite emotes. |
| `src/routes/emotes.routes.js` | A | Favorite emote endpoints. |
| `src/migrations/044_add_character_emotes.sql` | A | Create character_emotes table. |
| `src/app.js` | M | Mounted emotes routes. |
| `openapi/api.yaml` | M | Added CharacterEmote schemas and paths. |
| `docs/index.md` | M | Logged emotes update. |
| `docs/progress-ledger.md` | M | Added emotes entry. |
| `docs/framework-compliance.md` | M | Noted emotes module compliance. |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented emotes endpoints. |
| `docs/events-and-rpcs.md` | M | Mapped emotes events. |
| `docs/db-schema.md` | M | Documented character_emotes table. |
| `docs/migrations.md` | M | Listed migration 044. |
| `docs/admin-ops.md` | M | Added character_emotes table check. |
| `docs/security.md` | M | Emotes security note. |
| `docs/testing.md` | M | Added emotes curl examples. |
| `docs/modules/emotes.md` | A | Module documentation. |
| `docs/research-log.md` | M | Logged emotes research. |
| `CHANGELOG.md` | M | Added emotes entry. |
| `MANIFEST.md` | M | Recorded emotes update. |

Legend: **A** = Added, **M** = Modified.

# Update – 2025-08-25 (emspack)

| Path | Status | Notes |
|---|---|---|
| `src/repositories/emsRepository.js` | M | Added EMS shift helpers |
| `src/routes/ems.routes.js` | M | Added shift routes |
| `src/migrations/045_add_ems_shift_logs.sql` | A | Create EMS shift logs table |
| `openapi/api.yaml` | M | Documented EMS record and shift endpoints |
| `docs/index.md` | M | Logged emspack update |
| `docs/progress-ledger.md` | M | Added emspack entry |
| `docs/framework-compliance.md` | M | Noted EMS module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented EMS endpoints |
| `docs/events-and-rpcs.md` | M | Mapped EMS events |
| `docs/db-schema.md` | M | Documented ems tables |
| `docs/migrations.md` | M | Listed migration 045 |
| `docs/admin-ops.md` | M | Added EMS table checks |
| `docs/security.md` | M | EMS security note |
| `docs/testing.md` | M | Added EMS curl examples |
| `docs/modules/ems.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged emspack research |

Legend: **A** = Added, **M** = Modified.
