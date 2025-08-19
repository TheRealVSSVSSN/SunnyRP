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