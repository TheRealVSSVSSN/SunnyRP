# SRP Suite Microservice Builder — `agents.md` (Codex‑Optimized, **Resource‑Independent**, Adaptive Coverage, Zero‑TODO)

**Purpose:** Operational handbook for the agent that consumes the **Unified Microservice Builder prompt** and turns it into concrete, consistent changes inside `backend/<Microservice>`.
**Scope:** Work **only** in `backend/<Microservice>` for the current run. Never touch `resources/*` or any `fxmanifest.lua`.
**Compatibility:** Everything you build must remain **compatible with `srp-base`** (HTTP/WS shapes, headers, and multi-character APIs), even if the target microservice is not `srp-base`.

> This version is **resource‑independent**: repository paths are treated as **hints**, not truth. The agent auto‑discovers renamed/moved modules and infers domain responsibilities from **signals** (events, RPCs, loops, persistence), not specific folder names. Missing/renamed paths do **not** hard‑fail the run; they are recorded and substituted with discovered equivalents when possible.

---

## 0) Parameter Guards & Normalization (pre‑flight)

Before doing anything, **validate and normalize** prompt parameters:

- `Reset Ledger` → boolean only.
- `Microservice` → **string**. If an array is provided (e.g., `["srp-base"]`), take the first element.
- `Target Platforms` → subset of `{"FiveM","RedM"}`; default `["Both"]` if omitted.
- `Primary Domains` → non-empty array of domain keys (e.g., `["base"]`).
- `Main Framework.repo` and `Other Frameworks[].repo` → valid Git URLs.
- `paths` values should be **repo-relative** (e.g., `"resources/base"`), not GitHub UI paths (❌ `/tree/master/resources`). If a UI path is provided, **normalize** to repo-relative (`"resources"`).
- **De‑dupe** all repos/paths; preserve order.

On validation failure, **fix automatically** when safe (e.g., array→string, UI path→repo-relative). Otherwise, log once:
`Parameter normalization failed for <field>; proceeding with best‑effort defaults.`

---

## 1) How to read the prompt (semantics)

- **Reset Ledger**
  - `true`: start fresh run docs; truncate `docs/progress-ledger.md` and `docs/index.md` headers/content, but do **not** erase `CHANGELOG.md`.
  - `false`: append to existing docs; preserve history.

- **Microservice**
  - Folder under `backend/` where you operate. If absent, create a standard scaffold (see §6).

- **Target Platforms**
  - `FiveM`, `RedM`, or `Both`. When `RedM` present, enable RedM toggles (horses, Dead Eye, RDR2 weapon sets) and keep the same HTTP/WS contracts. No divergent APIs.

- **Primary Domains**
  - Areas to build/extend **this run** (e.g., `base`, `vehicles`, `banking`, `inventory`, `police`, `jobs`, `phone`, …). Use them to scope discovery and clustering (see §4).

- **Main Framework / Other Frameworks / Resource Sources**
  - Use these repositories for **names/flows only** (events, RPCs, timers, persistence). **Never copy code.**
  - If `Resource Sources` pins a domain to repo subpaths, prefer those during discovery (but still discover around them if missing).

- **Feature Priorities**
  - `performance: "maximize"` → migrate loops to scheduler, push via WS/webhooks, avoid N+1, add indexes, batch I/O.
  - `maintainability: "maximize"` → strict module boundaries, SRP naming, repository pattern, clear docs.
  - `parity_targets` are **guidance only** (NoPixel 4.0/Prodigy 4.0 features); do not copy code.

- **Use Research Summary**
  - If `true`, leverage cross‑framework analysis (concepts, flows, field names) to inform design.

---

## 2) **Adaptive, Resource‑Independent Coverage** & Gap‑Closure Mode (ENFORCED)

**Goal:** Traverse declared repos/paths **and** auto‑discover adjacent or renamed modules, guided by **domain signals** rather than fixed folder names; build a **coverage map**, identify **all gaps**, and **close them with working code** — **no placeholders, no TODOs**.

### 2.1 Traversal Strategy (Adaptive)
1. **Declared Pass** — Enumerate each provided `paths[]` (normalized). If a path is missing:
   - Add a `MOVED_OR_MISSING` row in `coverage-map.md`.
2. **Discovery Pass** — For each missing path, **search the repo** using tokenized fuzzy matching on:
   - **Domain anchors** (concepts): `base`, `core`, `session`, `spawn`, `identity`, `queue`, `priority`, `whitelist`, `voice`, `voip`, `radio`, `comms`, `streaming`, `population`, `instance`, `log`, `telemetry`, `error`, `audit`, `rcon`, `restart`, `scheduler`, `cron`, `chat`, `ui`, `notify`, `taskbar`, `progress`, `skill`, `threat`, `scoreboard`, `vote`, `zone`, `poly`, `polygon`, `blip`, `map`, `minimap`, `door`, `lock`, `weather`, `world`, `barrier`, `prop`, `job`, `grade`, `duty`, `dispatch`, `evidence`, `bank`, `finance`, `wallet`, `invoice`, `fine`, `business`, `property`, `interior`, `phone`, `message`, `contact`, `mail`, `app`.
   - **Common framework tokens** (as hints only): `esx`, `qb`, `vrp`, `nd`, `essential`, `fsn`, `vorp`.
   - File types: `.lua`, `.js`, `.ts`, `.json`, `.sql`, `.yml`, `.yaml`, `.md`.
   - Prefer matches under `resources/` or typical server roots; otherwise accept repo‑wide matches.
3. **Neighbor Pass** — When a candidate folder is identified, also index **neighbors** with similar names (to capture splits/merges).
4. **External Pass** — If `Other Frameworks` are present, scan their roots for **analogous behaviors** (names/flows only) to enrich parity analysis.

> **No hardcoded resource names** are required; discovery is driven by **concepts and signals**.

### 2.2 Signal Extraction (names/flows only)
- Events: `RegisterNetEvent`, `TriggerEvent`, `TriggerClientEvent`, `AddEventHandler`.
- RPC/callbacks: `RPC.register|execute`, `exports("...")`, `Callbacks:Server`, `lib.callback.register|await`, NUI `postMessage`/`SendNUIMessage` patterns.
- Citizen loops: `Citizen.CreateThread`, timers, `while true do` with waits.
- Persistence: table/collection names in code or `.sql`.
- Security/roles/grades, queues, identity/session, scoreboard/whitelist/login.
- Voice/streaming/population/queue/spawn/session hand‑offs.

### 2.3 Coverage Map (MUST EMIT)
Create **`docs/coverage-map.md`** with two sections:

**A. Summary Table**
| repo | path | files | events | rpcs | loops | persistence | cluster | status | liftover_from? |
|------|------|-------|--------|------|-------|-------------|---------|--------|----------------|

Statuses:
- `SCANNED` — path scanned successfully.
- `MOVED_OR_MISSING` — declared path absent.
- `DISCOVERED` — path found by discovery as a probable successor.
- `BLOCKED` — repo unreachable.

**B. Notes & Mapping**
- Per‑path notes; **Source → SRP module(s)** matrix; and **Liftover mapping**: declared path → discovered path (if applicable).

### 2.4 Gap Definitions
- **SKIP** — implemented & correct in `backend/<Microservice>`.
- **EXTEND** — partially implemented; needs endpoints/repo functions/scheduler tasks.
- **CREATE** — missing vertical slice (router + repo + migration + realtime + validation + docs).

### 2.5 Gap Queue (Execution Order)
1) Dependencies → 2) Performance wins → 3) Player‑visible value.
Implement each item **end‑to‑end** (route→repo→migrations→realtime→validation→docs). Migrate loops to **Scheduler** and push via **WS/Webhooks** where implied.

### 2.6 Zero‑TODO Policy (HARD)
- **Do not leave** `TODO`, `FIXME`, `TBD`, `TBA` in code or docs.
- No placeholder comments/sections. Fully implement functionality or scope down to a closed, minimal coherent slice.
- If a feature is **externally blocked**, document the precise blocker in `docs/gap-closure-report.md` and **exclude** TODO text from code.

---

## 3) SRP‑BASE compatibility requirements (enforced)

Apply to **every** microservice.

### 3.1 Mandatory HTTP endpoints
- `GET /v1/health` → `{ status: "ok", service, time }`
- `GET /v1/ready`  → `{ ready: true|false, deps: [...] }`
- `GET /v1/info`   → `{ service, version, compat: { baseline: "srp-base" } }`

### 3.2 Multi‑character APIs (code‑level)
- `GET /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters/{characterId}:select`
- `DELETE /v1/accounts/{accountId}/characters/{characterId}`
Scope gameplay state by the **active character** once selected.

### 3.3 WebSocket handshake & envelope
- Handshake accepts: `sid`, `accountId`, `characterId` (nullable).
- Envelope (CloudEvents‑like):
```json
{
  "id": "evt_<uuid>",
  "type": "srp.<domain>.<action>",
  "source": "<microservice>",
  "subject": "<characterId|accountId|entityId|*>",
  "time": "<ISO-8601>",
  "specversion": "1.0",
  "data": { }
}
```

---

## 4) Clustering rules (domain consolidation)

Use `Primary Domains` as anchors, then include related responsibilities.

- **Vehicles** → registry, tuning/handling, garages/impounds, fuel, keys, damage/condition, tests/school, dispatch flags.
- **Ped/Identity** → identity creation, clothing/cosmetics/tattoos, emotes, health/medical.
- **Bank/Finance** → accounts/wallets, ATMs, invoices/billing/fines, businesses/ledgers, economy resets.
- **Jobs** → police/EMS/mechanic/taxi/trucker, licenses/grades, duty/roster, dispatch/callsigns, evidence chain.
- **Comms/Phone** → phone, messages, contacts, mail/outbox, apps.
- **World/Zones** → doors/locks, blips, poly‑zones, shops/loot, properties/interiors, underground hubs.

**Consolidate** overlaps into **SRP‑named** modules. Temporary aliases only if essential; mark **deprecated** in docs.

### 4.1 Base Cluster Map (when `Primary Domains` includes `base`)
**Capability buckets** (no resource names):
- **Core session & identity**: authentication, whitelist/allowlist, session lifecycle, spawn/respawn, character ID generation.
- **Concurrency & scale**: instance/population management, streaming range management, connection queue/priority, hard limits per tick.
- **Voice & comms**: VoIP transport, radio channels, proximity rules, broadcast relays.
- **State & telemetry**: structured logs, error reporting, RCON hooks, restart windows, scheduled tasks.
- **UX & input**: chat transport, progress/task bars, skill/threat meters, notifications, scoreboard, voting.
- **World infra**: polygonal zones, blips/markers, map overlays, environmental sync, barriers/props.
- **Jobs foundation**: job registry, grades/roles, primary/secondary job selection.
- **Tooling**: build/runtime toolchain references (names/flows only).

> Treat buckets as **anchors**. If directories rename or split, discovery still attaches modules to these buckets via **signals** and keywords (§2).

---

## 5) Implementation principles

### 5.1 Express‑first (no OpenAPI files)
- Single `express()` app via `http.createServer(app)`.
- Middleware order: `requestId` → JSON parser → CORS → **rateLimit** → **HMAC/Auth** → **Idempotency** (mutations) → **Runtime validation** (Zod/Joi/AJV) → error handler.
- One router per domain under `/v1/<domain>`.
- **Do not** create or edit `openapi.yaml`. Document the API in `docs/BASE_API_DOCUMENTATION.md`.

### 5.2 Realtime
- **WS Gateway** under `/ws/<domain>`; heartbeat, backpressure, exp‑backoff reconnect, dedupe by `id`.
- **Webhooks** dispatcher with HMAC signing, retries (exp‑backoff + jitter), dead‑letter logs; disabled Discord sink scaffold; admin CRUD optional.

### 5.3 Scheduler (Node “thread” replacement)
- `src/bootstrap/scheduler.js` with drift correction + persisted cursors.
- Register per‑module tasks (fuel ticks, dispatch sweeps, rollovers).
- Use `worker_threads` only for CPU‑heavy work.

### 5.4 Persistence
- Repository pattern (parameterized queries).
- Migrations are **idempotent** (`IF NOT EXISTS`), forward‑only, with indexes/FKs.
- Avoid N+1; paginate; consider small TTL caches for hot reads.

### 5.5 Security & Ops
- `X-API-Token` + optional HMAC signature for sensitive routes.
- Rate limits on all public endpoints.
- Idempotency keys on POST/PUT/PATCH/DELETE.
- Logs: pino (with `requestId`); metrics: `prom-client` at `/metrics`.

### 5.6 RedM compatibility
- Feature flags for RDR2 specifics; HTTP/WS contracts remain identical.

---

## 6) Directory layout (create if missing)

```
backend/<Microservice>/
  src/
    app.js
    server.js                 # export createHttpServer({ env })
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
    ...
  docs/
    index.md
    progress-ledger.md
    framework-compliance.md
    run-docs.md
    research-log.md
    naming-map.md
    admin-ops.md
    BASE_API_DOCUMENTATION.md
    events-and-rpcs.md
    db-schema.md
    migrations.md
    security.md
    testing.md
    todo-gaps.md
    coverage-map.md              # REQUIRED
    gap-closure-report.md        # REQUIRED
    resource-hints.json          # OPTIONAL cache of last discovered paths
  CHANGELOG.md
  MANIFEST.md
```

---

## 7) Git & PR behavior

- Detect default branch (`origin` HEAD → current branch → prefer `main` → `master` → single remote).
- Working branch: `codex/<Microservice>-gap-<YYYYMMDD-HHmm-AZ>` (reuse if exists).
- **Stage only changes** inside `backend/<Microservice>/`.
- Commit title:
  - `<Microservice>(<domains>): cluster consolidation + ws/webhooks + scheduler + express`
- One PR per run. If push is denied by platform, skip the push and still emit deliverables.

---

## 8) Auto‑repairs & “no‑ops”

- **Duplicate migrations**: renumber later duplicate prefix to next free number (keep zero‑padding).
- **Merge markers**: replace any `<<<<<<<`/`=======`/`>>>>>>>` with resolved content.
- **Tests/Lint**: don’t add placeholders unless required by changed files.
- **No Base64/ZIP** outputs.
- **OpenAPI**: do **not** create, edit, or remove any OpenAPI files this run.

If after gap mapping nothing needs changes, print exactly:
`No changes required this run.`

---

## 9) Documentation duties

- **If Reset Ledger = true**: re‑init `docs/index.md` and `docs/progress-ledger.md`.
- Update or create (changed docs only; full contents in deliverables):
  - `docs/run-docs.md` — consolidated narrative of the run.
  - `docs/framework-compliance.md` — SRP‑BASE compatibility & deviations.
  - `docs/research-log.md` — titles/links used.
  - `docs/naming-map.md` — upstream term → SRP term.
  - `docs/todo-gaps.md` — authoritative, prioritized list (**no TODOs in code**). Also append the same list to end of `docs/run-docs.md`.
  - `docs/coverage-map.md` — **mandatory**: include declared, discovered, neighbor entries; liftover mapping.
  - `docs/gap-closure-report.md` — **mandatory**: detected gaps → implemented actions; list **external blockers** precisely.
  - Module docs under `docs/modules/` as needed.
  - `docs/resource-hints.json` — OPTIONAL cache of discovered paths for the next run (non‑blocking).

---

## 10) Deliverables format (stdout)

Output **only changed/new files** (no ellipses).

1. **DIFF SUMMARY** (A/M/D/R lines under `backend/<Microservice>/`).
2. **PATCHES** (full contents):
   ```
   === FILE: backend/<Microservice>/<path> (A|M|R) ===
   <entire final file>
   ```
   *Do not* print deleted file contents; list them as `D` in the diff.
3. **MANIFEST.md** (full): summary bullets; A/M/D/R table; startup/env notes; any compatibility aliases.
4. **CHANGELOG.md**: append a new entry (print the new entry in full).
5. **SQL migrations**: full content for each new/changed migration under `src/migrations/`.
6. **Docs Pack**: full contents for changed docs only.
7. Completion line:
   `DONE — <Microservice> microservice baseline complete.`
   —or—
   `No changes required this run.`

---

## 11) Quality gates (hard fail if not met)

- **Coverage map present** with **Declared/Discovered/Neighbor** rows and liftover mapping where relevant.
- **Zero‑TODO**: no `TODO|FIXME|TBD|TBA` anywhere in code or docs.
- Mandatory `health|ready|info` endpoints present.
- Multi‑character endpoints present when character scope used.
- Runtime validators on all mutating endpoints (OpenAPI deferred).
- Migrations idempotent; indexes/FKs defined; no destructive ops without safeguards.
- WS handshake & envelope correct; backpressure protections included.
- Scheduler tasks registered for every migrated loop detected in traversal.
- SRP naming; aliases only if strictly required (marked deprecated in docs).
- Docs updated: `run-docs.md`, `framework-compliance.md`, `naming-map.md`, `coverage-map.md`, `gap-closure-report.md`, `progress-ledger.md`.

> **Adaptive rule:** Missing declared paths **do not fail** the run **if** suitable discovered replacements are listed and used. Only fail if coverage output is missing altogether or lacks an attempt to discover/record liftover.

---

## 12) Minimal conflict resolution strategy

Prefer the **smallest** coherent change set that achieves parity + compatibility.
If frameworks differ, choose the approach that:
1) fits SRP naming/contracts,
2) reduces client polling (favor WS/Webhooks),
3) simplifies maintenance (clear schemas, fewer cross‑module dependencies).

---

## 13) Safety notes

- Never echo secrets/tokens.
- Never embed upstream code verbatim (names/flows only).
- Keep runs atomic and reversible (idempotent migrations; clear CHANGELOG).

---

## 14) Execution loop (mental model)

```
read_prompt()
normalize_parameters()         // §0
inventory_service()

traversal = traverse_refs_adaptive() // Declared → Discovery → Neighbor → External (§2.1)
signals = extract_signals()          // §2.2
emit_coverage_map(traversal, signals)  // §2.3 (Declared/Discovered/Neighbor + liftover)

clusters = build_clusters(primary_domains)   // §4 + §4.1
plan = gap_map(clusters, signals)            // SKIP | EXTEND | CREATE

for item in prioritized(plan):               // §2.5
  implement_vertical_slice(item)             // routes → repos → migrations
  wire_realtime_and_scheduler_if_implied()
  add_runtime_validation()
  update_docs_and_reports()                  // run-docs, framework-compliance, naming-map, gap-closure

run_quality_gates()                          // §11
emit_deliverables()                          // §10
```

---

## 15) Base Cluster Quick Reference (for `Primary Domains: ["base"]`)

**Capability buckets** (resource‑independent):
- **sessions**: authentication, allowlist, session lifecycle, spawn/respawn, character ID generation
- **queue**: connection queue/priority, concurrency limits
- **voice**: VoIP transport, proximity/radio channels, broadcast relays
- **telemetry**: logs, error reporting, RCON hooks, restart windows, scheduled tasks
- **ux**: chat, progress/task bars, skill/threat meters, notifications, scoreboard, voting
- **world**: zones/polygons, blips/markers, map overlays, environmental sync, barriers/props
- **jobs**: job registry, grades/roles, primary/secondary job selection

Each responsibility must be classified SKIP/EXTEND/CREATE and, when CREATE/EXTEND, implemented fully with **no TODOs** — using **discovered** paths and signals rather than fixed resource names.