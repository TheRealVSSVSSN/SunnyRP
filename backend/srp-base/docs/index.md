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