# Manifest – Sprint 2025‑08‑19

This manifest summarises the files added or modified in this sprint
for the `srp‑base` Node.js service.  Only files that changed are
listed here.  Files not mentioned were left untouched.

| Path | Status | Notes |
|---|---|---|
| `src/repositories/jobsRepository.js` | M | Added `countPlayersForJob` and `getJobByName` helpers to support the broadcaster module. |
| `src/routes/broadcaster.routes.js` | A | New route for assigning the broadcaster job while enforcing a maximum number of concurrent broadcasters. |
| `src/app.js` | M | Mounted the new broadcaster route. |
| `DOCS/progress-ledger.md` | A | Progress log for processed NoPixel resources and decisions. |
| `DOCS/index.md` | A | Sprint overview summarising tasks and outcomes. |
| `DOCS/modules/broadcaster.md` | A | Per‑module documentation describing the broadcaster API. |

| `DOCS/framework-compliance.md` | A | Added framework compliance rubric and evaluation for the Node.js service. |
| `DOCS/progress-ledger.md` | M | Added entries for `np‑errorlog`, `LockDoors` and `np‑density`. |
| `DOCS/index.md` | M | Added sprint 2025‑08‑19 overview and summary. |

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


