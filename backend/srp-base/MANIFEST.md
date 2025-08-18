# Manifest – Sprint 2025‑08‑18

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

Legend: **A** = Added, **M** = Modified.