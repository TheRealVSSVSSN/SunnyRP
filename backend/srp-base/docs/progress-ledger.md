# Progress Ledger – SRP‑Base Node Backend

This ledger tracks our progress porting server behaviours from the
legacy resources repository into the unified `srp‑base` Node.js
backend.  For each resource processed, we record its index (based on
alphabetical ordering in the legacy `resources` directory), a brief
summary of its server responsibilities, our decision (Skip/Extend/Create),
and a reference to the patch or commit in this repository.  Only
server‑side logic is considered; purely client resources are skipped.
| Index | Resource | Summary of Server Responsibilities | Decision | Patch Reference |
|---|---|---|---|---|
