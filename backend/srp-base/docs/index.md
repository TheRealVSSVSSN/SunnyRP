# Sprint Overview – 2025‑08‑18

This sprint focused on continuing the migration of original
server-side behaviours into the unified `srp‑base` Node.js service.
The goal is to provide feature parity with the original Lua
resources while conforming to a clean, layered Node.js architecture.

### Highlights

* Added a **broadcaster** module that replicates the behaviour of
  the original `np-broadcaster` resource.  A new REST endpoint
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
additional original resources and documenting the decisions taken.
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
original resources, focusing on modules that appear after
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

In this sprint we continued our methodical march through the original
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

This sprint processed the next set of original resources after
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
the next batch of original resources.  Most were client‑only or
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

In this sprint we reviewed the next batch of original resources after
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

# Sprint Overview – 2025‑08‑19 (Part 8)

This sprint continued processing the next set of original resources in order,
covering `np‑lost` through `np‑notepad`.  Most of these resources contain
client‑only scripts or simple event relays with no persistent data, so they were
**skipped**.  However, the **np‑notepad** resource maintains a `serverNotes`
array on the server and exposes events to add, remove and list notes【136491508201320†L0-L19】.
To provide persistence and allow notes to survive server restarts, we
implemented a new **notes** domain in the SRP API.  The new endpoints allow
clients to create notes with text and world coordinates, list all notes, and
delete notes when they are removed.

### Resources processed

* **np‑lost** – Contains only a client script; no server code to port.
* **np‑memorial** – Client‑side memorial interactions; no backend logic.
* **np‑menu** – UI resource with client‑only code and configuration.
* **np‑news** – Relays `NewsStandCheckFinish` event to clients【675594937447961†L0-L4】; no persistence.
* **np‑newsJob** – Broadcasts light updates via `light:addNews` and `news:removeLight` events【361323525276692†L0-L19】; no persistence.
* **np‑notepad** – Maintains an array of notes and provides events to add, remove and list them【136491508201320†L0-L19】.
  We **created** the Notes API with `/v1/notes` and `/v1/notes/{id}` endpoints.

### What’s new in the API

* Added a **notes** repository with functions to create, delete and list notes in
  the database.
* Added a new migration `012_add_notes.sql` that creates the `notes` table with
  coordinates and timestamp fields.
* Added a **notes** route exposing the following endpoints:
  * `GET /v1/notes` – Lists all notes.
  * `POST /v1/notes` – Creates a new note with text and x,y,z coordinates.
  * `DELETE /v1/notes/{id}` – Deletes an existing note.
* Updated `src/app.js` to mount the new notes routes.
* Extended the OpenAPI specification with `Note` and `NoteCreateRequest` schemas
  and the `/v1/notes` and `/v1/notes/{id}` paths.

The progress ledger has been updated with entries 58‑63 to record the skip or
create decisions for these resources.  The microservice now persists notes
across server restarts, filling a gap in the original Lua implementation.

---

# Sprint Overview – 2025‑08‑20

In this sprint we continued down the original `resources` directory,
processing modules starting from the `np‑o` prefix.  We found that
most of these resources contain only client‑side scripts or visual
effects, and therefore require no backend support.  Two notable
exceptions were **np‑oVehicleMod**, which manages harness durability
and license plate changes, and **np‑secondaryjobs**, which allows
characters to hold a second job.  We extended the API accordingly
and recorded the skip decisions for the remaining modules.

### Highlights

* **Vehicle harness and plate management** – Implemented GET and
  PATCH endpoints (`/v1/vehicles/harness/{plate}`) to retrieve and
  update the harness durability of a vehicle, and a POST endpoint
  (`/v1/vehicles/plate-change`) to change a vehicle’s license plate.
  A new migration (013) adds a `harness` column to the `vehicles`
  table and an index on the `plate` column for efficient lookups.
* **Secondary jobs API** – Added a CRUD API for secondary job
  assignments (`/v1/secondary-jobs`), allowing clients to list,
  create and remove secondary jobs for a player.  Migration 014
  creates the `secondary_jobs` table and indexes it by player ID.

### Resources processed

* **np‑oBinoculars**, **np‑oCam**, **np‑oGasStations**, **np‑oHideFrames**,
  **np‑oPlayerNumbers**, **np‑oRecoil**, **np‑oStress** – purely
  client‑side; skipped.
* **np‑oVehicleMod** – defines events for harness and plate changes
  【562190696785774†L0-L90】; we extended the vehicles API (see
  highlights).
* **np‑particles** – event relays for particle effects【867960581482973†L0-L11】;
  skipped.
* **np‑prison**, **np‑propattach**, **np‑rehab**, **np‑restart** – no
  persistent state; skipped【501607415487925†L0-L17】【998733077849360†L0-L121】.
* **np‑robbery** – complex heist mechanics; deferred.
* **np‑scoreboard** – scoreboard events【201703089677931†L0-L84】;
  skipped.
* **np‑secondaryjobs** – inserts/deletes from `secondary_jobs` table
  【649885668358986†L0-L35】; created secondary jobs API (see highlights).
* **np‑securityheists**, **np‑sirens**, **np‑spikes**, **np‑stash**,
  **np‑stashhouse**, **np‑stripclub**, **np‑stripperbitches**, **np‑taskbar**,
  **np‑taskbarskill**, **np‑taskbarthreat**, **np‑tasknotify**, **np‑taximeter**,
  **np‑thermite**, **np‑tow**, **np‑tuner**, **np‑tunershop**, **np‑vanillaCarTweak**
  – no server logic; skipped.

---

# Sprint Overview – 2025‑08‑21

This sprint processed the next set of original resources starting with `np‑voice` and extending through `outlawalert`.  Most of these modules are either client-only or implement event relays with no persistent state, so they were **skipped**.  The primary new feature introduced is a **player ammunition management API** to reflect the behaviour of the `np‑weapons` resource, which stores ammunition counts on the server.  We also corrected a path placement error in the OpenAPI specification for the websites API.

### Highlights

* **Player ammunition API** – Added GET and PATCH endpoints (`/v1/players/{playerId}/ammo`) that allow clients to retrieve and update a player's ammunition counts per weapon type.  A new `player_ammo` table stores these counts keyed by player ID and weapon type (see migration 015).  The repository uses an upsert query to insert or update ammo rows atomically.  The OpenAPI specification introduces `PlayerAmmo` and `AmmoUpdateRequest` schemas and documents the new path.
* **Website API fix** – Moved the POST definition for creating websites to the correct `/v1/websites` path in the OpenAPI specification and removed the stray insertion under the ammo endpoint.

### Resources processed

* **np‑securityheists** – Simple licence array to prevent duplicate heists; no persistence; skipped.
* **np‑sirens** – Client‑side siren control; skipped.
* **np‑spikes** – Broadcasts spike strip placement/removal events【644264532347613†L0-L9】; skipped.
* **np‑stash** and **np‑stashhouse** – Stash house config written to files【217965367344869†L0-L48】【172428215327821†L0-L8】; skipped.
* **np‑stripclub** and **np‑stripperbitches** – Client animations; skipped.
* **np‑taskbar**, **np‑taskbarskill**, **np‑taskbarthreat**, **np‑tasknotify** – Client‑side UI and minigames; skipped.
* **np‑taximeter** – Event relay for taxi fare updates【147099589493415†L0-L17】; skipped.
* **np‑thermite** – Broadcasts thermite start/stop events【564208794634241†L0-L10】; skipped.
* **np‑tow**, **np‑tuner**, **np‑tunershop**, **np‑vanillaCarTweak** – Metadata or client‑only; skipped【296072965027253†L0-L107】【993976871895598†L0-L4】【731581791128896†L0-L57】.
* **np‑voice** – Sets convars and forwards voice state events【10705249783831†L11-L52】; no database or API; skipped.
* **np‑votesystem** – Complex mayoral pay and gang/weed management【121521488790210†L35-L168】; deferred to a future sprint due to scope.
* **np‑warrants** – No server script; skipped.
* **np‑weapons** – Stores ammo counts via events and a MySQL table【735206341651753†L6-L44】.  We **created** a player ammunition API with repository, routes and migration (see highlights).
* **np‑webpages** – Empty server script; skipped.
* **np‑whitelist** – Manages connection queue priority and job whitelists【360360555555541†L14-L107】; deferred for a dedicated queue/permissions sprint.
* **np‑xhair**, **nui_blocker**, **outlawalert** – Client‑side overlays or static data【499166097351950†L0-L26】【895876963551968†L0-L120】; skipped.

The progress ledger now includes rows 80–105 reflecting these decisions and the creation of the ammunition API.  With this sprint complete, the remaining resources to process begin with `pNotify`, `pPassword`, `ped`, `phone`, `police` and beyond.  We will continue to scan and port server behaviours in order while adhering to the Node.js microservice guidelines.

The progress ledger has been updated with rows 64‑79 summarising
these decisions.  Future sprints will continue with `np‑voice`,
`np‑votesystem`, `np‑warrants`, `np‑weapons`, `np‑webpages`,
`np‑whitelist` and beyond, adding backend support only where
persistent state or cross‑player interactions are required.