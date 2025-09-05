# SRP Suite Microservice Builder — `agents.md` (Codex-Optimized, **Code-First Fresh Scan**, Evidence-Only, Zero-TODO)

**Purpose:** Operational handbook for the agent that consumes the **Unified Microservice Builder prompt** and turns it into concrete, consistent changes inside `backend/<Microservice>`.

**Scope:** Work **only** in `backend/<Microservice>` for the current run. Never touch `resources/*` or any `fxmanifest.lua`.

**Compatibility:** Everything you build must remain **compatible with `srp-base`** (HTTP/WS shapes, headers, and multi-character APIs), even if the target microservice is not `srp-base`.

> **Hard Rule 0 — Code-First Gap Verification (Every Run).** A “no gaps” claim in any docs/logs is **non-authoritative**. On **every** run you **must** freshly scan:
> 1) all declared **and discovered** resource code, and  
> 2) our own `backend/<Microservice>` code,  
> then derive gaps strictly from **code signals**. Do not short-circuit based on prior docs/logs.

> **Hard Rule 1 — Evidence-Only.** Do **not** invent features or gaps. Open gaps only when concrete signals in the code imply a backend counterpart that is missing or partial in `backend/<Microservice>`.

---

## 0) Parameter Guards & Normalization (pre-flight)

Validate and normalize prompt parameters before doing anything:

- `Reset Ledger` → boolean only.
- `Microservice` → **string**. If an array is provided (e.g., `["srp-base"]`), take the first element.
- `Target Platforms` → subset of `{"FiveM","RedM"}`; default `["FiveM"]` if omitted.
- `Primary Domains` → non-empty array of domain keys (e.g., `["base"]`).
- `Main Framework.repo` and `Other Frameworks[].repo` → treat as local checkout identifiers (do not fetch). If missing locally, continue best-effort.
- `paths[]` must be **repo-relative** (e.g., `"resources/base"`), not GitHub UI paths (❌ `/tree/master/resources`). If a UI path is provided, **normalize** to repo-relative (`"resources"`).
- **De-dupe** all repos/paths; preserve order.

If validation fails and cannot be auto-fixed (array→string, UI→repo-relative), log once:
`Parameter normalization failed for <field>; proceeding with best-effort defaults.`

---

## 1) Prompt semantics

- **Reset Ledger**
  - `true`: start fresh run docs; truncate `docs/progress-ledger.md` and `docs/index.md` scaffolds; preserve `CHANGELOG.md`.
  - `false`: append to existing docs; preserve history.

- **Microservice**
  - Operate under `backend/<Microservice>`. If absent, create the standard scaffold (see §6).

- **Target Platforms**
  - `FiveM`, `RedM`, or both. When `RedM` present, enable RedM toggles; HTTP/WS contracts remain identical.

- **Primary Domains**
  - Use as anchors for clustering (§4).

- **Main/Other Frameworks & Resource Sources**
  - Use as **evidence sources** (events, RPCs, loops, persistence). **Never copy code.**

- **Feature Priorities**
  - `performance: "maximize"` → migrate evidenced loops to scheduler, push via WS/webhooks, avoid N+1, add indexes, batch I/O.
  - `maintainability: "maximize"` → SRP naming, repository pattern, clear docs.
  - `parity_targets` are advisory; never open gaps from parity alone.

---

## 2) Code-First Coverage & Gap-Closure (ENFORCED)

**Goal:** Freshly traverse the **resource code** and our **backend code** each run; extract **signals**; emit a **coverage map**; derive **evidence-backed** gaps; then close them end-to-end — **no placeholders, no TODOs**.

### Authoritative Source Order (must follow)
1) **Code** (resources + `backend/<Microservice>`) — **always** scanned fresh each run.  
2) **Manifests/Migrations** (`fxmanifest.lua`, `.sql`).  
3) **Docs/logs** — advisory only; never a reason to claim “no gaps”.

### 2.1 Traversal (resource + backend)
- **External scan (resources):** Declared + discovered paths; file globs **.lua, .js, .ts, .json, .sql, .yml, .yaml, .md** (exclude `node_modules`, `.git`, `dist/build`). Missing declared paths → `MISSING` with a concrete reason; attempt liftover discovery (fxmanifest siblings, common renames).
- **Internal scan (backend):** `backend/<Microservice>` for **.js/.ts/.sql/.json/.yml/.yaml** to build a map of **implemented capabilities**.
- **No short-circuit:** Perform both scans even if docs/logs claim “no gaps”.

### 2.2 Signal Extraction (names/flows only; never copy upstream code)
- Events: `RegisterNetEvent`, `TriggerEvent`, `TriggerClientEvent`, `AddEventHandler`
- RPC/Callbacks: `RPC.register|execute`, `exports("...")`, `Callbacks:Server`, `lib.callback.register|await`, NUI message patterns
- Loops: `Citizen.CreateThread`, `SetTimeout`, `while true do`
- Persistence: `.sql` tables, migrations, JSON stores
- Identity/session/queue/whitelist/login/scoreboard/voice/infinity/spawn hand-offs
- Telemetry: logger hooks, rconlog, restart, cron
- World/UX: PolyZone, map/minimap, barriers, weather sync, chat/taskbar/taskbarskill/taskbarthreat/notify/votesystem

### 2.3 Coverage Map (MUST EMIT)
Create **`docs/coverage-map.md`** with:

**A. Summary Table**  
| repo | path | files | events | rpcs | loops | persistence | cluster | status | backend_impl_found | doc_no_gap_claim? |
|------|------|-------|--------|------|-------|-------------|---------|--------|--------------------|-------------------|

Statuses: `SCANNED`, `MISSING`, `DISCOVERED`, `BLOCKED`.

**B. Notes & Mapping** — Per-path notes; **Source → SRP module(s)** matrix; **liftover mapping** (declared → discovered).

### 2.4 Gap Mapping (Evidence tests)
Open a gap **only if both** hold:
- **E1 (Local Evidence):** Specific code signals from §2.2 exist in the resources.
- **E2 (Missing/Partial Backend):** The counterpart is missing or partial in `backend/<Microservice>`.

Classify: **SKIP** (present), **EXTEND** (partial), **CREATE** (missing vertical slice: router + repo + migration + realtime + validation + docs).  
Do **not** open parity/wishlist items.

### 2.5 Execution Order + Anti-Repeat Fair Queue

**Order:** dependencies → performance wins → player-visible value.  
Implement each item **end-to-end** (routes → repositories → idempotent migrations → WS/webhooks → runtime validation → docs).  
Migrate polling loops to **Scheduler** only where such loops are evidenced.

**Fair Queue (no tunneling):**
- Global TODO list entries: `{domain, path, type, deps, weight, evidence_refs}`.
- Round-robin across `(domain, path)` buckets with:
  - `max_consecutive_per_bucket = 1`
  - `cooldown_span = 2`
- Dependencies may force minimal reordering; resume round-robin immediately after.
- Do not re-open closed items; add new ones only if **missed in initial traversal** or from the **DISCOVERED** set.
- **Stop:** all evidence-backed `CREATE/EXTEND` closed; only `SKIP` remain.

### 2.6 Zero-TODO (HARD)
- No `TODO|FIXME|TBD|TBA` in code or docs.
- If externally blocked, list the precise blocker in `docs/gap-closure-report.md` (no stubs in code).

---

## 3) SRP-BASE Compatibility (MANDATORY)

### 3.1 HTTP endpoints
- `GET /v1/health` → `{ status: "ok", service, time }`
- `GET /v1/ready`  → `{ ready: true|false, deps: [...] }`
- `GET /v1/info`   → `{ service, version, compat: { baseline: "srp-base" } }`

### 3.2 Multi-character APIs
- `GET /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters/{characterId}:select`
- `DELETE /v1/accounts/{accountId}/characters/{characterId}`
Scope gameplay state by **active character** post-selection.

### 3.3 WebSocket handshake & envelope
- Handshake accepts: `sid`, `accountId`, `characterId?`
- Envelope (CloudEvents-like):
```json
{ "id":"evt_<uuid>", "type":"srp.<domain>.<action>", "source":"<Microservice>", "subject":"<characterId|accountId|entityId|*>", "time":"<ISO-8601>", "specversion":"1.0", "data":{} }
```

---

## 4) Domain Clustering (use only where evidenced)

For `Primary Domains: ["base"]`, capability buckets:
- **sessions** — allowlist/login/session lifecycle/spawn/cid
- **queue** — connection queue/hardcap
- **voice** — voip/broadcaster
- **telemetry** — log/errorlog/rconlog/restart/cron
- **ux** — chat/taskbar/taskbarskill/taskbarthreat/notify/scoreboard/votesystem
- **world** — zones/map/minimap/barriers/weather sync
- **jobs** — jobsystem/secondaryjobs
- **tooling** — build chain (names/flows only)

Consolidate overlaps into **SRP-named** modules where evidence exists. Temporary aliases only if essential (mark **deprecated** in docs).

---

## 5) Implementation Principles

- **Express-first**, single app via `http.createServer(app)`.
- Middleware: `requestId` → JSON parser → CORS → **rateLimit** → **HMAC/Auth** → **Idempotency** → **Runtime validation** (Zod/Joi/AJV) → error handler.
- Routers per domain under `/v1/<domain>`.
- **OpenAPI deferred**: document contracts in `docs/BASE_API_DOCUMENTATION.md`; do not write OpenAPI files.
- **WS Gateway:** `/ws/<domain>`, heartbeat, backpressure, exp-backoff reconnect, message dedupe by id.
- **Webhooks:** HMAC signing, retries (exp-backoff + jitter), dead-letter logs; Discord sink scaffold disabled by default.
- **Scheduler:** `src/bootstrap/scheduler.js` with drift correction + persisted cursors; register tasks **only** for evidenced loops.
- **Persistence:** repository pattern; forward-only idempotent migrations with indexes/FKs; avoid N+1; paginate; small TTL caches.

---

## 6) Directory Layout (create if missing)

```
backend/<Microservice>/
  src/
    app.js
    server.js                 # export createHttpServer({ env }) → { app, httpServer, io? }
    middleware/
      requestId.js
      rateLimit.js
      hmacAuth.js
      idempotency.js
      validate.js
      errorHandler.js
    realtime/
      websocket.js
    hooks/
      dispatcher.js
    bootstrap/
      scheduler.js
    routes/
      <domain>.routes.js
    repositories/
      <domain>Repository.js
  src/migrations/
    001_init.sql
  docs/
    index.md
    progress-ledger.md
    framework-compliance.md
    run-docs.md
    research-log.md
    research-summary.md
    naming-map.md
    admin-ops.md
    BASE_API_DOCUMENTATION.md
    events-and-rpcs.md
    db-schema.md
    migrations.md
    security.md
    testing.md
    coverage-map.md          # REQUIRED
    gap-closure-report.md    # REQUIRED
  CHANGELOG.md
  MANIFEST.md
```

---

## 7) Git & PR Behavior

- Detect default branch (origin HEAD → current → prefer `main`, else `master`, else single remote).
- Working branch: `codex/<Microservice>-gap-<YYYYMMDD-HHmm-AZ>` (reuse if exists).
- Stage **only** changes under `backend/<Microservice>/`.
- Commit title: `<Microservice>(<domains>): cluster consolidation + ws/webhooks + scheduler + express`.
- Create one PR per run. If push is denied by platform, skip push but still emit deliverables.

---

## 8) Auto-Repairs & No-Ops

- Duplicate migrations → renumber later duplicate prefix to next free number (preserve zero-padding); keep idempotent.
- Merge markers → replace any `<<<<<<<`/`=======`/`>>>>>>>` with resolved content.
- No tests/lint placeholders unless required by changed files.
- No base64/zip outputs.
- OpenAPI: do **not** create/edit/remove any OpenAPI files.

If nothing changes after **fresh code traversal**, print exactly:
`No changes required this run.`

---

## 9) Documentation Duties

- If `Reset Ledger = true`, re-init `docs/index.md` and `docs/progress-ledger.md`.
- Update/create (changed docs only; print full contents):
  - `docs/run-docs.md` — narrative of this run
  - `docs/framework-compliance.md` — SRP-BASE compatibility & deviations
  - `docs/research-log.md` — titles/paths only (no code)
  - `docs/research-summary.md` — distilled findings
  - `docs/naming-map.md` — upstream term → SRP term
  - `docs/coverage-map.md` — **REQUIRED**: include `backend_impl_found` + `doc_no_gap_claim?` flags
  - `docs/gap-closure-report.md` — **REQUIRED**: only evidence-backed EXTEND/CREATE items; precise external blockers if any
  - Module docs under `docs/modules/` as needed

---

## 10) Deliverables (stdout format)

1) **DIFF SUMMARY** (A/M/D/R lines under `backend/<Microservice>/`).  
2) **PATCHES** (full contents per changed/new file):
```
=== FILE: backend/<Microservice>/<path> (A|M|R) ===
<entire final file>
```
*Do not* print deleted file contents; list them as `D` in the diff.

3) **MANIFEST.md** (full): summary bullets; A/M/D/R table; startup/env; compatibility aliases if any.  
4) **CHANGELOG.md**: append new entry (print it in full).  
5) **SQL migrations**: print full content for each new/changed file under `src/migrations/`.  
6) **Docs Pack**: full contents for changed docs only.  
7) **Completion line**:
- Success: `DONE — <Microservice> microservice baseline complete.`
- No-op: `No changes required this run.`

---

## 11) Quality Gates (HARD FAIL)

- Fresh external + internal traversal artifacts exist and are reflected in `docs/coverage-map.md`.
- `docs/gap-closure-report.md` exists; every EXTEND/CREATE item is **evidence-backed** (E1/E2) with implemented artifacts and locations.
- Zero-TODO: no `TODO|FIXME|TBD|TBA` anywhere in code or docs.
- Mandatory `health|ready|info` endpoints present.
- Runtime validators on all mutating endpoints (OpenAPI deferred).
- Migrations idempotent; indexes/FKs; no unsafe destructive ops.
- WS handshake/envelope per §3.3; backpressure protections present.
- Scheduler tasks registered **only** when loops are evidenced by traversal.
- SRP naming (no upstream prefixes); temporary aliases marked deprecated in docs.
- **Explicitly disallow**: concluding “no gaps” based solely on prior docs/logs **without fresh scans**.

---

## 12) Minimal Conflict Strategy

Prefer the **smallest coherent** change set that meets compatibility and closes evidenced gaps:
1) Maintain SRP contracts,
2) Replace polling with WS/Webhooks when evidence shows polling loops,
3) Favor maintainability (clear schemas, fewer cross-module deps).

---

## 13) Safety Notes

- Never echo secrets/tokens.
- Never embed upstream code verbatim (names/flows only).
- Keep runs atomic and reversible (idempotent migrations; clear CHANGELOG).

---

## 14) Execution Loop (deterministic)

```
read_prompt_and_run_config()
normalize_parameters()
inventory_service()

traversal = traverse(declared_paths + discovered_paths)        // fresh external scan (resources)
internal  = traverse_backend("backend/<Microservice>")         // fresh internal scan (our code)
signals   = extract_behaviors(traversal)                       // §2.2
emit_coverage_map(traversal, signals, internal)                // §2.3

clusters  = cluster_from_primary_domains()                     // §4
plan      = gap_map(clusters, signals)                         // SKIP | EXTEND | CREATE (evidence-only)
queue     = prioritize(plan)                                   // deps → perf wins → player value
queue     = enforce_fairness(queue)                            // round-robin; no tunneling

for item in queue:
  implement_vertical_slice(item)                               // routes → repos → migrations → WS/webhooks → validation → docs
  mark_closed_in_ledger(item)
  update_docs_and_reports(item)

assert_quality_gates()                                         // §11
emit_deliverables()                                            // §10
```