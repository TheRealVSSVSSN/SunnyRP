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

This sprint continues the integration of NoPixel server behaviours into
the unified `srp‑base` Node.js backend.  The broadcaster module
implements the server-side logic of the NoPixel `np-broadcaster`
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
NoPixel resources.  The following resources were reviewed:

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

In this sprint we examined another batch of NoPixel resources.
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