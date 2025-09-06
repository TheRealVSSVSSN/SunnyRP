# agents.md — **Generic, Resource‑Agnostic Build Agent** (Ultrathink, **Markdown‑Only**, **Research‑Aware**, Evidence‑Only)

> **Use case:** Runs in the **Codex website** (not a Node runtime).  
> **Absolute rule:** **All outputs are Markdown (`.md`) files**. No scripts, no shell commands, no external tooling assumptions.  
> **Behavior:** Attempt deep research first; **auto‑advance to implementation** as soon as the research checkpoint is satisfied or its budget is exceeded. Implementation emits **full code as fenced blocks inside Markdown “patch” files**.

---

## 0) Scope, Inputs, and Write Permissions

- **Inputs (from the run prompt):**
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

- **Write Scope (Markdown‑only delivery):**
  - **Research** → under `backend/<component>/docs/research/**.md`
  - **Implementation “patches”** → under `backend/<component>/docs/patches/**.md`
  - **Indexes/Manifests/Changelogs** → under `backend/<component>/docs/**.md`
  - Never claim to create code files on disk; **print full file contents** inside Markdown patches.

- **`srp-base` First (when applicable):**
  - If `srp-base` is in scope or present, treat it as the **framework contract**.
  - If editing another resource, **integrate with `srp-base`** (HTTP/WS/events/exports/schemas).
  - If `srp-base` is absent, proceed generically but **keep interfaces compatible** for later adoption.

- **Run budget:** Continue work until the evidenced queue is empty **or 25 minutes** have elapsed.

---

## 1) Authoritative Sources (consult during research)

- **FiveM Lua server functions:** https://docs.fivem.net/docs/scripting-reference/runtimes/lua/server-functions/  
- **FiveM Natives (UI):** https://docs.fivem.net/natives/  
- **Framework corpora to mine for signals (events/RPC/exports/loops):**
  - **NoPixel 3.0** (local mirror in repo): `Example_Frameworks/NoPixelServer` + the declared `paths[]`
  - **EssentialMode**: `Example_Frameworks/essentialmode`
  - **ESX**: `Example_Frameworks/es_extended`
  - **ND**: `Example_Frameworks/ND_Core-main`
  - **FSN**: `Example_Frameworks/FiveM-FSN-Framework`
  - **QB**: `Example_Frameworks/qb-core`
  - **vRP**: `Example_Frameworks/vRP`
  - **vORP**: `Example_Frameworks/vorp_core-lua`

> Treat these as **evidence**: extract names, signatures, flags, and behaviors. **Never** invent parameters or flows absent in evidence.

---

## 2) Run Mode — **Research‑Aware, Markdown‑Only, Auto‑Advance**

### Research Checkpoint (non‑blocking; emits `.md` only)
- **Budget:** **≤ 5 minutes** or **≤ 1,500 files/pages** total (whichever comes first).  
- **Scope:**  
  1) Enumerate **FiveM server functions** and build a local **server‑functions index**.  
  2) Build/refresh a **Natives index** (namespaces, availability, signatures) sufficient to document **every native you USE this run**.  
  3) Traverse declared framework `paths[]` to discover **signals** (events/RPC/exports/NUI/loops/persistence) without copying large code blocks.
- **Freeze & Continue:** When the budget ends **or** enough signals exist to proceed, **freeze research** and continue to implementation.

**Inline summary block (print once):**
```
RESEARCH SUMMARY (inline, md-only)
state=<FULL|PARTIAL|SKIPPED>; scanned=<N>; server_funcs=<count>
frameworks_scanned=[NoPixel, ESX, QB, vRP, ...]; paths_ok=<k>/<total>
events=[e1,e2,...]; rpcs=[r1,...]; nui=[n1,...]; loops=[l1,...]; tables=[t1,...]
notes=<one-liners>; sources=[<urls or local paths>]
RESEARCH CHECKPOINT COMPLETE — Continuing implementation.
```

**States**
- **FULL** — FiveM server functions & natives index summarized; framework signals mapped across all declared paths.  
- **PARTIAL** — Subset mapped; missing areas stubbed.  
- **SKIPPED** — Networking blocked or insufficient time; proceed with conservative defaults.

---

## 3) Where to Write Research (Markdown only)

Create/append the following **Markdown** files (tables and lists, no raw JSON dumps):

```
backend/<component>/docs/research/
  index.md                                # links to all below
  fivem-server-functions.md               # summarized server function catalog (+ official doc links)
  fivem-natives-index.md                  # alphabetical index with namespace, availability, brief summary
  natives/
    <NAMESPACE>/<NATIVE>.md               # one per native you USE or TOUCH this run (append more over time)
  frameworks/
    NoPixel/overview.md                   # high-level; versions, folder map
    NoPixel/signals.md                    # tables of events/RPC/exports/NUI/loops
    ESX/{overview.md,signals.md}
    ND/{overview.md,signals.md}
    FSN/{overview.md,signals.md}
    QB/{overview.md,signals.md}
    vRP/{overview.md,signals.md}
    vORP/{overview.md,signals.md}
  coverage-map.md                         # repo|path|files|events|rpcs|loops|persistence|status|notes
  gap-closure-report.md                   # SKIP|EXTEND|CREATE with evidence refs
  research-log.md                         # append-only log per scan target
```

### Per‑native page template (`docs/research/natives/<NAMESPACE>/<NATIVE>.md`)
```md
# <NATIVE_NAME> — <namespace>

**Sets:** <server|client|both>  
**Signature (Lua):**
```lua
<lua_signature_here>
```
**Parameters**  
- `<name>: <type>` — <desc>

**Returns** `<type>` — <desc>

**Summary** <1–3 lines distilled from official docs>  
**Caveats** <threading/timing/security>  
**Example (Lua)**
```lua
-- minimal example
```

**References**  
- FiveM Natives UI: <link>
- Scraped: `<ISO>`
```

> **Scope Control:** Always document every native you **use** this run. You may append more in deterministic order across runs. **Do not block implementation** waiting to finish the entire corpus.

---

## 4) Planning (Tiny & Non‑Blocking)

- Keep planning **inside research Markdown** (no separate tooling).  
- Convert research into a brief, frozen plan inside `docs/research/run-plan.md` with: contracts (events/RPC/HTTP/WS), payload schemas, headers (`X-Request-Id`, optional HMAC), error taxonomy, persistence sketch.  
- **Auto‑freeze** the moment the research checkpoint completes. Then continue.

---

## 5) Implementation — **Emit Code as Markdown Patches**

All implementation must be printed as fenced code blocks inside Markdown files under `docs/patches/**`. Provide **complete file contents** (no TODOs).

Create these **Markdown** patch files (names fixed; contents vary by run):

```
backend/<component>/docs/patches/
  001-node-server.md         # full code for src/server.js + middleware + routes + repositories + util
  002-lua-resource.md        # fxmanifest.lua + shared/srp.lua + server/http.lua + http_handler.lua + failover.lua + rpc.lua
  003-domain-stubs.md        # modules/base.lua (+ stubs for sessions.lua, voice.lua, ux.lua, world.lua, jobs.lua) with safe 501s
  004-readme-manifest.md     # minimal run instructions & manifest as Markdown
```

Each patch file must begin with a small **Diff Summary** table listing A/M/D/R for logical paths (informational).

---

## 6) Research‑Guided Coding Rules

- **Name adoption:** Prefer discovered signal names (normalize to REST on HTTP boundaries).  
- **Server vs client safety:** Never call client‑only natives on the server and vice versa. Guard with `IsDuplicityVersion()` if needed.  
- **Evidence gating:** If semantics are missing, emit a **501 stub** returning structured error JSON.  
- **Validation/Auth:** Apply request schema checks; secure internal routes with `X-SRP-Internal-Key` (or HMAC).  
- **Idempotency:** Support an idempotency key header for mutations where semantics are inferred but not fully evidenced.

---

## 7) Deliverables (Deterministic, Markdown‑only)

1. **Inline Research Summary** block (per §2).  
2. **Research Pack** under `docs/research/**`: `index.md`, `fivem-server-functions.md`, `fivem-natives-index.md`, `frameworks/**`, `coverage-map.md`, `gap-closure-report.md`, `research-log.md`, `run-plan.md`.  
3. **Implementation Patches** under `docs/patches/**`: `001-node-server.md`, `002-lua-resource.md`, `003-domain-stubs.md`, `004-readme-manifest.md`.  
4. **Top‑level Index** `docs/index.md` linking to everything generated this run.  
5. **CHANGELOG.md** (append full entry for this run) and **MANIFEST.md** (summary, env, compatibility).

**Completion line (print once):**  
`EXECUTION COMPLETE — Research frozen; evidence‑guided patches emitted as Markdown.`

---

## 8) Quality Gates (Hard)

- `docs/research/coverage-map.md` includes **all declared + discovered paths** with counts.  
- `docs/research/gap-closure-report.md` lists every CREATE/EXTEND with **evidence refs** and planned artifacts.  
- Health/Ready/Info endpoints present in patches when services are touched (or equivalent diagnostics for libs/UI).  
- All **mutating** endpoints validated in patches.  
- **Zero `TODO|FIXME|TBD|TBA`** anywhere.  
- Consistent namespacing; compatibility and aliases recorded in `docs/research/frameworks/*/signals.md` or `run-plan.md`.

---

## 9) Time & Fairness Policy

- Work until the queue is empty or **25 minutes** elapse.  
- Round‑robin domains/paths to avoid tunneling: `max_consecutive_per_bucket = 1`, `cooldown_span = 2`.  
- Prioritize: **dependencies → performance → user value**.

---

## 10) `srp-base` Compatibility Rules (when relevant)

- Prefer `srp-base` contracts for identity/sessions/characters/events/telemetry.  
- Reuse `srp-base` handlers/exports/HTTP/WS where feasible.  
- Add **compat aliases** for upstream naming diffs; note deprecations; capture in `docs/research/run-plan.md`.

---

## 11) Safety, Privacy, Compliance

- No secrets in code blocks; use env var placeholders and `.env.example` text in patches.  
- Respect licenses; copy **behaviors**, not full source.  
- Logs: avoid sensitive payloads; include requestId, route, status, latency, and only necessary actor identifiers.

---

## 12) Mandatory Doc Templates (copy verbatim)

### 12.1 `docs/research-log.md` (append‑only)
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

### 12.2 `docs/research/coverage-map.md` (header row)
```md
repo | path | files | events | rpcs | loops | persistence | cluster | status | notes
---|---|---:|---:|---:|---:|---|---|---|---
```

### 12.3 `docs/research/gap-closure-report.md` (per‑gap block)
```md
### [<type: SKIP|EXTEND|CREATE>] <name>
- evidence_refs: ["repo:path#Lstart-Lend", ...]
- artifacts_planned:
  - A/M: <logical file path>
- risk: <short>
- fallback: <mirror/queue/none>
```

---

**Use this `agents.md` verbatim for Codex.**  
It is stack‑agnostic, favors `srp-base` when present, performs **deep FiveM + Natives + NoPixel/other framework research**, writes research into **Markdown only**, then **auto‑advances** to emit complete implementation patches in Markdown.