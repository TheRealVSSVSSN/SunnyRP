# Manifest – Sprint 2025‑08‑19

This manifest summarises the files added or modified in this sprint
for the `srp‑base` Node.js service.  Only files that changed are
listed here.  Files not mentioned were left untouched.

| Path | Status | Notes |
|---|---|---|
| `src/repositories/jobsRepository.js` | M | Added `countPlayersForJob` and `getJobByName` helpers to support the broadcaster module. |
| `src/routes/broadcaster.routes.js` | A | New route for assigning the broadcaster job while enforcing a maximum number of concurrent broadcasters. |
| `src/app.js` | M | Mounted the new broadcaster route. |
| `DOCS/progress-ledger.md` | A | Progress log for processed NoPixel resources and decisions. |
| `DOCS/index.md` | A | Sprint overview summarising tasks and outcomes. |
| `DOCS/modules/broadcaster.md` | A | Per‑module documentation describing the broadcaster API. |

| `DOCS/framework-compliance.md` | A | Added framework compliance rubric and evaluation for the Node.js service. |
| `DOCS/progress-ledger.md` | M | Added entries for `np‑errorlog`, `LockDoors` and `np‑density`. |
| `DOCS/index.md` | M | Added sprint 2025‑08‑19 overview and summary. |

Legend: **A** = Added, **M** = Modified.

# Additional updates for the second part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `DOCS/progress-ledger.md` | M | Added entries for koilWeatherSync, mapmanager, chat, cron, minimap, np‑admin, np‑barriers and deferred np‑base. |
| `DOCS/index.md` | M | Added second part of the sprint overview summarising additional skip decisions. |