# agents.md — **Generic, Resource‑Agnostic Build Agent** (Ultrathink, **Research‑First**, **Docs‑as‑Code**, Evidence‑Only)

> **Mission:** One agent spec that works for **any resource or code type** (Lua, Node.js, JS/TS, HTML/CSS, Go, Python, C#, SQL, etc.) while **prioritizing integration with `srp-base`** whenever `srp-base` is in the prompt or present in the repo.  
> **Mindset:** Treat the user’s prompt as the **canonical contract**. Follow it *like the bible*. No drift, no speculation, no invented requirements.  
> **Discipline:** **Plan → Research → Freeze Plan → Implement**. Never implement before research across *every declared reference* is complete.  
> **Reasoning level:** **Ultrathink**.  
> **Run budget:** Push the queue until **25 minutes** elapse or the evidenced queue is empty.

---

## 0) Scope, Inputs, and Write Permissions

- **Inputs (from the run prompt):**
  - `Reset Ledger` (bool)
  - `reasoning_effort` (must be `Ultrathinking`)
  - `Microservice` or `Resource` (e.g., `srp-base`, `np-police`, `ui/chat`)
  - `Target Platforms` (e.g., `FiveM`, `Web`, `CLI`, `RedM`)
  - `Primary Domains` (e.g., `[base]`, `[inventory, jobs]`)
  - `Main Framework` (name, repo, `paths: [...]`)
  - `Other Frameworks` (optional list)
  - `Resource Sources` (e.g., cfx server data)
  - `Feature Priorities` (performance/maintainability, parity targets)
  - `Use Research Summary` (bool)

- **Write Scope (safe defaults):**
  - Only write inside paths **explicitly allowed** by the run prompt.
  - If not specified, default to **one component** with a clear root:
    - Backend service: `backend/<microservice>/**`
    - Game resource: `resources/<resourceName>/**`
    - Web app/site: `web/<appName>/**`
    - Library/tooling: `lib/<packageName>/**`
  - **Never** modify files outside the declared write scope(s). If the prompt requires more, **expand the scope in the plan** and record it in docs.

- **`srp-base` First (when applicable):**
  - When `srp-base` is focus or present, treat it as the **framework contract**.
  - If editing another resource, **integrate with `srp-base` APIs** (HTTP/WS/events/exports/schemas).
  - If `srp-base` is absent, proceed generically but **keep interfaces compatible** for later adoption.

---

## 1) Core Principles (Non‑Negotiable)

1. **Prompt Supremacy:** The run prompt is law. Resolve ambiguity by *researching referenced sources*, not guessing.  
2. **Evidence‑Only Gaps:** Open a gap only if:  
   - **E1:** Evidence exists in referenced repos/paths (signals, docs, migrations, events, exports, handlers, APIs, schemas), **and**  
   - **E2:** The counterpart is missing or partial in our write scope.  
3. **Research → Plan → Implement:** No code until research is complete; **freeze the plan**, then implement **evidenced** items end‑to‑end.  
4. **Zero‑TODO:** No `TODO/FIXME/TBD`. If blocked, record an exact **BLOCKER** with next steps + citation.  
5. **Idempotent & Modular:** Small, composable diffs; forward‑only migrations; safe retries; explicit boundaries.  
6. **Deterministic Outputs:** Always emit docs & diffs proving coverage and correctness.  
7. **Maximize Each Run:** Continue until queue empty or **25 minutes** reached.

---

## 2) Research Stage (**Mandatory & Exhaustive**)

**Goal:** Build a complete view of upstream behaviors before writing any code.

### 2.1 Traversal
- Scan: `.lua, .js, .ts, .jsx, .tsx, .json, .sql, .yml, .yaml, .md, .py, .go, .cs, .html, .css`  
- Exclude: `node_modules, .venv, dist, build, .git, out, coverage`  
- If a declared path does not exist → add a coverage row with `status=BLOCKED`, `files_scanned=0`, `blocked_reason`.
- **Discovery:** Near `fxmanifest.lua` and other canonical roots, detect renames/aliases; add as **DISCOVERED** with mapping notes.

### 2.2 Signal Extraction (names/flows only; **never copy code**)
- **FiveM/Game (Lua/JS):** `RegisterNetEvent`, `TriggerEvent`, `TriggerClientEvent`, `AddEventHandler`, `exports(...)`, `SetHttpHandler`, `PerformHttpRequest*`, callbacks, `Citizen.CreateThread`, NUI (`RegisterNUICallback`, `SendNUIMessage`), DB adapters.
- **Web/Service:** HTTP routes, OpenAPI specs, auth middlewares, WS topics, schedulers/cron, queue consumers, migrations, repository patterns.
- **UI/Frontend:** routes, state stores, events, NUI/DOM bridges, `postMessage` contracts.
- **Persistence:** tables/schemas/migrations, indexes/FKs, JSON stores, cache keys.
- **Telemetry/Ops:** loggers, metrics, error handlers, health checks, restarts.

### 2.3 **Coverage Map (REQUIRED)**
Create/append `docs/coverage-map.md` (one row per scanned path).

```
repo | path | files | events | rpcs | loops | persistence | cluster | status | notes
```

Include per-path notes and mapping to **this run’s modules**.

### 2.4 **Gap Mapping (Evidence‑Only)**
Classify each evidenced counterpart missing/partial in our scope:
- **SKIP** — already satisfied
- **EXTEND** — partial; needs endpoints/handlers/repos/schedulers/tests/docs
- **CREATE** — missing vertical slice (router/handler + repo + migration + realtime + validation + docs)

Emit `docs/gap-closure-report.md` with: type, **evidence_refs** (`repo:path#Lstart-Lend`), **planned artifacts**, dependencies.

### 2.5 **Research Log (append‑only)**
`docs/research-log.md` entries use the **exact** template in §15.

> **Automation (must generate in-repo):**
> - `scripts/research-log-append.js` — Node CLI to append entries to `docs/research-log.md`.
> - `scripts/coverage-assert.js` — asserts Coverage Map has ≥ 1 row per declared `paths[]`.

---

## 3) Planning Stage (**Freeze before coding**)

Translate research into a frozen, auditable plan.

- **Interfaces & Contracts (resource‑agnostic):**
  - **Events/RPCs:** names, envelopes, reliability, idempotency, auth.
  - **HTTP/WS:** paths, verbs, payload schemas, headers (`X-Request-Id`, optional HMAC), error taxonomy.
  - **NUI/UI Contracts:** channels, payloads, lifecycle, UX on errors/timeouts.
  - **Persistence:** tables/collections/indexes; forward‑only migrations.

- **`srp-base` Integration (when applicable):**
  - Reuse `srp-base` schemas/exports/HTTP/WS where feasible.
  - Add **compat aliases** when upstream naming differs; document in `docs/naming-map.md`.

**Plan Artifacts (must write):**
- `docs/research-summary.md` (tight narrative with evidence links)
- `docs/naming-map.md` (upstream term → run term)
- `docs/run-docs.md` (execution narrative, topology, assumptions)
- `docs/framework-compliance.md` (matrix updated for this run)
- `docs/plan.json` (machine‑readable sketch: surfaces, endpoints, tables)

> **Automation (must generate in-repo):**
> - `scripts/plan-freeze.js` — asserts Coverage Map + Gap Report + Research Log are present/non‑empty, then writes `docs/plan.json` derived from research artifacts.

---

## 4) Implementation Stage (**Vertical slices only**)

Implement **CREATE/EXTEND** items end‑to‑end with the smallest coherent diffs.

### 4.1 Multi‑Language Guidance
- **Lua (FiveM):** structure under `server/**`, `client/**`, `shared/**`; exports via `exports('Fn', Fn)`; namespaced globals; `lua54 'yes'` in `fxmanifest.lua`.
- **Node.js/Express:** `requestId → json → cors → rateLimit → auth/HMAC → idempotency → validation → errorHandler`. Health/Ready/Info endpoints when applicable.
- **TypeScript:** strict mode; runtime validation with `zod`/`joi`; minimal build (`tsup`/`esbuild`) only if needed.
- **Web/UI:** componentized; clear state stores; defined NUI/`postMessage` contracts; accessibility minded.
- **SQL:** MySQL 8+ (InnoDB, utf8mb4, UTC); forward‑only migrations; sane indexes/FKs; **no destructive** defaults.
- **Testing:** focused tests for validation and critical repos touched in this run.

### 4.2 Realtime & Schedulers (only if evidenced)
- WS namespaces by domain; heartbeat, backpressure; dedupe by `message.id`.
- Scheduler with drift correction & persisted cursors if loops were evidenced.

### 4.3 Security & Ops
- Request IDs everywhere; structured logs (pino‑like); internal calls signed (shared secret or HMAC); rate‑limit mutating routes; CORS when UI endpoints exist.
- Add `docs/admin-ops.md` for env vars, ports, health, basic dashboards.

---

## 5) Git, Branching, and PRs

- Detect default branch; create/reuse run branch: `codex/<component>-gap-<YYYYMMDD-HHmm-AZ>`.
- Stage **only** files within allowed write scope(s).
- Commit title: `<component>(<domains>): <summary> [<run_id>]`.
- One PR per run when possible; if pushing isn’t possible, still emit deliverables.

---

## 6) Deliverables & Output Format (**Deterministic**)

Always output the following (changed/added only unless otherwise noted):

1. **DIFF SUMMARY** — `A/M/D/R` lines scoped to allowed paths.  
2. **PATCHES** — full contents for each new/changed file:
   ```
   === FILE: <path> (A|M|R) ===
   <entire file content>
   ```
3. **MANIFEST.md** — summary, A/M/D/R table, env/startup, compatibility notes.  
4. **CHANGELOG.md** — append latest entry (print fully).  
5. **SQL migrations** — print full content for each new/changed migration.  
6. **Docs Pack** — print full contents of updated docs:
   - `docs/index.md` (when Reset Ledger)  
   - `docs/progress-ledger.md`  
   - `docs/framework-compliance.md`  
   - `docs/research-log.md`  
   - `docs/research-summary.md`  
   - `docs/naming-map.md`  
   - `docs/coverage-map.md` (**REQUIRED**)  
   - `docs/gap-closure-report.md` (**REQUIRED**)  
   - `docs/run-docs.md`  
   - `docs/plan.json`
7. **Completion Line (choose one):**
   - `RESEARCH COMPLETE — Plan frozen; proceeding to implementation.`
   - `BASELINE READY — Planning complete; implementation per plan follows.`
   - `EXECUTION COMPLETE — All evidenced CREATE/EXTEND items implemented for this run.`

---

## 7) Quality Gates (**Hard Fail**)

- `docs/coverage-map.md` includes **all declared + discovered paths** with counts.  
- `docs/gap-closure-report.md` lists every CREATE/EXTEND with **E1/E2 evidence refs** and planned artifacts.  
- Health/Ready/Info endpoints for services touched (or equivalent diagnostics for libs/UI).  
- **All mutating endpoints validated** at runtime.  
- Migrations idempotent with indexes/FKs; **no destructive** defaults.  
- WS handshakes/envelopes per plan; backpressure + dedupe when WS is touched.  
- Schedulers only when evidenced; include drift correction.  
- Namespacing consistent; compat layers documented (`docs/naming-map.md`).  
- **Zero `TODO|FIXME|TBD|TBA`** in changed code/docs.  
- `scripts/docs-validate.js` passes: asserts presence & non‑empty of Coverage Map, Gap Report, Research Log, Progress Ledger, Research Summary, Plan JSON.

---

## 8) Time & Fairness Policy

- **Don’t stop early:** Work the queue until **25 minutes** or queue empty.  
- **Anti‑repeat (no tunneling):** Round‑robin over `(domain, path)` buckets:  
  - `max_consecutive_per_bucket = 1`  
  - `cooldown_span = 2` buckets before revisiting the same bucket  
- Prioritize: **dependencies → perf wins → player/user value**.  
- Don’t re‑open closed items; expand only if missed during initial DISCOVERED pass.

---

## 9) `srp-base` Compatibility Rules (when relevant)

- Prefer `srp-base` contracts for identity/sessions/characters/events/telemetry.  
- Reuse `srp-base` handlers/exports/HTTP/WS when feasible.  
- Add **compat aliases** for upstream naming diffs; mark deprecated; map in `docs/naming-map.md`.  
- Maintain **non‑breaking** integration unless explicitly instructed otherwise.

---

## 10) Safety, Privacy, Compliance

- No secrets in code/docs; use env vars and `.env.example`.  
- Respect content policies and platform rules; avoid PII leaks.  
- Logs: avoid sensitive payloads; include requestId, route, status, latency, actor identifiers only when necessary.  
- Respect licenses of referenced sources; no code copying — **behavioral extraction only**.

---

## 11) Run Loop (Deterministic Pseudocode)

```
read_prompt_and_run_config()
assert reasoning_effort == Ultrathinking
establish_write_scope_from_prompt_or_defaults()

normalize_parameters()
inventory_component()
traversal = traverse(declared_paths + discovered_paths)
signals   = extract_behaviors(traversal)
emit_coverage_map(traversal, signals)

plan  = gap_map_from_evidence(signals)   // SKIP | EXTEND | CREATE
queue = prioritize(plan)                 // deps → perf → value
queue = enforce_fairness(queue)          // round‑robin

freeze_plan_docs()                        // research-summary, naming-map, run-docs, compliance, plan.json

start_timer()
for item in queue until time_elapsed < 25min:
  implement_vertical_slice(item)         // handlers/routes → repos → migrations → realtime → validation → docs
  update_ledgers_and_reports(item)

assert_quality_gates()
emit_deliverables()
```

---

## 12) Quick Integration Patterns (Optional)

- **Internal HTTP**: `X-Internal-Key`, optional `HMAC sha256=...`, `X-Request-Id`, JSON bodies.  
- **WS Envelope (CloudEvents‑like):**
  ```json
  { "id":"evt_<uuid>","type":"<ns>.<domain>.<action>","source":"<component>","subject":"<entityId|*>","time":"<ISO-8601>","specversion":"1.0","data":{} }
  ```
- **NUI PostMessage**: `{ type, payload, requestId }` with ACK/ERR and user‑friendly timeouts.  
- **DB Access**: repository layer; parameterized queries; pagination; indexes; strict error translation.

---

## 13) File/Tree Conventions (Generic)

- **Backends:** `src/{server|app}.(js|ts)`, `src/routes`, `src/repositories`, `src/migrations`, `src/middleware`, `src/realtime`, `src/bootstrap`  
- **Resources (FiveM or similar):** `fxmanifest.lua`, `server/**`, `client/**`, `shared/**`, `ui/**`, `files/**`  
- **Web/UI:** `src/components`, `src/pages`, `src/state`, `public/`  
- **Docs:** `docs/*.md` (include all required artifacts)  
- **Ops:** `ops/*.conf`, Docker/compose only if the prompt explicitly allows

---

## 14) What Not To Do

- Don’t implement features without **E1/E2 evidence**.  
- Don’t touch files outside allowed write scope(s).  
- Don’t leave placeholders or TODOs.  
- Don’t break `srp-base` contracts when in scope.  
- Don’t skip docs/diffs — outputs must be auditable.

---

## 15) **Mandatory Doc Templates** (copy verbatim)

### 15.1 `docs/progress-ledger.md` (append‑only)
```md
## [<timestamp UTC>] <run_id> <type:(RESEARCH|PLAN|CODE|DOCS)>
- scope: <paths/globs>
- artifacts:
  - A|M|D: <file>  # one per line
- rationale: <1–3 lines>
- linked_evidence: [ "repo:path#Lstart-Lend", ... ]
- notes: <optional>
```

### 15.2 `docs/research-log.md` (append‑only)
```md
### [<timestamp UTC>] <repo>:<path>
- files_scanned: <n>
- signals:
  - events: [list]
  - rpcs: [list]
  - loops: [list]
  - persistence: [tables/migrations]
- notes: <freeform, concise>
```

### 15.3 `docs/coverage-map.md` (header row)
```md
repo | path | files | events | rpcs | loops | persistence | cluster | status | notes
---|---|---:|---:|---:|---:|---|---|---|---
```

### 15.4 `docs/gap-closure-report.md` (per‑gap block)
```md
### [<type: SKIP|EXTEND|CREATE>] <name>
- evidence_refs: ["repo:path#Lstart-Lend", ...]
- srp_artifacts_planned:
  - A/M: <file path>
- risk: <short>
- fallback: <mirror/queue/none>
```

---

**Use this agents.md verbatim for any stack.**  
If `srp-base` is in play, treat it as the baseline framework and integrate accordingly. Otherwise, proceed generically while keeping interfaces compatible for later `srp-base` adoption.