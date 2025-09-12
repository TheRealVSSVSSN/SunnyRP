# AGENTS.md

## Purpose
Generate a **single, authoritative `Framework-docs.md`** that completely documents every file, function, and event across the **Example_Frameworks/** folder.  
The goal is to produce a living reference for building a new framework by:

- Scanning **all** files and subfolders.
- Producing a full directory tree.
- Documenting and merging all functions and events, clearly labeled as **Server**, **Client**, or **Shared**.
- Verifying that all FiveM natives used are current against the official native documentation.

---

## Setup and Context
- **Repository Access:** Ensure the `Example_Frameworks/` folder and all of its subfolders are accessible for read-only scanning.  
- **Scope:** Document *every file*—Lua, JavaScript, C#, JSON, configuration, etc. Skip only obvious cache/temporary files if explicitly instructed.  
- **Environment:** This is a read-only task. The agent may list directories, parse files, and read content, but must not modify code.

---

## Documentation Output
Create a single Markdown file named **`Framework-docs.md`** at the repository root.

### Required Sections
1. **Title & Overview**  
   - Heading: `# Example_Frameworks Documentation`  
   - Short paragraph describing the folder’s purpose as the base for the new framework.

2. **Progress Ledger**  
   - Table with columns: `Scope | Total | Done | Remaining | Last Updated`.  
   - Scopes include:
     - File Enumeration
     - Function Extraction
     - Event Extraction
     - Native Currency Checks
     - Similarity Merges  
   - Update on every run.

3. **Directory Tree**  
   - A complete, canonical tree of every folder and file under `Example_Frameworks/`.  
   - Show all nested files/subfolders exactly once.

4. **Functions & Events (Merged Index)**  
   - **Classification:** Mark each item as **Server**, **Client**, or **Shared**.  
   - **Details per entry:**
     - **Name / Aliases**
     - **Defined In:** file paths and line ranges
     - **Purpose & Key Flows**
     - **Parameters & Returns**
     - **Natives Used** with currency status (`OK`, `Deprecated → replacement`, or `TODO(next-run): verify`).
     - **Examples:** Realistic Lua and/or JavaScript snippets with comments (no trivial `print` or `RegisterCommand`).
     - **Security / OneSync Notes**
     - **References** to official docs

   - Merge similar or duplicate functions/events into a single canonical entry and list aliases.

5. **Similarity Merge Report**  
   - Describe merges and any unresolved conflicts with `TODO(next-run)` markers.

6. **Progress Marker**  
   - At the very end of the document maintain a single line:
     ```
     CONTINUE-HERE — <ISO-8601 timestamp> — next: <folder>/<file> @ line <n>
     ```
   - Update each run so the agent can resume exactly where it left off.

---

## Execution Guidelines
1. **Initial Scan**  
   - Enumerate all files and build the full directory tree.
   - Count total directories and files; record in the Progress Ledger.

2. **File-by-File Documentation**  
   - Process files in a stable order (alphabetical or directory depth).  
   - Finish documenting one file completely before moving to the next.  
   - For each file:
     - Identify server/client/shared context from `fxmanifest.lua` or naming.
     - Extract and document every function and event as described above.

3. **Merging & Verification**  
   - Deduplicate functions/events by normalizing names and parameters.  
   - Cross-check every FiveM native call against https://docs.fivem.net/natives/ and note status.

4. **Batching & Time Management**  
   - Per run, process at least 10 files or ≥20 functions/events.  
   - If a file is very large, document ≥20 functions/events before moving on, then return in a later run.
   - Always update the Progress Ledger and CONTINUE-HERE marker at the end of each run.

---

## Writing Style
- Straightforward, technical tone with bullets and concise paragraphs.
- Comment every example; highlight OneSync/replication and security considerations.
- Use small pseudocode or function signatures only when needed—never copy full code.
- Neutral and descriptive; avoid speculation.

---

## Deliverable
A single, continuously updated **`Framework-docs.md`** that serves as:
- A **complete inventory** of the Example_Frameworks codebase.
- A **merged registry** of all functions and events with clear server/client/shared labeling.
- A **progress-tracked** guide for rebuilding the framework with up-to-date FiveM natives.
