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

# Sprint Overview – 2025‑08‑19 (Part 5)

In this sprint we continued our methodical march through the NoPixel
resources directory.  After handling driving schools and tests in the
previous sprint, the next group of resources mostly contained
client‑only features or simple event relays.  However, the **weed
farming** logic embedded in the `np‑gangs` resource defined
server‑side persistence for cannabis plants.  We ported this
behaviour into the `srp‑base` service by introducing a new
**weed plants** domain.

### Highlights

* **Weed plants API** – Created a REST interface for managing
  cannabis crops.  Weed plants are stored in a new
  `weed_plants` table (migration 010) with JSON coordinates, seed
  identifier, owner ID and growth value.  The API exposes:
    * `GET /v1/weed-plants` to list all plants.
    * `POST /v1/weed-plants` to create a new plant.  The request
      body accepts `coords` (object with x/y/z), `seed` and
      `ownerId`.
    * `PATCH /v1/weed-plants/{id}` to update a plant’s growth value.
    * `DELETE /v1/weed-plants/{id}` to remove a plant.
* Added **weed plants repository** and **routes**; mounted the
  router in `app.js`.  Updated the OpenAPI specification with
  `WeedPlant` schema and the new paths.
* Added migration **010_add_weed_plants.sql** to create the
  `weed_plants` table with an index on `owner_id` for efficient
  queries.

### Resources processed

* **np‑firedepartment** – Contains only event relays for door and
  particle effects【349291604510523†L0-L13】.  No persistence; skipped.
* **np‑fish** – Client-only resource for fishing minigame; skipped.
* **np‑furniture** – UI and object lists for furniture placement;
  no server code; skipped.
* **np‑fx** – Visual effects resource; client-only; skipped.
* **np‑gangs** – Contains a weed farming system that inserts,
  deletes and updates `weed_plants` rows via MySQL
  【366444498392161†L9-L33】.  We **extended** the API to support
  this persistence (see highlights).
* **np‑gangweapons** – Only registers a money check event and
  displays a client menu【403321870441425†L1-L4】.  No persistence;
  skipped.
* **np‑golf** – Empty server script【981050033116644†L0-L0】;
  skipped.
* **np‑gunmeta**, **np‑gunmetaDLC**, **np‑gunmetas** – Contain only
  `.meta` files for weapon definitions; no server code; skipped.

The progress ledger has been updated accordingly, and the new
documentation covers the weed plants domain.  Upcoming sprints will
examine further resources such as **np‑gurgle** and **np‑heatmap**,
porting backend behaviour only when persistence or multi‑player
interaction is required.

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

---

# Sprint Overview – 2025‑08‑19 (Part 6)

After completing the weed plants integration, we turned our attention to
the next batch of NoPixel resources.  Most were client‑only or
implemented purely cosmetic features, but two stood out: **np‑gurgle**
and **np‑hospitalization**.  The former provides a phone app for
purchasing personal websites, while the latter updates patient
records and triage state in a medical system.  In this sprint we
implemented the backend support for Gurgle and deferred the hospital
module for a future EMS sprint.

### Highlights

* **Websites API** – Implemented a new REST interface for the
  Gurgle app.  Players can purchase websites for a fixed fee ($500)
  and retrieve their owned sites:
    * `GET /v1/websites` lists all websites, or filters by
      `ownerId` when provided.
    * `POST /v1/websites` creates a new website.  The API charges
      the player and stores the website in the `websites` table.
  The service uses the existing economy repository to withdraw funds
  and records websites via a new repository and migration.  A
  `Website` schema and `WebsiteCreateRequest` schema were added to
  the OpenAPI specification.
* Added a **websites repository** for database operations and
  a **migration (011)** creating the `websites` table with indexes
  on `owner_id`.
* Mounted the websites routes in `app.js` and updated the
  OpenAPI spec accordingly.

### Resources processed

* **np‑gurgle** – Contains server logic for purchasing and listing
  websites【73746484563419†L0-L48】.  We ported this behaviour into
  the Websites API as described above.
* **np‑gym** – Client‑only gym actions; skipped.
* **np‑heatmap** – Client‑side heatmap display; skipped.
* **np‑hospitalization** – Updates the `hospital_patients` table and
  toggles triage state【491902441918069†L0-L37】.  Implementing this
  requires an EMS/patient module; deferred to a future sprint.
* **np‑hunting** – Client‑only hunting mini‑game; skipped.

With these additions the microservice continues to achieve parity
with important server behaviours while deferring modules that need
a more robust job/healthcare infrastructure.  The progress ledger
records the skip/defer decisions and the new module.
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

---

# Sprint Overview – 2025‑08‑19 (Part 7)

In this sprint we reviewed the next batch of NoPixel resources after
`np‑hunting`.  The majority of these modules are purely client‑side
or implement simple event relays that do not require any persistence
or interplayer coordination.  Consequently, we **skipped** them.  The
`np‑jobmanager` resource, which manages job whitelisting and
assignments, was deferred until our jobs and permissions systems are
in place.

### Resources processed

* **np‑infinity** – Relays players’ coordinates via `np:infinity:player:ready` and
  `np:infinity:entity:coords` events【569396379702026†L0-L12】; no persistent data to store.
* **np‑interior** – Contains only client scripts managing interior loading【894325454073906†L0-L55】.
* **np‑inventory** – Contains the legacy Lua inventory system【108768342973504†L0-L131】; our
  microservice-based inventory already supersedes it.
* **np‑jewelrob** – Defines robbery events but does not store any data【564860878882183†L0-L35】.
* **np‑jobmanager** – Implements job whitelisting and job assignment in Lua, using database
  queries【769332134670781†L0-L43】; deferred to a jobs/permissions sprint.
* **np‑keypad** – Client-only keypad interactions【237659149565814†L0-L81】.
* **np‑keys** – Simple event to hand over keys【53794332482796†L0-L3】.
* **np‑lockpicking** – Client-only lockpicking mini-game【680002010711533†L56-L76】.
* **np‑lootsystem** – Gives random items when players use loot; no backend state【827029519194534†L0-L66】.
* **np‑login** – Drops players via `np-login:disconnectPlayer` event【57298370178638†L0-L4】.

No new endpoints, migrations or repositories were added in this part.  The progress
ledger records these skip and defer decisions.  Future sprints will resume with
`np-phone`, `np-police`, `np-polyzone` and other remaining resources.