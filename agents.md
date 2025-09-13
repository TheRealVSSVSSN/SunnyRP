# AGENTS.md

## Purpose
Produce and continuously update a **single markdown file named `Framework-docs.md`** at the repository root.  
This file is the authoritative, living documentation for everything inside **`Example_Frameworks/`**.

---

## Absolute Output Rules
- Write **only** to `Framework-docs.md` (repo root).
- On **every run**, you must:
  1. Update **Section 2 – Scan Stamp & Inventory Overview** with a fresh ISO-8601 timestamp.
  2. Add or refresh at least **one concrete chunk** of the **FULL DIRECTORY TREE**.
  3. Update **Section 4 – Processing Ledger** counters.
- Never print to stdout/stderr. Never create or edit any other file.

---

## Sources
- **Local Natives DB (preferred):** `./natives.json`
- **FiveM Docs:** https://docs.fivem.net/docs/
- **FiveM Natives Index (fallback):** https://docs.fivem.net/natives/

### natives.json usage
- Parse once at run start if present.
- Accept either:
  ```json
  { "metadata": {...}, "natives": { "TASK::TASK_PLAY_ANIM": { "status": "...", "replacement": "...", "docs": "https://..." } } }
  ```
  or
  ```json
  { "metadata": {...}, "items": [ { "name": "TASK::TASK_PLAY_ANIM", "status": "...", "replacement": "...", "docs": "https://..." } ] }
  ```
- Normalize names to `NAMESPACE::NAME` (uppercase); trim spaces; accept hashes/aliases but prefer canonical name.
- Currency check order (first match wins):
  1. `natives.json` → status `[local]`.
  2. Official Natives Index → status `[web]` (record exact URL used).
  3. Else mark **Unclear** with `TODO(next-run): verify on https://docs.fivem.net/natives/`.
- Record DB provenance in Section 2:
  - `NATIVES-DB — present — entries:<N> — version:<v|unknown> — generatedAt:<ISO|unknown>`
  - or `NATIVES-DB — missing`.

---

## Required Sections in `Framework-docs.md`
1. **Title & Scope** – overview paragraph.
2. **Scan Stamp & Inventory Overview**
   - `TREE-SCAN-STAMP — <ISO-8601> — dirs:<N> files:<M>`
   - `NATIVES-DB — present|missing — entries:<N|0> — version:<v|unknown> — generatedAt:<ISO|unknown>`
   - Summary table:
     ```
     | Folder | Resources | Files | Server | Client | Shared |
     ```
3. **FULL DIRECTORY TREE** – complete verbatim tree of `Example_Frameworks/`, chunked A→Z if large. Each run MUST add ≥1 new chunk.
4. **Processing Ledger** – table:
   ```
   | Scope                      | Total | Done | Remaining | Last Updated |
   ```
   - Scopes:
     - File Enumeration
     - Function Extraction
     - Event Extraction
     - Native Currency Checks (local)
     - Native Currency Checks (web)
     - Similarity Merges
   - ALWAYS update `Last Updated` and at least one `Done` value every run.
5. **Function & Event Registry**
   5.1 **Methodology & Classification** (static; refine over time)  
   Explain classification rules:
   - From each resource’s `fxmanifest.lua` (`client_scripts`, `server_scripts`, `shared_scripts`).
   - Directory/name hints: `client/`, `server/`, `shared/`, `cl_*.lua`, `sv_*.lua`, etc.
   - Language patterns (Lua/JS/TS/C#).  
   Event detection patterns:
   - Lua: `RegisterNetEvent`, `AddEventHandler`, `TriggerServerEvent`, `TriggerClientEvent`, `TriggerEvent`, `exports(...)`
   - JS: `onNet`, `emitNet`, `on`, `exports`, `global.exports`, `RegisterNuiCallbackType`, `SendNUIMessage`
   - C#: `[EventHandler("...")]`, `TriggerClientEvent`, `TriggerServerEvent`

   5.2 **Consolidated Index (Functions, Events)** — deduped alphabetical lists with anchors.

   5.3 **Functions — Detailed Entries** (template-driven; deduped & merged)
   - **Name**: `<CanonicalFunctionName>` (Aliases: a, b, c)
   - **Type**: Server | Client | Shared
   - **Defined In**: file paths (line ranges if stable)
   - **Signature(s)**: actual parameter names/types (Lua/JS/C# as found)
   - **Purpose**: concise gameplay/system description
   - **Key Flows**: bullets (invocation, side effects, data in/out)
   - **Natives Used**: each native with currency and source tag, e.g.  
     `TASK::TASK_PLAY_ANIM — OK [local] (docs: <link>)`  
     `PLAYER::SET_PLAYER_MODEL — Deprecated → <replacement> [web] (docs: <official link>)`
   - **OneSync / Networking Notes**
   - **Examples**: runnable, commented (Lua & JS; add C# only if uniquely useful)
   - **Security / Anti-Abuse**
   - **References**: official URLs used
   - **Limitations / Notes** + `TODO(next-run): …` (if needed)

   5.4 **Events — Detailed Entries** (template-driven; deduped & merged)
   - **Event**: `<name>` (Aliases: …)
   - **Direction**: Client→Server | Server→Client | Intra-Client | Intra-Server
   - **Type**: NetEvent | LocalEvent | NUI | Export
   - **Defined In**: files/paths; line ranges if stable
   - **Payload**: args with semantics/types
   - **Typical Callers / Listeners**
   - **Natives Used** + currency status (`[local]`/`[web]`)
   - **OneSync / Replication Notes**
   - **Examples** (Lua & JS)
   - **Security / Anti-Abuse**
   - **References**

6. **Similarity Merge Report**
   - Canonicalization rules (case, separators, common prefixes `fsn_`, `qb-`, etc.)
   - Items merged (before → after)
   - Conflicts left open with `TODO(next-run): review merge semantics`

7. **Troubleshooting & Profiling Hooks** (brief, actionable)

8. **References** (global links used this run)  
   - Always include `./natives.json (local DB)` when present, plus any official URLs used.

9. **Progress Markers (EOF)**
   ```
   CONTINUE-HERE — <ISO-8601> — next: <folder>/<file> @ line <n>
   MERGE-QUEUE — <ISO-8601> — remaining: <count> (top 5)
   ```

---

## Execution Workflow
A) **Inventory & Tree**  
1) Enumerate `Example_Frameworks/` recursively; compute dirs/files. If slow, enumerate the next top-level folder this run, but still update Section 2 with partial counts + `TODO(next-run): complete enumeration`.  
2) Write/refresh **Section 3** with ≥1 new chunk each run. If a folder's tree is unfinished, write the portion done and add `CONTINUE-HERE`.

B) **Function/Event Extraction**  
1) Classify Server/Client/Shared via `fxmanifest.lua` and path hints.  
2) From the next ≥10 files (or all remaining if <10), extract functions/exports/events (Lua/JS/TS/C#).  
3) Create/merge entries in 5.3/5.4.  
4) Native currency checks (up to 5 distinct natives this run, or all if <5):  
   - Try `./natives.json` first `[local]`.  
   - If not found/unclear, use https://docs.fivem.net/natives/ `[web]` and record the exact URL.  
   - If neither available, mark **Unclear** + `TODO(next-run)`.
5) Update the **Processing Ledger** rows: increment “Native Currency Checks (local)” or “(web)” accordingly.

C) **Similarity Merge**  
- Perform at least 1 merge OR queue merges in Section 6 and update `MERGE-QUEUE`.

D) **Ledgers & Markers (must happen before exit)**  
1) Update Section 4 counts and timestamps.  
2) Write EOF `CONTINUE-HERE` pointer to the next exact file/line.  
3) If you ran out of time, add a short `RUN-SUMMARY — <ISO-8601>` bullet list of the run’s changes (1–4 bullets).

---

## Style
- Straightforward, concise, technical; prefer bullets and short paragraphs.
- Realistic examples only (no trivial `print`/demo `RegisterCommand`).  
- Comment code blocks; include OneSync/replication and security validation notes.  
- Idempotent: load existing `Framework-docs.md`, update in place, avoid duplication.

---

## Batching & Time Policy
- Per run, process ≥10 files OR all remaining if <10.  
- For a very large file, document ≥20 functions/events, then move on; return later.  
- If scope won’t fit the current time budget, DOWN-SCOPE immediately (write the next tree chunk + update ledger + progress marker) rather than exiting with no changes.