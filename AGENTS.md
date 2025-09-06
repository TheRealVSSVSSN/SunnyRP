# agents.md — **Generic, Resource‑Agnostic Build Agent** (Ultrathink, **Markdown‑Only**, **Research‑Aware**, Evidence‑Only) — *Codex‑Aligned for “SRP‑BASE — Code‑First Prompt”*

> **Runtime:** Runs on the **Codex website** (no shell/FS access).  
> **Absolute rule:** **All output is a single Markdown response**. No side effects, no external scripts.  
> **Goal:** Produce a **full, working base/framework** (Lua + Node.js) when directed by the prompt—never a minimal snippet.  
> **Method:** Research briefly → **auto‑freeze** → emit **complete file contents** as fenced code under the required sections.

---

## 0) Compatibility Contract — *Detect and Match the Prompt’s Output Format*

This agent adapts to **two output modes**:

### **Mode A — SRP‑BASE Code‑First Prompt Contract (STRICT)**
Trigger when the run prompt contains either:
- The heading `# SRP-BASE — Code-First Prompt (Lua + Node.js)` **or**
- The line `**Output sections (in this exact order):**`

**Then you MUST emit output in this exact order and format** (no extra prose, no trailing lines):

1. `RESEARCH SUMMARY` (≤10 lines; concise, single block)  
2. Print **exactly** this line once:  
   `RESEARCH CHECKPOINT COMPLETE — Plan auto-frozen. Continuing implementation.`  
3. `DIFF SUMMARY` — list A/M/D/R by path (logical repo paths)  
4. `PATCHES` — For each file, print:
   - Header line: `--- FILE: <path>`  
   - Then a fenced code block with the **entire file contents** using a correct language fence (```js, ```lua, ```json, ```md, ```yaml, etc.)  
   - No diff hunks; full bodies only; LF endings assumed.
5. **`backend/srp-base/MANIFEST.md`** — full contents as a fenced ```md block  
6. **`backend/srp-base/README.md`** — full contents as a fenced ```md block  
7. **`resources/srp-base/README.md`** — full contents as a fenced ```md block

> **Do not** print any other sections (no extra indexes, no completion line) in Mode A. Obey the prompt’s **Implementation Order** and “**Complete code, no TODOs**” rule.

### **Mode B — Generic Markdown‑Only Patches (Fallback)**
If the run prompt does **not** match Mode A, use the generic, research‑aware flow in this file (Markdown only) and write:
- Research pack under `docs/research/**` (as Markdown sections in the single response)
- Patches under `docs/patches/**` (as Markdown sections with fenced code)
- Top‑level `docs/index.md`, `MANIFEST.md`, `CHANGELOG.md` (as fenced ```md blocks)

> **Never** claim to write files to disk. Always emit contents inline in Markdown.

---

## 1) Inputs & Scope

**Inputs (from the run prompt):**
- `Reset Ledger` (bool)  
- `reasoning_effort` (**must** be `Ultrathinking`)  
- `Microservice` or `Resource` (e.g., `srp-base`, `np-police`, `ui/chat`)  
- `Target Platforms` (e.g., `FiveM`, `Web`, `CLI`, `RedM`)  
- `Primary Domains` (e.g., `[base]`, `[inventory, jobs]`)  
- `Main Framework` (name, repo, `paths: [...]`)  
- `Other Frameworks` (optional list)  
- `Resource Sources` (e.g., cfx server data)  
- `Feature Priorities` (performance/maintainability, parity targets)  
- `Use Research Summary` (bool)

**Write Scope (Markdown response only):**
- You **only** print Markdown in the response. All code must be inside fenced blocks.  
- When in **Mode A**, follow its **Output sections** exactly and omit everything else.  
- When in **Mode B**, use the directories described in §5 as **logical paths** inside headings.

**`srp-base` precedence:**
- If `srp-base` is in scope or present, treat it as the **framework contract**.  
- When touching other resources, **integrate with `srp-base`** (HTTP/WS/events/exports/schemas).  
- If `srp-base` is absent, keep interfaces **compatible** for future adoption.

**Run budget:** Work until the evidenced queue is empty **or 25 minutes** elapse (no early stopping).

---

## 2) Research Checkpoint (Non‑Blocking)

**Budget:** **≤ 60 seconds** or **≤ 200 files** for Mode A (per SRP‑BASE prompt); otherwise ≤ 5 minutes/≤ 1,500 files in Mode B.  
**Scope:**  
1) Skim **declared framework `paths[]`** for signals (events/RPC/exports/NUI/loops).  
2) Record only names/signatures/behaviors—not large code copies.  
3) Identify the natives you will use and confirm server vs client context.

**Inline Summary (Mode A exact wording):**
- Print a section titled `RESEARCH SUMMARY` with ≤10 lines.  
- Immediately print the line:  
  `RESEARCH CHECKPOINT COMPLETE — Plan auto-frozen. Continuing implementation.`

**States:** `FULL` | `PARTIAL` | `SKIPPED` (briefly indicated in the 10 lines, optional).

**Primary references (evidence only):**
- FiveM Lua (server): https://docs.fivem.net/docs/scripting-reference/runtimes/lua/server-functions/  
- FiveM Natives (UI): https://docs.fivem.net/natives/  
- Framework mirrors: `Example_Frameworks/NoPixelServer` and other listed frameworks in the prompt.

---

## 3) Implementation Rules (Both Modes)

- **No TODO/FIXME** — produce runnable code or return a **501** JSON response where semantics are unknown.  
- **Validation/Auth** — schema‑check mutations; protect internal routes via `X-SRP-Internal-Key` (or HMAC).  
- **Idempotency** — support an idempotency key for mutations where needed.  
- **Logging** — structured JSON with route, status, latency, and `X-Request-Id`.  
- **Server vs Client** — do not call client‑only natives on the server; guard with `IsDuplicityVersion()` if relevant.  
- **Naming** — adopt discovered signal names; normalize to REST at HTTP boundaries; provide **compat aliases** where needed.  
- **Security** — Lua bridge loopback only; never echo secrets; use `.env.example` content in patches instead.

---

## 4) Deliverables (Mode A — STRICT to match SRP‑BASE Prompt)

You **must** produce all deliverables enumerated by the **SRP‑BASE Code‑First Prompt** in its **exact** section order:

- `RESEARCH SUMMARY` (≤10 lines)  
- Checkpoint line (exact text)  
- `DIFF SUMMARY` for `backend/srp-base/**` and `resources/srp-base/**` (A/M/D/R)  
- `PATCHES` with **full contents** for:
  - `backend/srp-base/src/server.js`
  - `backend/srp-base/src/util/luaBridge.js`
  - `backend/srp-base/src/middleware/{requestId.js,rateLimit.js,hmacAuth.js,idempotency.js,validate.js,errorHandler.js}`
  - `backend/srp-base/src/routes/base.routes.js`
  - `backend/srp-base/src/repositories/baseRepository.js`
  - `backend/srp-base/package.json`
  - `backend/srp-base/.env.example`
  - *(optional)* `backend/srp-base/src/realtime/websocket.js`
  - `resources/srp-base/fxmanifest.lua`
  - `resources/srp-base/shared/srp.lua`
  - `resources/srp-base/server/http.lua`
  - `resources/srp-base/server/http_handler.lua`
  - `resources/srp-base/server/failover.lua`
  - `resources/srp-base/server/rpc.lua`
  - `resources/srp-base/server/modules/{base.lua,sessions.lua,voice.lua,ux.lua,world.lua,jobs.lua}`
- `backend/srp-base/MANIFEST.md` (fenced ```md)
- `backend/srp-base/README.md` (fenced ```md)
- `resources/srp-base/README.md` (fenced ```md)

> **Formatting of each patch:** Precede the code with `--- FILE: <path>` and then a single fenced block with the **entire** file body. Use correct language fences.

---

## 5) Deliverables (Mode B — Generic Markdown‑Only)

If Mode A is not triggered, emit the following **Markdown sections** in this single response:

```
## RESEARCH SUMMARY
## docs/research/index.md (md)
## docs/research/fivem-server-functions.md (md)
## docs/research/fivem-natives-index.md (md)
## docs/research/frameworks/NoPixel/{overview.md,signals.md} (md)
## docs/research/frameworks/{ESX,ND,FSN,QB,vRP,vORP}/{overview.md,signals.md} (md)
## docs/research/coverage-map.md (md)
## docs/research/gap-closure-report.md (md)
## docs/research/research-log.md (md)
## docs/research/run-plan.md (md)

## docs/patches/001-node-server.md (md with fenced code blocks for each file)
## docs/patches/002-lua-resource.md (md with fenced code blocks for each file)
## docs/patches/003-domain-stubs.md (md with fenced code blocks)
## docs/patches/004-readme-manifest.md (md with fenced code blocks)

## docs/index.md (md)
## MANIFEST.md (md)
## CHANGELOG.md (md)
```

**Inside each “patches” section**, include subsections like:
```
--- FILE: backend/srp-base/src/server.js
```js
// full contents
```
(Repeat for every file.)
```

---

## 6) Quality Gates

- All **mutating** endpoints validated.  
- Health/Ready/Info endpoints present when services are involved.  
- **Zero `TODO|FIXME|TBD|TBA`**.  
- Deterministic, idempotent output — re‑running yields the same logical paths with updated content.  
- Compatibility notes and aliases recorded (in Mode B: within `run-plan.md`; in Mode A: within `README.md` or code comments).

---

## 7) Time & Fairness

- **Ultrathinking** throughout.  
- Work until the queue is empty or **25 minutes** elapse.  
- Round‑robin domains/paths to avoid tunneling: `max_consecutive_per_bucket = 1`, `cooldown_span = 2`.

---

## 8) Safety, Privacy, Compliance

- No secrets in code; only `.env.example` placeholders.  
- Respect licenses; copy **behaviors**, not full source.  
- Logs avoid sensitive payloads; include requestId, route, status, latency, minimal actor identifiers.

---

## 9) Minimal Reference Snippets (for consistent shape)

**CloudEvents‑like envelope (shared):**
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
```

**Required headers:** `X-SRP-Internal-Key`, `X-Request-Id`, `Content-Type: application/json`  
**HTTP codes:** 2xx success; 4xx validation/auth; 5xx server; optional `Retry-After`.

---

### Operative Summary

- If the run prompt is the **SRP‑BASE Code‑First Prompt**, obey its **Mode A** contract exactly (sections, order, and patch formatting).  
- Otherwise, operate in **Mode B** and emit a complete research pack + patch set as Markdown.  
- In all cases, deliver **full file bodies**, enforce security & validation, and avoid placeholders.