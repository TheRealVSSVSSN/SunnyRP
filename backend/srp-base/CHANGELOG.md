# Changelog

## 2025‑08‑18

### Added

* **Broadcaster module.** Implemented a new Express route (`/v1/broadcast/attempt`) that allows a
  player to become a broadcaster job if fewer than `MAX_BROADCASTERS` players
  currently hold the role.  The route uses `jobsRepository.countPlayersForJob`
  to enforce the limit and `jobsRepository.assignJob` to assign the job.
  Added configuration via `MAX_BROADCASTERS` environment variable.
* **jobsRepository helpers.** Added `countPlayersForJob` and `getJobByName`
  functions to `jobsRepository.js` to support generic lookup and counting
  operations by job name.

### Changed

* **app.js**: Mounted the new broadcaster route.

### Notes

This sprint continues the integration of legacy server behaviours into
the unified `srp‑base` Node.js backend.  The broadcaster module
implements the server-side logic of the legacy `np-broadcaster`
resource in a RESTful manner.  The limit of concurrent broadcasters
is configurable via the `MAX_BROADCASTERS` environment variable.

## 2025‑08‑19

### Added

* **Framework compliance documentation.** Added `DOCS/framework-compliance.md` which
  defines a rubric for what constitutes a robust Node.js service (layering,
  configuration, DI, testing, etc.) and evaluates `srp‑base` against it.

### Changed

* **progress-ledger.md** – added entries for `np‑errorlog`, `LockDoors` and
  `np‑density`, all of which were skipped due to existing error logging
  functionality or lack of server logic.
* **index.md** – added sprint overview for 2025‑08‑19 summarising
  documentation efforts and skip decisions.

### Notes

This sprint focused on research, documentation and gap analysis
rather than new features.  After compiling a framework compliance
rubric and auditing the existing codebase, we resumed processing
legacy resources.  The following resources were reviewed:

* **koilWeatherSync** – provides events to sync weather and time; the
  existing `/v1/world/state` endpoints already handle world state via
  REST, so no server changes were required.
* **mapmanager** – manages maps and game types; internal to FiveM and
  not relevant to our API.
* **chat** – chat messaging and command suggestions; purely client‑side.
* **cron** – minimal cron scheduler; Node.js has built‑in scheduling.
* **minimap** – client‑only minimap adjustments.
* **np‑admin** – complex administrative system requiring a job and
  permissions framework; deferred.
* **np‑barriers** – client‑only barrier placement.
* **np‑base** – enormous core framework; deferred for a dedicated sprint.

All of these were **skipped** in this sprint because they either lack
server logic or would require a much larger effort to integrate.
Consequently, no new endpoints, services or migrations were added.
Future sprints will revisit deferred resources (e.g. `np‑admin`,
`np‑base`) and continue to fill remaining gaps once supporting
infrastructure (jobs, permissions, etc.) is in place.

### Added (Part 3)

* **Contracts API.** Added a new repository (`contractsRepository.js`) and REST
  routes (`/v1/contracts`, `/v1/contracts/{id}/accept`, `/v1/contracts/{id}/decline`) to
  support creating, listing, accepting and declining player contracts.  A
  migration (`008_add_contracts.sql`) creates the `contracts` table with
  sender_id, receiver_id, amount, info, paid, accepted and timestamps.  On
  acceptance the API withdraws funds from the receiver’s account and
  deposits them into the sender’s account using existing economy
  functions.

### Changed (Part 3)

* **app.js** – Mounted the new contracts router.
* **openapi/api.yaml** – Added a `Contract` schema and new path definitions for
  the contracts API.  Updated components to include the new schema.
* **progress‑ledger.md** – Added entries for `np‑camera`, `np‑cid`, `np‑contracts`,
  `np‑dances`, `np‑dealer` and `np‑dirtymoney` with skip/create decisions.
* **index.md** – Added a third part to the 2025‑08‑19 sprint overview
  summarising the contracts implementation and additional skip decisions.

### Notes (Part 3)

This part of the sprint focused on the **np‑contracts** resource, which
contains server code for sending and accepting contracts between
players【400719268596618†L10-L20】.  To port this behaviour to the
microservice we introduced a dedicated contracts API.  Other resources
reviewed (np‑camera, np‑cid, np‑dances, np‑dealer, np‑dirtymoney) were
skipped because they either lack server logic or depend on
functionality (inventory, dirty money economy) slated for future work【836458714788436†L0-L12】【414013350686833†L0-L15】.  The
progress ledger has been updated accordingly.

### Added (Part 4)

* **Drift school endpoint.** Added `/v1/driftschool/pay` route to allow
  clients to withdraw funds from a player's account for drift school
  participation.  The route validates input, checks the player's
  balance and returns the new balance on success.
* **Driving tests API.** Introduced a new repository (`drivingTestsRepository.js`),
  route (`/v1/driving-tests` and `/v1/driving-tests/{id}`) and migration
  (`009_add_driving_tests.sql`) to persist and retrieve driving test
  results.  The API allows instructors to record tests and players
  (or authorised roles) to view recent tests and individual reports.
* **OpenAPI schemas.** Added `DrivingTest` and `DriftSchoolPayment` schemas
  and documented new paths in the OpenAPI specification.

### Changed (Part 4)

* **app.js** – Mounted the new driving tests and drift school routers.
* **openapi/api.yaml** – Added schemas and paths for driving tests and
  drift school payment.
* **progress‑ledger.md** – Added entries for `np-driftschool`,
  `np-driving-instructor` and `np-drugdeliveries` with decisions.
* **index.md** – Added a fourth part to the 2025‑08‑19 sprint overview
  describing the driving tests and drift school implementations.

### Notes (Part 4)

The **np‑driftschool** Lua script defines a simple event that charges
players for drift school participation【761714451400029†L0-L11】.  We
mirrored this with a `POST /v1/driftschool/pay` endpoint that uses the
existing economy repository to withdraw funds and returns the updated
balance.

The **np‑driving‑instructor** resource implements a full driving test
system, storing results in a MySQL table and providing events for
submitting tests and retrieving history【393162189931023†L0-L45】.
Our port introduces a `driving_tests` table and RESTful endpoints to
record and retrieve driving tests.  We skipped additional behaviour
related to instructor actions and whitelisting as these require a
jobs/permissions framework that will be tackled later.  The
`np-drugdeliveries` resource, which orchestrates drug delivery jobs
and chop shop lists【896869969423342†L0-L93】, was skipped because it
involves complex game mechanics beyond the scope of this sprint.

### Added (Part 5)

* **Weed plants API.** Added a new domain for managing cannabis crops.  A
  repository (`weedPlantsRepository.js`), routes (`weedPlants.routes.js`) and
  migration (`010_add_weed_plants.sql`) were introduced.  Endpoints
  include:
    * `GET /v1/weed-plants` – list all weed plants.
    * `POST /v1/weed-plants` – create a new plant with coordinates,
      seed and owner ID.
    * `PATCH /v1/weed-plants/{id}` – update the growth value of an
      existing plant.
    * `DELETE /v1/weed-plants/{id}` – remove a plant.
  The OpenAPI spec now defines a `WeedPlant` schema and the new paths.

### Changed (Part 5)

* **app.js** – Mounted the weed plants router.
* **openapi/api.yaml** – Added `WeedPlant` schema and `/v1/weed-plants` paths.
* **progress‑ledger.md** – Added entries for `np-firedepartment`, `np-fish`,
  `np-furniture`, `np-fx`, `np-gangs`, `np-gangweapons`, `np-golf`,
  `np-gunmeta`, `np-gunmetaDLC`, `np-gunmetas` reflecting skip/create decisions.
* **index.md** – Added a fifth part to the sprint overview summarising
  the weed plants implementation and associated skip decisions.

### Notes (Part 5)

The **np‑gangs** resource includes server events for creating,
destroying and updating cannabis plants stored in a MySQL table【366444498392161†L9-L33】.
To support this behaviour we added a weed plants domain to the API.  All other
resources reviewed in this part (fire department, fish, furniture,
fx, gang weapons, golf, gunmeta, gunmetaDLC, gunmetas) contained only
client scripts or trivial events and were therefore skipped.

### Added (Part 6)

* **Websites API.** Implemented new endpoints to support the Gurgle
  phone app.  Players can purchase websites for a fixed fee and list
  existing websites.  A new repository (`websitesRepository.js`)
  encapsulates database operations and a migration (`011_add_websites.sql`)
  creates the `websites` table.  The API exposes:
    * `GET /v1/websites` – list all websites or filter by owner via
      query parameter `ownerId`.
    * `POST /v1/websites` – create a new website, charging the
      player’s cash balance and returning the created record.
  The OpenAPI specification now includes `Website` and
  `WebsiteCreateRequest` schemas and the new paths.  Rate limiting
  restricts website creation to 5 per minute per IP.

### Changed (Part 6)

* **app.js** – Mounted the websites router.
* **openapi/api.yaml** – Added `Website` and `WebsiteCreateRequest` schemas and
  `/v1/websites` paths.
* **progress‑ledger.md** – Added entries for `np-gurgle`, `np-gym`,
  `np-heatmap`, `np-hospitalization` and `np-hunting` with skip/defer
  decisions.
* **index.md** – Added a sixth part to the sprint overview describing
  the websites integration and additional skip/defer decisions.

### Notes (Part 6)

The **np‑gurgle** resource defines server logic for purchasing
websites using a fixed fee and storing them in a database【73746484563419†L0-L48】.
We ported this behaviour into the Node.js API as the Websites
domain.  Resources reviewed but skipped include gym, heatmap,
hospitalization (deferred) and hunting, as they either lack server
logic or require more comprehensive systems (e.g. EMS) to support.

### Changed (Part 7)

* **progress‑ledger.md** – Added entries for `np-infinity`, `np-interior`,
  `np-inventory`, `np-jewelrob`, `np-jobmanager`, `np-keypad`, `np-keys`,
  `np-lockpicking`, `np-lootsystem` and `np-login` reflecting skip or defer decisions.
* **index.md** – Added a seventh part to the sprint overview summarising the skip
  and defer decisions for these resources.
* **MANIFEST.md** – Updated to include documentation changes for Part 7.

### Notes (Part 7)

In this sprint we examined another batch of legacy resources.
`np-infinity` broadcasts players’ coordinates via events and does not
require persistence【569396379702026†L0-L12】.  `np-interior`, `np-keypad`,
`np-keys`, `np-lockpicking`, `np-lootsystem` and `np-login` contain
only client code or trivial events【894325454073906†L0-L55】【237659149565814†L0-L81】.
The legacy `np-inventory` resource implements its own inventory system【108768342973504†L0-L131】,
but our microservice already provides inventory endpoints, so no new backend
is necessary.  `np-jewelrob` defines robbery events without persistence【564860878882183†L0-L35】.
`np-jobmanager` handles job whitelisting and assignment using database
queries【769332134670781†L0-L43】; this was deferred because a comprehensive jobs
and permissions framework is not yet implemented.  Accordingly, no new
endpoints or migrations were introduced in this part.  The changes are
limited to documentation updates: the progress ledger and index reflect
these decisions and outline the remaining resources for future sprints.

### Added (Part 8)

* **Notes API.** Implemented a new domain to persist world notes.  Added
  `notesRepository.js` and `notes.routes.js` along with a migration
  (`012_add_notes.sql`) to create the `notes` table.  The API supports
  `GET /v1/notes` to list all notes, `POST /v1/notes` to create a new
  note with text and coordinates, and `DELETE /v1/notes/{id}` to remove
  an existing note.  A new `Note` schema and the `/v1/notes` paths
  were added to the OpenAPI specification.
* **Documentation.** Added module documentation for the notes domain
  under `DOCS/modules/notes.md`.

### Changed (Part 8)

* **app.js** – Mounted the notes router so the new endpoints are
  available.
* **openapi/api.yaml** – Added `Note` and `NoteCreateRequest` schemas
  and defined paths `/v1/notes` and `/v1/notes/{id}` with request and
  response payload definitions.
* **progress‑ledger.md** – Added entries for `np-lost`, `np-memorial`,
  `np-menu`, `np-news`, `np-newsJob` and `np-notepad`, documenting
  skip decisions and the creation of the notes API.
* **index.md** – Added an eighth part to the sprint overview summarising
  the notes implementation and skip decisions.
* **MANIFEST.md** – Updated to list new files and modifications for
  Part 8.
* **CHANGELOG.md** – This file (current section) records the changes.

### Notes (Part 8)

This sprint focused on a set of resources (`np-lost` through
`np-notepad`).  Most contained only client-side code or event relays
that do not require backend state.  The **np-notepad** resource stood
out because it maintains a `serverNotes` table and exposes events to
add, remove and list notes【136491508201320†L0-L19】.  To support
persistence across server restarts and a standard API, we implemented
a Notes domain.  Players can create notes specifying a message and
world coordinates; the service persists notes in a new `notes` table
and allows retrieval and deletion via HTTP.  The API enforces
validation, authentication, rate limiting and idempotency consistent
with the rest of the service.  Other resources in this batch were
skipped because they lack server logic or will be addressed in
dedicated sprints (e.g., news, menu, lost and memorial modules).

### Added (2025‑08‑20)

* **Vehicle harness & plate change API.** Added new functions to the
  vehicles repository (`getHarnessByPlate`, `updateHarnessByPlate`,
  `changePlate`) and exposed REST endpoints:
  `GET /v1/vehicles/harness/{plate}`, `PATCH /v1/vehicles/harness/{plate}` and
  `POST /v1/vehicles/plate-change`.  A migration (013) augments the
  `vehicles` table with a `harness` column and indexes the `plate`
  column to support these queries.
* **Secondary jobs API.** Implemented a new domain to manage
  secondary job assignments.  Added `secondaryJobsRepository.js`,
  `secondaryJobs.routes.js` and a migration (`014_add_secondary_jobs.sql`)
  creating the `secondary_jobs` table.  Endpoints include
  `GET /v1/secondary-jobs?playerId=cid`, `POST /v1/secondary-jobs` and
  `DELETE /v1/secondary-jobs?playerId=cid`.

### Changed (2025‑08‑20)

* **vehicles.routes.js** – Added new routes for harness management and
  plate changes.  These endpoints validate input and call the
  corresponding repository functions.
* **app.js** – Mounted the secondary jobs router so the new
  endpoints are available under `/v1/secondary-jobs`.
* **openapi/api.yaml** – Added schemas (`VehicleHarness`,
  `HarnessUpdateRequest`, `PlateChangeRequest`, `SecondaryJob`,
  `SecondaryJobCreateRequest`) and path definitions for harness/plate
  and secondary job endpoints.
* **progress‑ledger.md** – Added entries 64–79 covering the
  `np-o` resources up to `np-secondaryjobs`, with skip decisions and
  notes on new functionality.
* **index.md** – Added a sprint overview for 2025‑08‑20 summarising the
  new features and skip decisions.
* **MANIFEST.md** – Updated to list new files (migrations, repository,
  routes) and modifications.

### Notes (2025‑08‑20)

This sprint examined the `np-o*` modules and beyond.  Most of these
resources were client‑only or contained simple event relays, so
they were skipped.  The notable exceptions were **np‑oVehicleMod**
and **np‑secondaryjobs**.  The former includes server events to
retrieve and update harness durability and to change a vehicle’s
license plate【562190696785774†L0-L90】.  To support this, we
extended the vehicles domain with dedicated endpoints and added a
`harness` column to the vehicles table.  The latter manages
secondary job assignments by inserting and deleting entries in a
`secondary_jobs` table【649885668358986†L0-L35】.  We created an
API to assign, list and remove secondary jobs, backed by a new
table.  All new endpoints honour authentication, rate limiting and
idempotency conventions established in earlier sprints.  The
remaining `np-o*` resources and other simple modules (particles,
prison, propattach, rehab, restart, scoreboard, sirens, spikes,
stash, stashhouse, stripclub, taskbar variants, taximeter, thermite,
tow, tuner, tunershop, vanillaCarTweak) were skipped as they do not
require persistent state.  The heist resource `np-robbery` was
deferred for a future sprint due to its complexity.  The progress
ledger and documentation have been updated to reflect these
decisions and new capabilities.

### Added (2025‑08‑20 – Documentation refresh)

* **README.md** – Added a **Domain Endpoints** section that summarises all major REST endpoints across the players, characters, economy, inventory, vehicles, jobs, world, notes, weed plants, websites, driving tests, drift school and contracts domains.  This update ensures developers and API consumers can quickly discover available endpoints and understand their purpose.  The new section also reminds readers about the uniform response envelope, authentication headers and idempotency conventions.

### Notes (2025‑08‑20 – Documentation refresh)

This sprint was a documentation‑only update.  No new endpoints, migrations or business logic were added.  The README was enhanced to include a comprehensive table of domains and sample endpoints, consolidating information scattered across the OpenAPI spec and module documentation.  Developers should now refer to this section for a high‑level view of the service capabilities.

### Added (2025‑08‑21)

* **Player ammunition API.**  Introduced a new domain for managing per‑player ammunition counts, inspired by the `np‑weapons` resource which stores ammo in the Lua backend【735206341651753†L6-L44】.  Added:
  * `ammoRepository.js` with `getPlayerAmmo` and `updatePlayerAmmo` functions utilising an UPSERT query.
  * `ammo.routes.js` exposing `GET /v1/players/{playerId}/ammo` and `PATCH /v1/players/{playerId}/ammo` for retrieving and updating ammo counts.
  * Migration `015_add_player_ammo.sql` creating the `player_ammo` table keyed by `(player_id, weapon_type)` with an index on `player_id`.
  * Module documentation (`docs/modules/ammo.md`) describing the domain, endpoints and DB schema.
* **Domain endpoints documentation.** Added a Weapons & Ammo section to `BASE_API_DOCUMENTATION.md` summarising the new ammo endpoints.

### Changed (2025‑08‑21)

* Sanitised documentation and route comments to remove explicit references to the original server brand.

* **openapi/api.yaml** – Corrected the websites API definition by moving the POST operation to the `/v1/websites` path and removing the erroneous POST under `/v1/players/{playerId}/ammo`.  Added path documentation for the ammo endpoints.
* **progress‑ledger.md** – Added entries 80–105 recording skip, defer and create decisions for resources from `np‑securityheists` through `outlawalert`.  Notably, it records the creation of the ammo API for `np‑weapons`.
* **index.md** – Appended a new sprint overview for 2025‑08‑21 summarising the ammo API and skip/defer decisions.
* **MANIFEST.md** – Updated to include new files (`ammoRepository.js`, `ammo.routes.js`, migration 015, module doc) and modifications.

### Notes (2025‑08‑21)

This sprint continued the systematic audit of legacy resources.  The vast majority of modules processed (from `np‑securityheists` to `outlawalert`) either contained only client scripts or relayed events without persisting state【644264532347613†L0-L9】【147099589493415†L0-L17】.  These were skipped or deferred.  The notable exception was **np‑weapons**, which keeps ammunition counts in a SQL table and updates them via events【735206341651753†L6-L44】.  To provide equivalent functionality, we created the **player ammunition API** described above.  We also fixed an OpenAPI misplacement for the websites POST endpoint.  No other endpoints or migrations were modified.  Future sprints will address remaining resources such as `pNotify`, `pPassword`, `ped`, `phone`, `police` and others.

### Added (2025‑08‑21 – Part 2)

* **Phone tweets API.** Introduced `phoneRepository.js`, `phone.routes.js` and migration `019_add_tweets.sql` to persist tweets and expose `GET/POST /v1/phone/tweets`.

### Changed (2025‑08‑21 – Part 2)

* **app.js** – Mounted the phone routes.
* **openapi/api.yaml** – Added `Tweet` schemas and path documentation for `/v1/phone/tweets`.
* **Docs** – Updated progress ledger, index and base API documentation; added `docs/modules/phone.md`.

### Notes (2025‑08‑21 – Part 2)

Processed the remaining legacy resources from `pNotify` through `yarn`. All were client‑side or configuration assets except **phone**, which required the tweets API. Other modules were skipped or deferred pending broader subsystems (e.g. jobs, vehicle shops).

### Changed (2025‑08‑22)

* **openapi/api.yaml** – Added `maxLength` constraints to tweet fields and synced specification copy.
* **phone.routes.js** – Removed redundant JSON parser and enforced handle/message length limits.
* **Docs & comments** – Replaced remaining external project references with neutral language across documentation and route comments.

### Notes (2025‑08‑22)

Cleanup pass to remove external branding and tighten validation on the phone tweets API.

### Changed (2025‑08‑23)

* **openapi/api.yaml** – Fixed missing path parameter for `/v1/characters/{id}` and added operationIds/400 responses for phone tweets.
* **docs/modules/phone.md**, **docs/BASE_API_DOCUMENTATION.md** – Documented potential `400 INVALID_INPUT` responses.
* **docs/progress-ledger.md** – Logged OpenAPI spec cleanup entry.

### Notes (2025‑08‑23)

Resolved OpenAPI lint error and clarified phone tweet error handling in documentation.

### Changed (2025-08-22 canonicalization)

* **openapi/api.yaml** – Removed stray security block and aligned with canonical root spec.
* **src/openapi/api.yaml** – Deleted duplicate specification file.
* **src/migrations/019_add_tweets.sql** – Renamed from `018_add_tweets.sql` to resolve migration number collision.
* **src/routes/broadcaster.routes.js** – Cleaned merge artifact and ensured newline.
* **docs/modules/evidence.md** – Resolved merge conflicts.
* **docs/modules/phone.md** – Updated migration reference.
* **MANIFEST.md** – Recorded canonicalization changes.

### Notes (2025-08-22 canonicalization)

Housekeeping pass to deduplicate migration numbers, remove an obsolete OpenAPI copy and fix merge artifacts in documentation and routes. No functional behaviour changed.

### Changed (2025-08-23 broadcaster)

* **openapi/api.yaml** – Documented `/v1/broadcast/attempt` and added `JobAssignment` schema.
* **docs/BASE_API_DOCUMENTATION.md** – Added broadcaster endpoint description.
* **docs/progress-ledger.md** – Removed duplicate `np-evidence` entry.

### Notes (2025-08-23 broadcaster)

Documented broadcaster endpoint in OpenAPI and base API docs; cleaned progress ledger duplication.

### Changed (2025-08-23 broadcaster follow-up)

* **openapi/api.yaml** – Added operationId and error responses for `/v1/broadcast/attempt`.
* **docs/BASE_API_DOCUMENTATION.md** – Clarified broadcaster error cases.
* **docs/modules/broadcaster.md** – Documented response envelope and error codes.
* **MANIFEST.md** – Recorded broadcaster follow-up changes.

### Notes (2025-08-23 broadcaster follow-up)

Expanded broadcaster documentation and OpenAPI to address review feedback.

### Added (2025-08-22 – admin bans)
* **Admin ban persistence.** Introduced `adminRepository`, `admin.routes` changes and migration `020_add_bans.sql` to store bans with optional expiry.

### Changed (2025-08-22 – admin bans)
* **admin.routes.js** – Replaced in-memory store with database persistence and input validation.
* **openapi/api.yaml** – Documented admin ban endpoint with security, response envelope and error cases.
* **docs** – Added `docs/modules/admin.md` and updated base documentation, index and progress ledger.

### Notes (2025-08-22 – admin bans)
Bans now survive service restarts. Rollback by dropping the `bans` table and reverting the route and repository changes.

### Changed (2025-08-23 – evidence schemas)

* **openapi/api.yaml** – Added `EvidenceItem` schemas referenced by evidence endpoints.
* **docs** – Removed merge artifact in base API docs and logged evidence schema fix in index and ledger.

### Notes (2025-08-23 – evidence schemas)

Documentation cleanup to ensure OpenAPI validation passes. No runtime behaviour changes. Rollback by removing the schema definitions and restoring previous documentation versions.

## 2025-08-23 (DiamondBlackjack)

### Added

* Diamond Blackjack module with `/v1/diamond-blackjack/hands` endpoints and `diamond_blackjack_hands` table.

### Risks

* None beyond standard deployment.

### Rollback

* Drop `diamond_blackjack_hands` table and remove related routes and repository.

## 2025-08-23 (InteractSound)

### Added

* Interact Sound module with `/v1/interact-sound/plays` endpoints and `interact_sound_plays` table.

### Risks

* None beyond standard deployment.

### Rollback

* Drop `interact_sound_plays` table and remove related routes and repository.

## 2025-08-24 (LockDoors)

### Added

* Documented existing door APIs in OpenAPI and module docs for the LockDoors resource.

### Risks

* None beyond standard deployment.

### Rollback

* Remove documentation sections related to doors if necessary.
## 2025-08-24 (PolicePack)

### Added

* Evidence custody chain tracking with `/v1/evidence/items/{id}/custody` endpoints and `evidence_chain` table.
* Account-based character selection endpoints and `character_selections` table.

### Risks

* Minimal; ensure migrations run before enabling routes.

### Rollback

* Drop `evidence_chain` and `character_selections` tables and remove related routes and repositories.
## 2025-08-24 (PolyZone)

### Added

* Zones module with `/v1/zones` endpoints and `zones` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `zones` table and remove related routes and repository.

## 2025-08-24 (Wise Audio)

### Added

* Wise Audio module with `/v1/wise-audio/tracks` endpoints and `wise_audio_tracks` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `wise_audio_tracks` table and remove related routes and repository.

## 2025-08-24 (Wise Imports)

### Added

* Wise Imports module with `/v1/wise-imports/orders` endpoints and `wise_import_orders` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `wise_import_orders` table and remove related routes and repository.

## 2025-08-24 (Wise-UC)

### Added

* Wise UC module with `/v1/wise-uc/profiles` endpoints and `wise_uc_profiles` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `wise_uc_profiles` table and remove related routes and repository.

## 2025-08-24 (WiseGuy-Vanilla)

### Changed

* Removed legacy `/v1/characters` and `/v1/characters/{id}` endpoints to enforce account-scoped character APIs.

### Risks

* Clients using legacy endpoints must migrate to account-scoped paths.

### Rollback

* Restore `characters.routes.js`, re-add removed OpenAPI paths, and remount the route in `src/app.js`.

## 2025-08-24 (WiseGuy-Wheels)

### Added

* Wise Wheels module with `/v1/wise-wheels/spins` endpoints and `wise_wheels_spins` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `wise_wheels_spins` table and remove related routes and repository.
## 2025-08-24 (assets)

### Added

* Assets module with `/v1/assets` endpoints and `assets` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `assets` table and remove related routes and repository.
## 2025-08-24 (assets_clothes)

### Added

* Clothes module with `/v1/clothes` endpoints and `clothes` table for character outfits.

### Risks

* None beyond standard migration.

### Rollback

* Drop `clothes` table and remove related routes and repository.
## 2025-08-24 (maps, furnished-shells, hair-pack, mh65c, motel, shoes-pack, yuzler)

### Notes

* Reviewed asset-only resources. No server-side changes required.
## 2025-08-24 (apartments)

### Changed
* Apartment endpoints now accept `characterId` and apartment_residents table converted to `character_id`.

### Migrations
* `032_add_apartment_residents_character_fk.sql`

### Risks
* Existing data must have valid character references; migration copies legacy `player_id`.

### Rollback
* Drop `apartment_residents` foreign key and `character_id` column, restore `player_id`.

## 2025-08-24 (banking)

### Changed
* Economy module with character-scoped bank accounts and transactions. Renamed economy tables to use `character_id`.

### Migrations
* `033_update_economy_character_scoping.sql`

### Risks
* Migration alters existing economy tables; ensure data copy succeeds.

### Rollback
* Recreate `player_id` columns on `accounts` and `transactions` tables and remove banking routes.
## 2025-08-24 (baseevents)

### Added

* Base Events module with `/v1/base-events` endpoints and `base_event_logs` table.

### Risks

* None beyond standard migration.

### Rollback

* Drop `base_event_logs` table and remove related routes and repository.

## 2025‑08‑24

### Added

* **Boatshop module.** Added endpoints `GET /v1/boatshop` and `POST /v1/boatshop/purchase` plus repository and table for boat catalog.

### Changed

* **app.js** – Mounted boatshop routes.
* **openapi/api.yaml** – Added Boat schema and boatshop paths.

### Migrations

* `035_add_boatshop.sql`

### Risks

* Purchases assume client-side balance checks; misuse could allow free boats.

### Rollback

* Remove boatshop routes and drop `boatshop_boats` table.

## 2025-08-24 (bob74_ipl)

### Notes

* Reviewed mapping resource bob74_ipl. No server-side responsibilities; no API changes required.

### Risks

* None.

### Rollback

* No actions needed.

## 2025-08-24 (camera)

### Added

* **Camera module.** Added endpoints `GET /v1/camera/photos/{characterId}`, `POST /v1/camera/photos` and `DELETE /v1/camera/photos/{id}` plus repository and table for photo storage.

### Changed

* **app.js** – Mounted camera routes.
* **openapi/api.yaml** – Added CameraPhoto schemas and paths.

### Migrations

* `036_add_camera_photos.sql`

### Risks

* Photo URLs are stored as provided; ensure upstream validation to avoid malicious content.

### Rollback

* Remove camera routes and drop `camera_photos` table.

## 2025-08-24 (carandplayerhud)

### Added

* HUD module with `/v1/characters/{characterId}/hud` endpoints and `character_hud_preferences` table.

### Migrations

* `037_add_character_hud_preferences.sql`

### Risks

* Preference fields are client-supplied; ensure callers sanitize theme names.

### Rollback

* Remove HUD routes and drop `character_hud_preferences` table.

## 2025-08-24 (carwash)

### Added

* **Carwash module.** Repository, routes and OpenAPI paths to record car washes and track vehicle dirt levels.

### Migrations

* `038_add_carwash.sql`

### Risks

* Dirt updates are client-supplied; ensure callers trust the source.

### Rollback

* Remove carwash routes and drop `carwash_transactions` and `vehicle_cleanliness` tables.

## 2025-08-24 (chat)

### Added

* Chat module with `GET /v1/chat/messages/{characterId}` and `POST /v1/chat/messages` endpoints and persistence.

### Migrations

* `039_add_chat_messages.sql`

### Risks

* Chat messages may contain sensitive content; ensure access controls are enforced.

### Rollback

* Remove chat routes and drop `chat_messages` table.

## 2025-08-24 (connectqueue)

### Added

* Connect queue module with `/v1/connectqueue/priorities` endpoints and priority table.

### Changed

* `app.js` – Mounted connect queue routes.
* `openapi/api.yaml` – Added QueuePriority schemas and paths.

### Migrations

* `040_add_queue_priorities.sql`

### Risks

* Misconfigured priorities could allow unintended access; monitor entries.

### Rollback

* Remove connectqueue routes and drop `queue_priorities` table.

## 2025-08-24 (Cron)

### Added

* Cron module with `GET /v1/cron/jobs` and `POST /v1/cron/jobs` endpoints to persist scheduled tasks.

### Migrations

* `041_add_cron_jobs.sql`

### Risks

* Incorrect schedules could cause missed or duplicate server events.

### Rollback

* Remove cron routes and drop `cron_jobs` table.

## 2025-08-24 – coordsaver module

### Added

* Coordsaver module with `/v1/characters/{characterId}/coords` endpoints for managing saved coordinates.

### Changed

* `app.js` – Mounted coordsaver routes.
* `openapi/api.yaml` – Added Coordinate schemas and paths.

### Migrations

* `041_add_character_coords.sql`

### Risks

* Saved coordinates may expose sensitive locations; monitor usage.

### Rollback

* Remove coordsaver routes and drop `character_coords` table.

## 2025-08-24 – drz_interiors

### Added

* Interiors module with `/v1/apartments/{apartmentId}/interior` endpoints and repository.
* Migration `043_add_interiors.sql` for interior layouts.

### Changed

* Renamed `041_add_cron_jobs.sql` to `042_add_cron_jobs.sql` to resolve numbering conflict.
* `app.js` – mounted interiors routes.
* `openapi/api.yaml` – added Interior schemas and paths.
* Documentation updated for interiors module.

### Migrations

* `042_add_cron_jobs.sql`
* `043_add_interiors.sql`

### Risks

* Large interior templates may increase database storage.
* Only one interior per apartment; concurrent edits may overwrite.

### Rollback

* Drop `interiors` table and remove interiors routes.
## 2025-08-24 – emotes

### Added

* Emotes module with `/v1/characters/{characterId}/emotes` and `/v1/characters/{characterId}/emotes/{emote}` endpoints, repository and docs.
* Migration `044_add_character_emotes.sql` for favorite emotes.

### Changed

* `app.js` – mounted emotes routes.
* `openapi/api.yaml` – added CharacterEmote schemas and paths.
* Documentation updated for emotes module.

### Migrations

* `044_add_character_emotes.sql`

### Risks

* Emote names are user-defined; sanitize input to avoid injection in downstream consumers.

### Rollback

* Drop `character_emotes` table and remove emotes routes.

## 2025-08-25 – emspack

### Added

* EMS module with `/v1/ems/records` and `/v1/ems/shifts` endpoints to log medical records and duty shifts.

### Migrations

* `045_add_ems_shift_logs.sql`

### Risks

* Multiple active shifts could occur if clients bypass the API; server guards only via code checks.

### Rollback

* Remove EMS routes and drop `ems_shift_logs` table.

## 2025-08-25 – es_taxi

### Added

* Taxi module with ride request lifecycle endpoints.

### Migrations

* `046_add_taxi_rides.sql`

### Risks

* Unprocessed requests may accumulate; monitor table size.

### Rollback

* Remove taxi routes and drop `taxi_rides` table.

## 2025-08-25 – furniture

### Added

* Furniture module with character-scoped placement endpoints.

### Migrations

* `047_add_furniture.sql`

### Risks

* Misplaced items could accumulate; monitor table growth.

### Rollback

* Remove furniture routes and drop `furniture` table.

## 2025-08-25 – gabz_mrpd

### Added

* `GET /v1/accounts/{accountId}/characters/selected` endpoint to retrieve the active character for an account.

### Migrations

* None.

### Risks

* If selection records become stale the endpoint may return 404 until clients reselect a character.

### Rollback

* Remove the selected character route and associated documentation updates.

## 2025-08-25 – gabz_pillbox_hospital

### Added

* Hospital admission endpoints: `/v1/hospital/admissions`, `/v1/hospital/admissions/active`, `/v1/hospital/admissions/{id}/discharge`.

### Migrations

* `048_add_hospital_admissions.sql` creates `hospital_admissions` table.

### Risks

* Mismanaged admissions could leave records active indefinitely.

### Rollback

* Drop `hospital_admissions` table and remove hospital routes and documentation.

## 2025-08-25 – garages

### Added

* Garage CRUD and character-scoped vehicle storage endpoints.
* Listing stored vehicles by character.

### Migrations

* `049_add_garage_vehicle_character.sql` adds `character_id` to `garage_vehicles`.

### Risks

* Incorrect character scoping could expose vehicle records to other players.

### Rollback

* Remove garage routes and repository changes.
* Drop `character_id` column from `garage_vehicles`.

## 2025-08-25 – hardcap

### Added

* Hardcap module with `/v1/hardcap/status`, `/v1/hardcap/config` and `/v1/hardcap/sessions` endpoints.

### Migrations

* `050_add_hardcap.sql`

### Risks

* Misreported session counts could block valid connections.

### Rollback

* Drop `hardcap_config` and `hardcap_sessions` tables and remove hardcap routes.

## 2025-08-25 – heli

### Added

* Heli module with `/v1/heli/flights`, `/v1/heli/flights/{id}/end` and `/v1/characters/{characterId}/heli/flights` endpoints.

### Migrations

* `051_add_heli_flights.sql`

### Risks

* Incorrect flight tracking could misrepresent aerial activity.

### Rollback

* Drop `heli_flights` table and remove heli routes.

## 2025-08-25 – import-Pack

### Added

* Import Pack module with `/v1/import-pack/orders/{characterId}`, `/v1/import-pack/orders` and `/v1/import-pack/orders/{id}/deliver` endpoints.

### Migrations

* `052_add_import_pack_orders.sql`

### Risks

* Misdelivery tracking may leave orders in pending state.

### Rollback

* Drop `import_pack_orders` table and remove import pack routes.

## 2025-08-25 – import-Pack2

### Added

* Order pricing, retrieval and cancellation endpoints for import packages.

### Migrations

* `053_add_import_pack_order_price_cancel.sql`

### Risks

* Incomplete cancellation logic may leave orders active if race conditions occur.

### Rollback

* Remove new endpoints and drop `price` and `canceled_at` columns from `import_pack_orders`.

## 2025-08-25 – isPed

### Added

* Ped state endpoints: `/v1/characters/{characterId}/ped` GET and PUT.

### Migrations

* `054_add_character_peds.sql` creates `character_peds` table.

### Risks

* Inconsistent ped data may misrepresent character states if client updates are lost.

### Rollback

* Drop `character_peds` table and remove ped routes and repository.

## 2025-08-25 – k9

### Added

* K9 unit endpoints: `/v1/characters/{characterId}/k9s` GET/POST, `/v1/characters/{characterId}/k9s/{k9Id}/active` PATCH, `/v1/characters/{characterId}/k9s/{k9Id}` DELETE.
* Schema and documentation for managing police dogs per character.

### Migrations

* `057_add_k9_units.sql` creates `k9_units` table.

### Risks

* Mismanaged active flags could allow multiple active K9s per character if clients race.

### Rollback

* Drop `k9_units` table and remove K9 routes and repository.

## 2025-08-25 – jobsystem

### Added

* Jobs module with `/v1/jobs` CRUD and character assignments.
* Broadcaster updates to use character-based assignments.

### Migrations

* `056_add_character_jobs.sql`

### Risks

* Incorrect character scoping could misassign jobs or duty status.

### Rollback

* Drop `character_jobs` table and remove job and broadcaster changes.
## 2025-08-25 – srp-debug

### Added

* Debug status endpoint exposing runtime diagnostics.

### Changed

* Renamed `056_add_k9_units.sql` to `057_add_k9_units.sql` to resolve duplicate migration numbers.

### Migrations

* `057_add_k9_units.sql`

### Risks

* Debug endpoint reveals internal metrics; ensure API token remains secret.

### Rollback

* Remove debug routes and repository and restore original migration filename.

## 2025-08-25

### Added

* Weather forecast endpoints `/v1/world/forecast` with persistence and repository.

### Changed

* Documented existing world state endpoints in OpenAPI.

### Migrations

* `058_add_world_forecast.sql`

### Risks

* Forecast data reveals planned weather; ensure API token and HMAC headers are enforced.

### Rollback

* Drop `world_forecast` table and remove world forecast routes.

## 2025-08-25 – climate-overrides

### Added
* Timecycle override endpoints `/v1/world/timecycle` and repository helpers.

### Migrations
* `059_add_world_timecycle.sql` creates `world_timecycle` table.

### Risks
* Incorrect preset names could cause inconsistent visuals.

### Rollback
* Drop `world_timecycle` table and remove timecycle routes and repository.

## 2025-08-25 – InteractSound hooks

### Added
* WebSocket broadcast and webhook dispatch for sound plays.
* Admin webhook endpoint management `/v1/hooks/endpoints`.

### Changed
* Scheduler drift-correction with retention purge for sound play logs.

### Migrations
* `060_add_world_timecycle.sql` (renamed from `059_add_world_timecycle.sql`).

### Risks
* Misconfigured webhook sinks may accumulate in-memory dead letters.

### Rollback
* Remove hooks routes, dispatcher updates and scheduler task; rename migration back to `059_add_world_timecycle.sql`.

## 2025-08-25 – Police dispatch

### Added
* Dispatch alert endpoints with WebSocket and webhook push.
* Scheduler purge for stale alerts.

### Changed
* Config `DISPATCH_ALERT_RETENTION_MS` for alert retention.

### Migrations
* `061_add_dispatch_alert_index.sql`.

### Risks
* Excessive alert volume may overwhelm clients if not filtered.

### Rollback
* Remove dispatch routes, repository changes and scheduler; drop index `idx_dispatch_alerts_created_at`.

## 2025-02-14 – PolyZone expiration

### Added
* Zone expiration support with optional `expires_at` column and scheduler purge.
* WebSocket and webhook broadcasts for `zone.created` and `zone.deleted`.

### Migrations
* `062_add_zone_expiry.sql`

### Risks
* Misconfigured expiry times could delete active zones.

### Rollback
* Drop `expires_at` column from `zones` and remove zone scheduler/broadcast logic.

## 2025-03-15 – Wise Imports scheduler & delivery

### Added
* Scheduler task to promote pending import orders to `ready` with WebSocket and webhook pushes.
* `POST /v1/wise-imports/orders/{id}/deliver` endpoint to finalize deliveries.

### Migrations
* `063_update_wise_import_orders.sql`

### Risks
* Misconfigured interval may spam readiness events.

### Rollback
* Remove wise imports scheduler registration and delivery route; drop `updated_at` column and status index from `wise_import_orders`.

## 2025-08-25 – Wise Wheels spin expiry

### Added
* Hourly scheduler purges `wise_wheels_spins` older than 30 days and emits `wise-wheels.spin.expired` via WebSocket and webhooks.
* WebSocket/webhook event `wise-wheels.spin.expired` for spin removal.

### Migrations
* `064_add_wise_wheels_created_index.sql`

### Risks
* Incorrect system time or misconfigured retention may delete recent spins.

### Rollback
* Remove scheduler registration, delete `src/tasks/wiseWheels.js`, and drop index `idx_wise_wheels_created`.

## 2025-08-25 – Assets realtime & retention

### Added
* WebSocket and webhook events for asset creation and deletion.
* Hourly `assets-prune` scheduler purges assets older than `ASSET_RETENTION_MS`.
* `ASSET_RETENTION_MS` config for retention window.

### Migrations
* `065_add_assets_created_index.sql`

### Risks
* Misconfigured retention may delete recent assets.

### Rollback
* Remove scheduler registration and event broadcasts; drop index `idx_assets_created_at`.

## 2025-08-25 – Properties module

### Added
* Unified properties API consolidating apartments, garages and rentals.
* WebSocket and webhook events for property create/update/delete.
* Hourly `properties-expire` scheduler releasing leases past `expires_at`.

### Migrations
* `066_add_properties.sql`

### Risks
* Incorrect scheduler interval may release active leases prematurely.

### Rollback
* Remove properties routes and scheduler; drop `properties` table.

## 2025-08-25 – Banking invoices

### Added
* Invoice API with WebSocket and webhook events.
* Hourly `invoice-purge` scheduler removing settled invoices.

### Migrations
* `067_add_invoices.sql`

### Risks
* Incorrect invoice payments may transfer funds unexpectedly.

### Rollback
* Drop `invoices` table and remove invoice routes and scheduler.

## 2025-08-25 – Base events realtime

### Added
* WebSocket broadcast `base-events.logged` on event creation.
* Hourly `base-events-purge` scheduler removes old logs.

### Config
* `BASE_EVENT_RETENTION_MS` controls log retention.

### Risks
* Misconfigured retention may delete recent logs.

### Rollback
* Remove scheduler registration and `BASE_EVENT_RETENTION_MS` config.

## 2025-08-25 – Boatshop realtime

### Added
* Purchase events broadcast via WebSocket and webhooks.
* `boatshop-catalog-broadcast` scheduler pushes catalog every five minutes.

### Risks
* Excessive catalog size may saturate clients.

### Rollback
* Remove boatshop scheduler registration and event broadcasts.

## 2025-08-25 – World IPL states

### Added
* `/v1/world/ipls` endpoints for listing, upserting and removing interior proxy states.
* WebSocket events `world.ipl.updated` and `world.ipl.sync`.
* Scheduler `world-ipl-sync` broadcasts active states.

### Migrations
* `068_add_ipls.sql` creates `ipl_states` table.

### Risks
* Misconfigured IPL names may desync interiors.

### Rollback
* Drop `ipl_states` table and remove IPL scheduler registration.

## 2025-08-26 – Camera realtime

### Added
* WebSocket and webhook events for camera photo creation and deletion.
* Scheduler purges photos older than `CAMERA_RETENTION_MS`.

### Migrations
* `069_add_camera_photos_created_index.sql` adds index on `camera_photos.created_at`.

### Risks
* Misconfigured retention may delete photos prematurely.

### Rollback
* Remove camera scheduler registration and drop index `idx_camera_photos_created_at`.
