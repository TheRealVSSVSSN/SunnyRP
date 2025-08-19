# Sprint Overview – 2025‑08‑18

This sprint focused on continuing the migration of NoPixel
server-side behaviours into the unified `srp‑base` Node.js service.
The goal is to provide feature parity with the original Lua
resources while conforming to a clean, layered Node.js architecture.

### Highlights

* Added a **broadcaster** module that replicates the behaviour of
  the NoPixel `np-broadcaster` resource.  A new REST endpoint
  (`POST /v1/broadcast/attempt`) assigns the `broadcaster` job to
  a player while enforcing a configurable maximum number of
  broadcasters.
* Extended the **jobs repository** with helper functions to count
  current job assignments and look up jobs by name, supporting
  generic role‑based features.
* Updated the application bootstrap to mount the new broadcaster route.

For a full list of processed resources and their decisions, see
`progress‑ledger.md`.  For details on the broadcaster module, see
`modules/broadcaster.md`.

---

# Sprint Overview – 2025‑08‑19 (Part 2)

This continuation of the 2025‑08‑19 sprint focused on processing
additional NoPixel resources and documenting the decisions taken.
Following the earlier documentation and compliance effort, we
examined a further set of resources in the order listed by
GitHub.  Because most of these resources either contain only
client‑side logic or provide game framework functions that are not
appropriate for the external API, they were **skipped**.  A summary
of each decision is recorded in the progress ledger.

Resources reviewed in this part:

* **koilWeatherSync** – defines events to synchronise weather and
  time (`kGetWeather`, `kTimeSync`, `kWeatherSync`, etc.) and a
  command `syncallweather`【864410210965398†L23-L33】【864410210965398†L36-L40】.
  We already provide REST endpoints for world state (time and
  weather), so no server API changes were needed.  **Skipped**.
* **mapmanager** – manages maps and gametypes using resource
  metadata and events such as `onResourceStart` and `onResourceStop`
  【32727640578048†L6-L41】【32727640578048†L107-L167】.  This logic is
  internal to FiveM and not relevant to the microservice.  **Skipped**.
* **chat** – handles chat messaging and command suggestions via
  events (`_chat:messageEntered`, `chat:init`, etc.)【147364517015620†L0-L23】.
  Chat has no persistence requirements; our API does not need to
  expose it.  **Skipped**.
* **cron** – simple Lua cron scheduler to run callbacks at
  specified times【438652072574188†L0-L48】.  Since Node.js has rich
  scheduling libraries and this behaviour belongs in the game
  runtime, we decided to skip adding any new API.  **Skipped**.
* **minimap** – contains only a client script; no server logic
  required.  **Skipped**.
* **np‑admin** – large administrative system for player management
  including kicks, brings, noclip toggles, etc.【739259918442198†L8-L36】.
  Implementing this would require a more complete job/permissions
  framework; for this sprint we deferred it.  **Skipped**.
* **np‑barriers** – client‑only resource for placing barriers.  **Skipped**.
* **np‑base** – a comprehensive framework containing many
  subsystems (blip manager, core modules, database access,
  inventory, etc.).  Porting this will require a deep integration
  effort and is deferred for future sprints.  **Deferred**.

No new code or migrations were required for this part.  The
documentation has been updated to reflect the decisions and to
ensure the progress ledger is current.

---

# Sprint Overview – 2025‑08‑19 (Part 3)

In this follow‑on sprint we continued our systematic audit of the
NoPixel resources, focusing on modules that appear after
`np‑base` in the GitHub ordering.  Most resources examined
contained only client scripts and therefore required no backend
support.  However, the **np‑contracts** resource contained server
logic for creating and accepting contracts between players.  To
support this functionality in our Node.js API we introduced a
new **contracts** domain with routes, repository and migration.

### Highlights

* **Contracts API** – implemented a set of REST endpoints for
  creating, listing, accepting and declining player contracts.  A
  contract records the sender, receiver, amount and info.  When
  accepted, the API withdraws the funds from the receiver’s
  account and deposits them into the sender’s account, then marks
  the contract as paid and accepted.  A new `contracts` table was
  added via migration 008 to persist these records.
* Updated **app.js** to mount the contracts router and added a
  `Contract` schema definition in the OpenAPI spec.

### Resources processed

* **np‑camera** – contains only a client script; skipped.
* **np‑cid** – registers an event to generate ID cards【836458714788436†L0-L12】; skipped pending a full inventory system.
* **np‑contracts** – implements server events to send and accept
  contracts【400719268596618†L10-L20】.  We created the contracts
  API and migration.
* **np‑dances** – client‑only emote resource; skipped.
* **np‑dealer** – client‑only vendor UI; skipped.
* **np‑dirtymoney** – defines events to drop and convert dirty
  money【414013350686833†L0-L15】; skipped for now because the
  economy system requires a dedicated sprint.

The progress ledger has been updated to reflect these decisions
and the new module.  Future sprints will continue down the
resource list, porting server behaviours only when they involve
persistence or cross‑player interactions.

---

# Sprint Overview – 2025‑08‑19 (Part 4)

This sprint processed the next set of NoPixel resources after
`np‑dirtymoney` in the repository ordering.  We identified two
resources that required backend support: **np‑driftschool** and
**np‑driving‑instructor**.  Each defines server events that
interact with player finances and store driving test results in a
database.  We ported their behaviour into the `srp‑base` API and
skipped the unrelated `np‑drugdeliveries` resource.

### Highlights

* **Drift school payment** – added a new `/v1/driftschool/pay` endpoint
  allowing clients to withdraw funds from a player's account to pay
  for drift school participation.  The endpoint validates the
  player ID and amount, checks the player's balance, and returns
  the updated balance on success.
* **Driving tests API** – implemented a complete CRUD interface
  for driving tests.  A new `driving_tests` table (migration 009)
  stores test records including student CID, instructor CID,
  instructor name, timestamp, score, pass/fail status and a JSON
  results payload.  The API exposes:
    * `POST /v1/driving-tests` to record a new driving test.
    * `GET /v1/driving-tests?cid=123` to list recent tests for a
      player (default limit 5).
    * `GET /v1/driving-tests/{id}` to retrieve a specific test.
* Updated the **OpenAPI specification** with `DrivingTest` and
  `DriftSchoolPayment` schemas and new path definitions.
* Added repository and routes for driving tests and drift school,
  mounted them in `app.js`.
* Extended the progress ledger to include decisions for
  `np-driftschool`, `np-driving-instructor` (create) and
  `np-drugdeliveries` (skip).

### Resources processed

* **np‑driftschool** – handles a `takemoney` event to deduct cash
  for drift school participation【761714451400029†L0-L11】.  We
  created a REST endpoint to perform the same withdrawal from the
  player's account.
* **np‑driving‑instructor** – manages driving test submissions,
  history retrieval and reports【393162189931023†L0-L45】.  We added
  driving tests endpoints and a persistent table to store test
  results.
* **np‑drugdeliveries** – orchestrates drug deliveries and chop
  shop lists with timers and random generation【896869969423342†L0-L93】.
  This functionality is outside the scope of the external API and
  has been deferred.  A future jobs/vehicles sprint can revisit
  this domain.