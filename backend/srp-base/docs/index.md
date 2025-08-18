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