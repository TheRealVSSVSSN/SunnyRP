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