# AGENTS.md — SRP‑BASE Build Agent

Runtime: container with shell, filesystem, and git access.  
Output: **single Markdown response**; all code in fenced blocks; no side effects.

---

## 0. Compatibility Contract
The agent adapts to two modes based on the run prompt.

### Mode A — SRP‑BASE Code‑First Prompt (STRICT)
Triggered when the prompt includes  
`# SRP-BASE — Code-First Prompt (Lua + Node.js)` **or** the line  
`Output sections (in this exact order):`.

Required sections (exact order, no extra prose):

1. **RESEARCH SUMMARY** (≤10 lines)  
2. `RESEARCH CHECKPOINT COMPLETE — Plan auto-frozen. Continuing implementation.`  
3. **DIFF SUMMARY** (A/M/D/R by path)  
4. **PATCHES** — for each file:  
   `--- FILE: <path>` followed by a fenced block containing the full file body  
5. `backend/srp-base/MANIFEST.md` (fenced ```md)  
6. `backend/srp-base/README.md` (fenced ```md)  
7. `resources/srp-base/README.md` (fenced ```md)  

### Mode B — Generic Markdown Patches (Fallback)
If Mode A is not triggered:

- Research pack under `docs/research/**`
- Patches under `docs/patches/**`
- `docs/index.md`, `MANIFEST.md`, `CHANGELOG.md`

All content remains inline in the single Markdown response.

---

## 1. Inputs & Scope
Prompt supplies:
- `Reset Ledger` (bool)  
- `reasoning_effort` (must be *Ultrathinking*)  
- Microservice/Resource name  
- Target platforms  
- Primary domains  
- Framework paths and priorities  

Write scope (Mode A): `backend/srp-base/**`, `resources/srp-base/**`.  
Mode B: use logical paths under `docs/**`.  
`srp-base` takes precedence when multiple resources are involved.

---

## 2. Research Checkpoint
- Timebox: ≤60 s or ≤200 files (Mode A) · ≤5 min or ≤1,500 files (Mode B)  
- Skim declared paths for signals (events/RPC/NUI/loops).  
- Summarize findings in **RESEARCH SUMMARY** and immediately print the checkpoint line.  
- Record only names/signatures/behaviors (no large code copies).

References (evidence only):

- https://docs.fivem.net/docs/scripting-reference/runtimes/lua/server-functions/  
- https://docs.fivem.net/natives/  
- `Example_Frameworks/**` (research hints only)

---

## 3. Global Constraints
- No `TODO/FIXME/TBD`.  
- Idempotent output; re-runs overwrite same paths.  
- Validate all mutating endpoints.  
- Internal calls require `X-SRP-Internal-Key`.  
- Structured logs with `X-Request-Id`, route, status, latency.  
- Server-only natives guarded with `IsDuplicityVersion()`.  
- No secrets; use `.env.example` placeholders.  
- Lua shared functions use `SRP.FunctionName = function()` style.

---

## 4. Technology Stack
- **Node.js ≥18** (Express allowed).  
- **MySQL** via direct queries (no ORM, no MariaDB).  
- Native WebSockets or `socket.io`.  
- **Lua 5.4** for FiveM server scripts.  
- **GHMattiMySQL** only during failover.  
- Pure HTML/CSS/JS for any NUI.

---

## 5. Deliverables

### Mode A — Code Files
Provide full file bodies for:

- `backend/srp-base/src/server.js`
- `backend/srp-base/src/util/luaBridge.js`
- `backend/srp-base/src/middleware/{requestId.js,rateLimit.js,hmacAuth.js,idempotency.js,validate.js,errorHandler.js}`
- `backend/srp-base/src/routes/base.routes.js`
- `backend/srp-base/src/repositories/baseRepository.js`
- `backend/srp-base/src/realtime/websocket.js` (optional)
- `backend/srp-base/package.json`
- `backend/srp-base/.env.example`
- `resources/srp-base/fxmanifest.lua`
- `resources/srp-base/shared/srp.lua`
- `resources/srp-base/server/http.lua`
- `resources/srp-base/server/http_handler.lua`
- `resources/srp-base/server/failover.lua`
- `resources/srp-base/server/sql.lua`
- `resources/srp-base/server/rpc.lua`
- `resources/srp-base/server/modules/{base.lua,sessions.lua,voice.lua,ux.lua,world.lua,jobs.lua}`
- `backend/srp-base/MANIFEST.md`
- `backend/srp-base/README.md`
- `resources/srp-base/README.md`

Formatting: `--- FILE: <path>` + fenced code block (LF endings).

### Mode B — Documentation Set
Sections to emit:

- `## RESEARCH SUMMARY`
- `## docs/research/index.md`
- `## docs/research/fivem-server-functions.md`
- `## docs/research/fivem-natives-index.md`
- `## docs/research/frameworks/<framework>/{overview.md,signals.md}`
- `## docs/research/coverage-map.md`
- `## docs/research/gap-closure-report.md`
- `## docs/research/research-log.md`
- `## docs/research/run-plan.md`
- `## docs/patches/001-node-server.md`
- `## docs/patches/002-lua-resource.md`
- `## docs/patches/003-domain-stubs.md`
- `## docs/patches/004-readme-manifest.md`
- `## docs/index.md`
- `## MANIFEST.md`
- `## CHANGELOG.md`

Each “patches” section lists `--- FILE: <path>` followed by full file content.

---

## 6. Quality Gates
- Mutating endpoints validated.  
- Health/Ready/Info endpoints present.  
- Deterministic, idempotent output.  
- Compatibility notes/aliases recorded (`README.md` or `run-plan.md`).

---

## 7. Time & Fairness
- Ultrathinking throughout.  
- Work until queue empty or 25 min elapsed.  
- Round‑robin: max 1 consecutive task per bucket, cooldown span = 2.

---

## 8. Safety & Compliance
- No secrets or license violations.  
- Logs exclude sensitive payloads.

---

## 9. CloudEvents Envelope Reference
```json
{
  "id": "evt_<uuid>",
  "type": "srp.<domain>.<action>",
  "source": "srp-base",
  "subject": "<characterId|accountId|entityId|*>",
  "time": "<ISO-8601>",
  "specversion": "1.0",
  "data": {}
}
Required headers: X-SRP-Internal-Key, X-Request-Id, Content-Type: application/json.
HTTP codes: 2xx success · 4xx validation/auth · 5xx server · optional Retry-After.

This AGENTS.md aligns with the container runtime, clarifies technology choices, and consolidates deliverables for efficient, compliant builds of the srp-base service and its Lua failover resource.
