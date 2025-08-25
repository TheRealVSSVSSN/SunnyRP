# SRP Base Builder — Agent Specification

**Role:** Single autonomous agent that **designs, implements, refactors, verifies, and documents** the `backend/srp-base` Node.js microservice for SunnyRP.

**Scope:** Operate **only** inside `backend/srp-base` (Express routes, repositories, migrations, OpenAPI, realtime).  
**Out of scope:** Do **not** modify `resources/*` or any FiveM `fxmanifest.lua`.

---

## 0) Run Parameters (front-matter per run)

```
Reset Ledger: <true|false>
NoPixel Resource: <required e.g., vehicles | phone | inventory | police | banking | jobs | ...>
reasoning_effort: <Low | Medium | High | Ultra Think>
```

- **Reset Ledger: true** → reset `docs/progress-ledger.md` and `docs/index.md` (fresh headers). Do **not** erase `CHANGELOG.md` history.  
- **Reset Ledger: false** → append to ledger/docs incrementally.  
- **NoPixel Resource** → primary domain for this run. Agent **auto-discovers related resources** in the same domain cluster (see **§4 Clustering**).

**Time budget (hard cap = 30 min):**
- **Phase A (≤20 min)**: Gather → Plan → Implement (Express + WS/Webhooks + Scheduler + OpenAPI + Migrations + Docs).  
- **Phase B (≤10 min)**: Verify/Optimize → Consolidate docs → Finalize deliverables.  
If work remains, write precise items to **`docs/todo-gaps.md`** and append the same list as the last section of **`docs/run-docs.md`**.

---

## 1) Guardrails (hard rules)

1. **Express-first** HTTP stack; **OpenAPI-first** validation (schema-first).  
2. **No code copy** from upstream references (use names/flows only).  
3. **No** Base64/ZIP outputs; **no** merge-conflict markers in files.  
4. Touch **only** `backend/srp-base/**` paths.  
5. **Commit changed files only**; never restage unmodified files.  
6. If **zero changes** → print exactly: `No changes required this run.` and **do not** commit/push.  
7. Prefer **SRP naming** (rename away from upstream prefixes); provide compat aliases **only if strictly needed** (mark as deprecated in OpenAPI).  
8. Enforce per-endpoint: **Auth/HMAC**, **rate limits**, **idempotency keys** (mutations), **requestId** correlation, centralized error handling, and consistent 4xx/5xx semantics.

---

## 2) Architecture (Express + Realtime + Scheduler)

### 2.1 Express Core (required)
- One `express()` app; start with `http.createServer(app)` to share port with WebSockets.  
- Middleware order: `requestId` → JSON/body parser → CORS → **rateLimit** → **HMAC/Auth** → **idempotency** → **OpenAPI validator** → centralized error handler.  
- Use `express.Router()` per domain; mount under `/v1/<domain>`.  
- **OpenAPI-first:** update `openapi/api.yaml` **before** writing handlers; validate spec after.

### 2.2 WebSocket Gateway (server → client push)
- Attach `socket.io` (or `ws`) to the same HTTP server.  
- Namespaces per domain cluster (e.g., `/vehicles`, `/jobs`, `/phone`, `/banking`, `/world`).  
- Heartbeat (ping/pong), connection auth, **backpressure protection**, reconnect (exponential backoff), message dedupe via `eventId`.  
- Message envelope:  
  ```json
  { "eventId": "<uuid>", "type": "<domain.event>", "payload": {...}, "createdAt": "<iso8601>", "ttl": <seconds> }
  ```

### 2.3 Webhook Dispatcher (server → external sinks)
- Generic publisher with **HMAC signing**, exponential backoff + jitter, dead-letter logging.  
- **Discord sink**: scaffold only (config keys), disabled by default; document in `docs/admin-ops.md`.  
- Optional admin CRUD: `/v1/hooks/endpoints` (admin-only) with secret rotation notes in OpenAPI/docs.

### 2.4 Loop Migration Scheduler (server-side “thread” replacement)
- `src/bootstrap/scheduler.js` runs periodic tasks with jitter & drift correction (never block event loop).  
- Register per-module tasks (fuel ticks, plant growth, dispatch sweeps, queue drains, cleanup).  
- Persist last-run state for **idempotency**; per-task enable/interval via config.

---

## 3) Domain Model Requirements

### 3.1 Multi-Character Readiness (always enforce)
- **Accounts ↔ Characters**: ownership, list/create/select/delete; soft-delete optional.  
- **Session binding**: selecting a character scopes subsequent requests (idempotent reselection OK).  
- **Permissions**: character-level flags/roles distinct from account-level.  
- **Data scoping**: all gameplay actions are scoped by the **active character**.  
- **Migrations**: FKs + indexes for accounts, characters, selection/session state.  
- Canonical API surface (rename to SRP style if needed):  
  - `GET /v1/accounts/{accountId}/characters`  
  - `POST /v1/accounts/{accountId}/characters`  
  - `POST /v1/accounts/{accountId}/characters/{characterId}:select`  
  - `DELETE /v1/accounts/{accountId}/characters/{characterId}`

### 3.2 Cross-Framework Synthesis (names/flows only)
Compare these for primitives and gaps (no code copy):  
**NoPixel**, **EssentialMode**, **ESX**, **ND**, **FSN**, **QB**, **vRP**, **vORP (RedM)**.  
Ensure SRP primitives exist and are consistent:
- identifiers/accounts; jobs/grades; bank models & ledgers; inventory/weights; crafting/recipes; dispatch queues & priorities; property ownership/keys; RedM compatibility flags.  
- Use SRP-centric names: `accounts`, `characters`, `jobs`, `banking`, `inventory`, `dispatch`, `properties`, etc.  
- Maintain mapping in **`docs/naming-map.md`** (source term → SRP term).

### 3.3 Next-Gen Planning (4.0 era; names/flows only)
Consider: identity creation hooks; 3D dropped items; crafting/health overhauls; weapon customization affecting performance; improved vehicle handling (manual/sequential); walk-in interiors (hospitals/police); **Sewer City**; career progression; **economy reset**.  
Add minimal backend primitives where needed; record sources in `docs/research-log.md`.

---

## 4) Clustering & Consolidation

Given **NoPixel Resource** (primary), auto-discover **related resources** and process **together** if they belong to the same gameplay domain:

- **Vehicles:** tuning/handling, garages/impounds, fuel, keys, damage/condition, driving school/tests, dispatch flags.  
- **Ped/Identity:** identity creation, clothing/cosmetics, appearance/tattoos, emotes, health/medical.  
- **Banking/Finance:** accounts/wallets, ATMs, invoices/billing, fines, economy resets, businesses/ledgers.  
- **Jobs:** police/EMS/mechanic/taxi/trucker; licenses/grades; duty/roster; dispatch & call-signs; evidence chain.  
- **Comms/Phone:** phone, messages, contacts, mail/outbox, apps/sites.  
- **World/Zones:** doors/locks, blips, poly-zones, shops/loot, properties/interiors, **Sewer City** access.

**Consolidate** overlapping responsibilities into unified **SRP-named** backend modules (routes/repos/migrations/OpenAPI/docs). Avoid duplication; keep boundaries clear.

---

## 5) Auto-Repairs

1. **Duplicate migrations:** scan `src/migrations/*.sql`; if duplicate numeric prefixes (e.g., two `018_*`), rename later/conflicting to next free number (preserve zero padding). Keep **idempotent**; update docs.  
2. **OpenAPI canonicalization:** canonical file = `openapi/api.yaml` (root). If `src/openapi/api.yaml` exists, **merge** deltas then **delete** `src/openapi/api.yaml`. Fix references.  
3. **Merge markers:** if any `<<<<<<<`, `=======`, `>>>>>>>`, **replace** with resolved content.  
4. **Tests/Lint:** do **not** run or add placeholders (unless already present and part of other changed files).  
5. **No Base64/ZIP** in outputs.

---

## 6) GitHub Integration (Platform-Linked)

- Detect default branch (in order): `git remote show origin` HEAD → `git branch --show-current` → prefer `main`, else `master`, else single remote branch.  
- Working branch: `codex/srp-base-gap-<YYYYMMDD-HHmm-AZ>`; reuse if exists.  
- Commit **only changed files** under `backend/srp-base/`.  
- Commit title pattern:  
  - `srp-base(<NoPixel Resource>): express parity + ws/webhooks + scheduler + cluster`  
- Push and open/update **one** PR per working branch.  
- If push denied by platform, skip push but **still output deliverables**.

**PR body sections:** MANIFEST, CHANGELOG (new entry), Diff summary, Quality gates checklist.

---

## 7) Start Sequence (Every Run)

1. **Sync & Inventory:** enumerate Express routes, repositories, migrations, OpenAPI paths/schemas, docs.  
2. **Reset Ledger?** if `true` → reset `docs/progress-ledger.md` and `docs/index.md`.  
3. **Ensure scaffolds:** Express app OK, **WS gateway** present, **Scheduler** present (create minimal if absent).  
4. **Intake:** shallow-clone references (primary + cluster), read **names/flows only**.  
5. **Gap Mapping:** For each responsibility → **SKIP** (exists & correct) / **EXTEND** (partial, minimal) / **CREATE** (missing).  
   - Where client loops implied → migrate to **Scheduler + WS/Webhooks**.  
6. **Implement:** Update **OpenAPI first**, then code (routes→repos→migrations), then docs.  
7. **Auto-Repairs:** duplicate migration renumber; OpenAPI canonicalization; conflict cleanup.  
8. **Verify:** alignment (route ↔ repo ↔ migration ↔ OpenAPI), perf pass (indexes, pagination, WS backpressure, scheduler drift).  
9. **Docs:** consolidate to **`docs/run-docs.md`** (single combined doc); keep **ledger** and **framework-compliance** separate; write **`docs/todo-gaps.md`**, and **append** same list at the bottom of `docs/run-docs.md`.  
10. **Commit & PR:** stage changed files only; push; open/update PR.

---

## 8) Deliverables (Print-Only Changed Files; No Ellipses)

1. **Diff summary** (A/M/D/R) for paths under `backend/srp-base/`.  
2. **Patches (FULL CONTENTS)** for each changed/new file:  
   ```
   === FILE: backend/srp-base/<path> (A|M|R) ===
   <complete file content>
   ```
   - For deleted-only files, include in diff (D) but **do not** print content.  
3. **MANIFEST.md** (full): summary bullets; A/M/D/R table; startup/env notes & compatibility aliases.  
4. **CHANGELOG.md** (append entry; print the new entry in full).  
5. **SQL migrations:**  
   ```
   === FILE: backend/srp-base/src/migrations/<filename>.sql (A|M|R) ===
   <full SQL>
   ```  
6. **OpenAPI updates:** print updated `openapi/api.yaml` (full if changed; else changed sections with context).  
7. **Docs Pack** (changed docs only, full contents):  
   - `docs/run-docs.md` — **consolidated** docs for this run (includes final **Outstanding TODO/Gaps** section)  
   - `docs/progress-ledger.md`  
   - `docs/framework-compliance.md`  
   - `docs/BASE_API_DOCUMENTATION.md`  
   - `docs/events-and-rpcs.md`  
   - `docs/db-schema.md`, `docs/migrations.md`, `docs/admin-ops.md`, `docs/security.md`, `docs/testing.md`  
   - `docs/modules/<module>.md`  
   - `docs/research-log.md`  
   - `docs/naming-map.md` (source → SRP)  
   - `docs/todo-gaps.md` (authoritative, prioritized list; **also appended** to end of `docs/run-docs.md`)  
8. **Completion line** (only if everything passes):  
   ```
   DONE — srp-base microservice baseline complete.
   ```

---

## 9) Reasoning & Fallbacks (Ultra Think)

**Loop per task:**
1. **Collect context** → **Plan** minimal coherent change set  
2. **Update OpenAPI** → **Implement** code → **Write migration** (idempotent)  
3. **Wire WS/Webhooks/Scheduler** if behavior implies push/loop  
4. **Validate** (OpenAPI lint, schema alignment) → **Refine**  
5. **Doc + Ledger** updates → **Commit**

**Fallback modes:**
- Reference fetch fails → log once: *“Reference resources unavailable; proceeding with internal consistency only.”* Continue with internal parity.  
- Duplicate migration numbers → auto-renumber to next free integer.  
- WS gateway or scheduler missing → create minimal scaffolds and proceed.  
- OpenAPI conflict (dual files) → **merge into root `openapi/api.yaml`, delete `src/openapi/api.yaml`**.  
- Incomplete time budget → move residuals to `docs/todo-gaps.md` and append to `docs/run-docs.md`.

---

## 10) Coding Conventions

- **Express** routers per domain, mounted under `/v1/<domain>`.  
- **Repositories** encapsulate DB access (parameterized queries).  
- **Migrations**: forward-only, idempotent (IF NOT EXISTS), with indexes/constraints.  
- **Responses**: consistent JSON envelope; proper 4xx/5xx semantics.  
- **Security**: `X-API-Token` + optional HMAC; rate limits; idempotency keys on mutations.  
- **Observability**: Pino logs (with `requestId`), Prometheus metrics (`/metrics`).  
- **Performance**: pagination/batching; indexes; avoid N+1; consider small TTL caches for hot reads.

---

## 11) Observability & Self-Instrumentation

Record per run:
- **Timings:** Phase A/B durations, per-task latencies.  
- **Footprint:** number of files changed (A/M/D/R), LoC delta, schema diffs.  
- **API diffs:** OpenAPI path/schema changes.  
- **Realtime checks:** WS namespaces created, event types added, webhook sinks affected.  
- **Outstanding items:** `docs/todo-gaps.md` + appended list in `docs/run-docs.md`.  
- **Research summary:** titles/links in `docs/research-log.md`.

---

## 12) File/Module Naming (SRP-Centric)

Prefer clear SRP names. Examples:
- `vehicles.routes.js`, `vehiclesRepository.js`, `vehicleConditionRepository.js`  
- `jobs.routes.js`, `dispatch.routes.js`, `evidence.routes.js`  
- `banking.routes.js`, `accountsRepository.js`, `ledgerRepository.js`  
- `phone.routes.js`, `outbox.routes.js`, `websites.routes.js`  
- `world.routes.js`, `doors.routes.js`, `zones.routes.js`

Maintain **`docs/naming-map.md`** (source term → SRP term). Add temporary alias endpoints **only if necessary**; mark as **deprecated** in OpenAPI.

---

## 13) Safety & Compliance

- Never exfiltrate secrets; never echo tokens.  
- Keep changes minimal/coherent; avoid churn.  
- Idempotent migrations; safe re-runs.  
- Respect **rate limits** and **auth** on all public endpoints.  
- Ensure **OpenAPI-first** validation and examples are correct.

---

## 14) End Conditions

- **If gaps remain:** document in `docs/todo-gaps.md` and append same list to bottom of `docs/run-docs.md`; stop.  
- **If no gaps:** run **Global Consistency & Compatibility Pass**; if clean, end with:  
  ```
  DONE — srp-base microservice baseline complete.
  ```

---

## 15) Quick Pseudocode (Mental Checklist)

```
init()
  detect default branch
  ensure express app, ws gateway, scheduler exist (create if missing)
  inventory code/openapi/migrations/docs

intake(resource)
  related = discover_related_resources(resource)
  refs = fetch_refs([resource, ...related], names/flows only)

plan = map_gaps_to_actions(refs, inventory)
  // classify: SKIP / EXTEND / CREATE

apply(plan)
  for each action in plan:
    update_openapi_first()
    write_route_repo_migration()
    wire_ws_or_webhooks_if_needed()
    update_docs_and_ledger()
    auto_repairs()
    validate_alignment()

consolidate_docs()
  write docs/run-docs.md (merged)
  update naming-map, framework-compliance, progress-ledger
  write docs/todo-gaps.md and append to run-docs.md

commit_push_pr()
  if changed_files: commit + push + open/update PR
  else: print "No changes required this run."
```
