# AGENTS.md — SRP Build Agent (Resource‑Independent, Node.js + Lua, Failover-Ready)

**Runtime:** Container with shell, filesystem, and git access  
**Output:** Single Markdown response; all code in fenced blocks; **no external side effects**

---

## 0) Compatibility Contract (Two Modes)

**Mode A — Code‑First Prompt (STRICT)**  
Triggered if the run prompt contains either of these markers:
- `# SRP — Code-First Prompt` (or `# SRP-BASE — Code-First Prompt`), **or**
- the literal line `Output sections (in this exact order):`

When triggered, emit sections **in this exact order** (no extra prose before/after):
1. `RESEARCH SUMMARY` (≤10 lines)  
2. `RESEARCH CHECKPOINT COMPLETE — Plan auto-frozen. Continuing implementation.`  
3. `DIFF SUMMARY` (A/M/D/R by path)  
4. `PATCHES` — for each file:  
   `--- FILE: <path>` then a fenced block with the **full file body** (LF endings)  
5. `<backend/{SERVICE}/MANIFEST.md>` (fenced ```md)  
6. `<backend/{SERVICE}/README.md>` (fenced ```md)  
7. `<resources/{RESOURCE}/README.md>` (fenced ```md)

**Mode B — Generic Markdown Patches (Fallback)**  
If Mode A is **not** triggered, produce:
- Research pack under `docs/research/**`
- Patches under `docs/patches/**`
- `docs/index.md`, top‑level `MANIFEST.md`, `CHANGELOG.md`  
_All content remains inline in the single Markdown response._

> This agent is **resource‑independent**. Use **tokens** instead of hardcoded names:  
> `{SERVICE}` for the Node microservice folder under `backend/`, and `{RESOURCE}` for the FiveM Lua resource under `resources/`. Defaults if omitted: `{SERVICE}=srp-base`, `{RESOURCE}=srp-base`.

---

## 1) Inputs & Scope

The prompt supplies (directly or by convention):
- `Reset Ledger` (bool), `reasoning_effort` (`Ultrathinking` expected)  
- `{SERVICE}` (Node service name), `{RESOURCE}` (Lua resource name)  
- `Target Platforms`, `Primary Domains`  
- Optional **framework hints** (paths/references). Treat as **hints**, not truth.

**Write scope (Mode A):**
- `backend/{SERVICE}/**`
- `resources/{RESOURCE}/**` (and only this resource’s `fxmanifest.lua`)

**Write scope (Mode B):**
- `docs/**` only (no runtime code required in fallback).

If multiple services/resources are present, `{SERVICE}`/`{RESOURCE}` from the prompt take precedence.

---

## 2) Discovery & Signals (Adaptive, Resource‑Independent)

**Timebox:** Mode A ≤60 s or ≤200 files; Mode B ≤5 min or ≤1,500 files.  
Scan the repo for **signals** (names/flows only; no code copying):
- Event wiring: `RegisterNetEvent`, `TriggerEvent`, `TriggerClientEvent`, `AddEventHandler`
- RPC/callbacks: `RPC.register|execute`, `exports("…")`, `lib.callback.register|await`, `Callbacks:Server`
- NUI: `RegisterNUICallback`, `SendNUIMessage`, postMessage patterns
- Loops: `Citizen.CreateThread`, `SetTimeout`, `while true do`
- Persistence mentions: `.sql` tables, JSON stores
- Identity/session/queue/whitelist/login/scoreboard/voice/streaming/spawn hand‑offs
- Error/telemetry: logger hooks, rcon/restart/cron

**Files included:** `**/*.{lua,js,ts,json,sql,yml,yaml,md}`  
**Exclude:** `node_modules/.git/.github/dist/build`

Summarize top findings in **≤10 lines** under **RESEARCH SUMMARY**, then immediately print the checkpoint line (Mode A).

---

## 3) Global Constraints

- **No `TODO`/`FIXME`/`TBD`/`TBA`.**  
- Idempotent output; re‑runs overwrite the same paths predictably.  
- Validate **all mutating endpoints**.  
- Internal calls require `X-SRP-Internal-Key`.  
- Structured logs with `X-Request-Id`, route, status, latency.  
- Server‑only natives guarded with `IsDuplicityVersion()`.  
- No secrets; provide `.env.example` placeholders.  
- Lua shared functions use: `SRP.FunctionName = function(...) ... end`.

---

## 4) Technology Baseline

- **Node.js ≥ 18** (Express allowed).  
- **WebSockets** (native or socket.io).  
- **Lua 5.4** for FiveM server scripts.  
- **GHMattiMySQL** used **only** for **failover mode** (when Node is overloaded/down).  
- **Primary DB:** optional; start with **in‑memory** repositories by default.  
- **NUI:** pure HTML/CSS/JS if needed (not required for base wiring).

---

## 5) Required Deliverables (Mode A — Code‑First)

> Use **tokens** instead of fixed names. Replace `{SERVICE}` and `{RESOURCE}` when emitting files.

### A. Node.js service — `backend/{SERVICE}`
- `src/server.js` — Express app via `http.createServer(app)`; middleware chain (requestId → JSON → CORS → rateLimit → HMAC/Auth → Idempotency → Validation → error handler).  
  Endpoints:  
  - `GET /v1/health` → `{status:"ok",service, time}`  
  - `GET /v1/ready`  → `{ready:true, deps:[]}`  
  - `GET /v1/info`   → `{service, version, compat:{baseline:"srp-base"}}`  
  - `POST /internal/srp/rpc` (auth via `X-SRP-Internal-Key`) → CloudEvents‑like envelope; returns `{ok:true,result}`
- `src/routes/*.routes.js` — per‑domain routers (e.g., `base`, `sessions`, `ux`, `world`, `voice`, `jobs` as applicable to the prompt).  
- `src/repositories/*Repository.js` — **in‑memory** async repos (swap‑ready for SQL).  
- `src/middleware/{requestId.js,rateLimit.js,hmacAuth.js,idempotency.js,validate.js,errorHandler.js}` — minimal, working.  
- `src/util/luaBridge.js` — HTTP client to FiveM loopback (`http://127.0.0.1:${FX_HTTP_PORT}/{RESOURCE}<path>`).  
- `src/realtime/websocket.js` (optional) — heartbeat, backpressure.  
- `package.json` + `.env.example` + `README.md` + `MANIFEST.md`.

### B. Lua resource — `resources/{RESOURCE}`
- `fxmanifest.lua` — `lua54 'yes'`; `server_scripts { "server/**/*.lua" }`; `shared_scripts { "shared/**/*.lua" }`
- `shared/srp.lua` — global `SRP` table; simple export helper.  
- `server/http.lua` — robust HTTP wrappers: try `PerformHttpRequestAwait` → promise/Await → `PerformHttpRequest` fallback.  
- `server/http_handler.lua` — `SetHttpHandler` multiplexer; routes:  
  - `GET /v1/health` (ok JSON)  
  - `POST /internal/srp/rpc` (auth header; decode body; dispatch to `SRP.RPC.handle`)
- `server/failover.lua` — circuit breaker (`CLOSED/OPEN/HALF_OPEN`), exponential backoff (max 30s), queue idempotent mutations during OPEN, replay on recovery.
- `server/sql.lua` — **failover‑only** persistence via **GHMattiMySQL** (guard all calls; no hard dependency if not installed).
- `server/rpc.lua` — `SRP.RPC.handle(envelope)`; dispatch by `type` (`srp.<domain>.<action>`); return `{result}` or `{error}`.
- `server/modules/*.lua` — minimal per‑domain handlers (e.g., `base.lua`, `sessions.lua`, `voice.lua`, `ux.lua`, `world.lua`, `jobs.lua`). Should be **safe** (return 501 JSON where unimplemented).  
- `README.md` (usage + convars).

### C. Docs (tiny, but useful)
- `backend/{SERVICE}/MANIFEST.md` (what was added; env vars; how to run).  
- `backend/{SERVICE}/.env.example` (e.g., `PORT`, `FX_HTTP_PORT`, `SRP_INTERNAL_KEY`).

---

## 6) Quality Gates

- Health/Ready/Info present.  
- Mutating endpoints validated; idempotency supported.  
- Internal RPC secured with `X-SRP-Internal-Key`.  
- Deterministic, idempotent output.  
- Compatibility notes/aliases recorded in README/MANIFEST.  
- Server logs exclude sensitive payloads.  
- Lua failover path **works without** MySQL being present (no‑ops with clear warnings).

---

## 7) Time & Fairness

- `Ultrathinking` throughout.  
- Work until queue empty or 25 min elapsed.  
- Round‑robin: max 1 consecutive task per bucket; cooldown span = 2 buckets.

---

## 8) Safety & Compliance

- No secrets or license violations.  
- Respect **resource‑independent** discovery; treat external paths as hints, never as requirements.  
- Never copy external code verbatim; extract **names/flows** only.

---

## 9) CloudEvents Envelope (reference)

```json
{
  "id": "evt_<uuid>",
  "type": "srp.<domain>.<action>",
  "source": "{SERVICE}",
  "subject": "<characterId|accountId|entityId|*>",
  "time": "<ISO-8601>",
  "specversion": "1.0",
  "data": {}
}
```

**Required headers:** `X-SRP-Internal-Key`, `X-Request-Id`, `Content-Type: application/json`  
**HTTP codes:** 2xx success · 4xx validation/auth · 5xx server · optional `Retry-After`

---

### Quick Notes for Implementers

- **Loopback only** for Node↔Lua bridge; never expose publicly.  
- If `SetHttpHandler` already in use, compose: try ours first then delegate on 404.  
- Without DB, repositories remain in‑memory; failover SQL file **must not crash** when GHMattiMySQL is missing.  
- Keep module names **generic** and **SRP‑named**; don’t hardcode upstream prefixes.
