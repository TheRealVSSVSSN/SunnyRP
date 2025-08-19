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

# Sprint Overview – 2025‑08‑19

This sprint emphasised documentation and compliance rather than
feature development.  We researched Node.js architecture best
practices and compiled a **Framework Compliance Rubric**, then
audited the existing `srp‑base` implementation against it.  A new
document (`framework‑compliance.md`) summarises these findings and
identifies remaining gaps.

We resumed processing NoPixel resources in alphabetical order.  The
following resources were examined:

* **np‑errorlog** – registers an `error` server event and forwards
  error details to Discord via HTTP【608897531749594†L0-L23】.  Since
  our backend already exposes a comprehensive error logging API and
  database persistence, no additional work was required.  The
  resource was **skipped**.
* **LockDoors** – contains client‑side logic for locking doors but no
  server script.  It was **skipped**.
* **np‑density** – handles `np:peds:rogue` events and broadcasts
  deletion instructions to all clients【14920766739437†L0-L4】.  As there is no
  persistent server state involved, we chose to **skip** it in this
  sprint.

As a result of these decisions, no new routes or repositories were
added to `srp‑base` this sprint.  Documentation has been updated to
reflect our progress and to capture the framework compliance rubric.
For details see `framework‑compliance.md` and the updated
`progress‑ledger.md`.