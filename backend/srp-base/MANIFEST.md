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

# Additional updates for the third part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/contractsRepository.js` | A | New repository for persisting and retrieving player contracts. |
| `src/routes/contracts.routes.js` | A | New route exposing `/v1/contracts` CRUD operations (list, create, accept, decline). |
| `src/migrations/008_add_contracts.sql` | A | Migration creating the `contracts` table with sender_id, receiver_id, amount, info, status and timestamps. |
| `src/app.js` | M | Mounted the contracts router alongside existing domain routes. |
| `openapi/api.yaml` | M | Added a `Contract` schema and paths for `/v1/contracts` and its subresources. |
| `DOCS/progress-ledger.md` | M | Added entries for np‑camera, np‑cid, np‑contracts, np‑dances, np‑dealer and np‑dirtymoney. |
| `DOCS/index.md` | M | Added third part of sprint overview summarising contracts implementation and additional skip decisions. |

# Additional updates for the fourth part of the 2025‑08‑19 sprint

| Path | Status | Notes |
|---|---|---|
| `src/repositories/drivingTestsRepository.js` | A | New repository for creating and retrieving driving test records.
| `src/routes/drivingTests.routes.js` | A | New routes exposing `/v1/driving-tests` (list & create) and `/v1/driving-tests/{id}` (retrieve) endpoints.
| `src/routes/driftschool.routes.js` | A | New route to handle drift school payments via `/v1/driftschool/pay`.
| `src/migrations/009_add_driving_tests.sql` | A | Migration creating the `driving_tests` table with appropriate indexes and columns.
| `src/app.js` | M | Mounted the driving tests and drift school routers.
| `openapi/api.yaml` | M | Added `DrivingTest` and `DriftSchoolPayment` schemas and new paths for driving tests and drift school payment.
| `DOCS/progress-ledger.md` | M | Added entries for `np-driftschool`, `np-driving-instructor` and `np-drugdeliveries`.
| `DOCS/index.md` | M | Added fourth part of sprint overview detailing driving tests and drift school features.