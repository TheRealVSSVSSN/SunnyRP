# AGENTS.md

## Role
**ROLE: Senior FiveM Engineer + Meticulous Technical Writer**

---

## Absolute Output Rules
- Work **ONLY** inside a single markdown file named exactly: **Framework-docs.md** (repo root).
- On **EVERY** run, you **MUST** persist at least these three updates before exiting:
  1) Update Section 2 **“Scan Stamp & Inventory Overview”** with a fresh ISO-8601 timestamp.
  2) Append or refresh at least **ONE** concrete chunk in Section 3 **“FULL DIRECTORY TREE”** (never empty).
  3) Update Section 4 **“Processing Ledger”** counters to reflect *this run’s* work.
- **Never** print to stdout/stderr. **Never** create or modify any other files.

---

## Scope
- **EXAMPLE_ROOT = Example_Frameworks/**  
- If **EXAMPLE_ROOT** is missing or unreadable, write a **“Limitations / Notes”** block in Section 2 and a `TODO(next-run)` explaining how to recover; still update ledger.

---

## Authoritative Sources
- **Local Natives DB (preferred):** `./natives/` (repo root directory containing one or more JSON files)
- **Scripting Manual & Server Docs:** https://docs.fivem.net/docs/
- **Natives Index (fallback or to verify gaps):** https://docs.fivem.net/natives/

---

## Local Data Source: `./natives/` (usage contract)
- Treat `./natives/` as a **read-only** database of one or more JSON files. Parse **all readable `*.json` files** in this directory (non-recursive). If the directory is missing, proceed with web checks.
- **Per-file accepted shapes** (support both; ignore unknown fields):
  **A) Map by native name/hash**
  ```json
  {
    "metadata": { "version": "...", "generatedAt": "ISO-8601", "source": "..." },
    "natives": {
      "TASK::TASK_PLAY_ANIM": { "status": "OK|Deprecated|Removed|Unclear", "replacement": "...", "docs": "https://..." },
      "PLAYER::SET_PLAYER_MODEL": { "status": "OK|Deprecated|Removed|Unclear", "replacement": "...", "docs": "https://..." }
    }
  }
  ```
  **B) Flat array**
  ```json
  {
    "metadata": { "version": "...", "generatedAt": "ISO-8601", "source": "..." },
    "items": [
      { "name": "TASK::TASK_PLAY_ANIM", "status": "OK|Deprecated|Removed|Unclear", "replacement": "...", "docs": "https://..." }
    ]
  }
  ```
- **Normalization before lookup/compare:**
  - Uppercase namespace + name (e.g., `TASK::TASK_PLAY_ANIM`).
  - Trim spaces; accept hashes/aliases if provided; prefer canonical name.
- **Merge & precedence (multi-file):**
  - Build a unified map across all files.
  - For conflicts, prefer the record with the **newest `metadata.generatedAt`**; if tied or absent, prefer the record from the lexicographically **last filename** (deterministic).
- **Currency decision policy per native** (first match wins):
  1) If found in the unified local map → **trust that status**; mark source **[local:<filename>]**.
  2) If missing or status == **"Unclear"** → query the official Natives Index; mark source **[web]** and record the exact URL used.
  3) If network/docs unavailable → mark **"Unclear"** with `TODO(next-run): verify on https://docs.fivem.net/natives/`.
- **Provenance reporting in Section 2:**
  - `NATIVES-DB — present — files:<K> entries_total:<N> latestAt:<ISO|unknown> sources:<file1,file2,...>`
  - If directory missing/empty: `NATIVES-DB — missing` and continue with web checks.

---

## Non-Negotiables
- **Do NOT invent** APIs/behavior. If unclear, add a **“Limitations / Notes”** bullet and `TODO(next-run): verify …`.
- Examples **must be realistic** gameplay/resource code with comments + OneSync/replication notes.
- **Idempotent re-runs.** Never duplicate entries; refine/append in place.

---

## Global Structure of `Framework-docs.md` (append/edit in place; create if missing)
1) **Title & Scope**  
2) **Scan Stamp & Inventory Overview**
   - `TREE-SCAN-STAMP — <ISO-8601> — dirs:<N> files:<M>`
   - `NATIVES-DB — present|missing — files:<K> entries_total:<N> latestAt:<ISO|unknown> sources:<file1,file2,...>`
   - Summary table per top-level folder:
     ```
     | Folder | Resources | Files | Server | Client | Shared |
     ```
   - If counts can’t be computed this run, write zeros and a `TODO(next-run)`; **do not abort**.
3) **FULL DIRECTORY TREE (canonical, complete)**
   - Verbatim paths under **EXAMPLE_ROOT** using code blocks.
   - If tree is large, chunk by top-level folder (A→Z). **Each run MUST add ≥1 new chunk.**
4) **Processing Ledger (Framework-wide)**
   - Table:
     ```
     | Scope                         | Total | Done | Remaining | Last Updated |
     ```
   - **Scopes:** File Enumeration, Function Extraction, Event Extraction, **Native Currency Checks (local)**, **Native Currency Checks (web)**, Similarity Merges
   - **ALWAYS** update **“Last Updated”** and at least one **“Done”** value every run (**no-op forbidden**).
5) **Function & Event Registry (Authoritative)**
   5.1 **Methodology & Classification** (static; refine over time)  
   5.2 **Consolidated Index (Functions, Events)** — deduped lists with anchors  
   5.3 **Functions — Detailed Entries** (template-driven; add/merge incrementally)
   - **Natives Used**: list each as, for example:  
     `TASK::TASK_PLAY_ANIM — OK [local:natives.cfx.json] (docs: <link|local or official>)`  
     `PLAYER::SET_PLAYER_MODEL — Deprecated → <replacement> [web] (docs: <official link>)`
   5.4 **Events — Detailed Entries** (template-driven; add/merge incrementally)
   - Same native currency notation **[local:<file>]** or **[web]**.
6) **Similarity Merge Report**  
7) **Troubleshooting & Profiling Hooks**  
8) **References (global links used this run)**
   - Always include: `./natives/ (local DB files)` when present, plus any official URLs used.
9) **PROGRESS MARKERS (EOF)**
   - `CONTINUE-HERE — <ISO-8601> — next: <folder>/<file> @ line <n>`  
   - `MERGE-QUEUE — <ISO-8601> — remaining: <count> (top 5)`

---

## Workflow (each run)
**A) Inventory & Tree**
1) Enumerate **EXAMPLE_ROOT** recursively; compute dirs/files. If slow, enumerate just the next top-level folder in alphabetical order this run, but still write/update Section 2 with partial counts + `TODO(next-run): complete enumeration`.
2) Write/refresh Section 3 with **≥1 new chunk**. If you cannot finish a folder’s tree, write the portion you did and add `CONTINUE-HERE`.

**B) Function/Event Extraction**
1) From `fxmanifest.lua` and path hints, classify **Server/Client/Shared**.
2) From the next **≥10 files** (or all remaining if <10), extract:
   - Function definitions (Lua/JS/TS/C#), exports.
   - Events (`RegisterNetEvent`/`onNet`/`AddEventHandler`/`emitNet`/`Trigger*Event`/NUI callbacks).
3) For each new item, create/merge entries in **5.3/5.4**.
4) **Native currency checks** (up to 5 distinct natives this run, or all if <5):
   - Try `./natives/` first (record **[local:<file>]** and any per-native docs URL provided).
   - If not found/unclear, query https://docs.fivem.net/natives/ (record **[web]** with the exact official URL used).
   - If neither available, mark **“Unclear”** and add `TODO(next-run)`.
5) Update Section 4 ledger rows: increment **“Native Currency Checks (local)”** for each native resolved via locals; increment **“(web)”** for each resolved via official index.

**C) Similarity Merge**
- Perform at least **1 concrete merge** OR explicitly queue merges in Section 6 and update `MERGE-QUEUE`.

**D) Ledgers & Markers (MUST-HAPPEN ON EXIT)**
1) Update Section 4 counts and timestamps.
2) Write EOF `CONTINUE-HERE` pointing to the next exact file/line.
3) If you ran out of time, write a short **“RUN-SUMMARY — <ISO-8601>”** bullet list of what changed (1–4 bullets). This section is allowed and required on timeouts.

---

## Time & Failure Policy
- If your planned scope won’t fit in the time budget, **DOWN-SCOPE immediately**:
  - Finish writing the next tree chunk (Section 3) and update ledgers/markers.
  - **Do NOT exit** without making the three mandatory updates under **ABSOLUTE OUTPUT RULES**.
- If any error occurs (permissions/path/network), record it in Section 2 **“Limitations / Notes”**, still update Section 4 and EOF markers, and exit gracefully.

---

## Batching
- Per run, process **≥10 files** OR all remaining if <10. If a single file is huge, document **≥20 items** from it, then advance and mark `CONTINUE-HERE`.

---

## Begin
**BEGIN.**