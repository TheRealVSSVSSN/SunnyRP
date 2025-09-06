# Manifest

## Summary
- Reset research docs and automation scripts.

## Files
| Path | Type | Notes |
|------|------|-------|
| docs/coverage-map.md | M | reformatted coverage table |
| docs/gap-closure-report.md | M | evidence-backed gaps |
| docs/research-log.md | M | regenerated entries |
| docs/research-summary.md | M | updated references |
| docs/index.md | M | refreshed TOC |
| docs/plan.json | A | plan scaffold |
| scripts/research-log-append.js | A | append research log entries |
| scripts/coverage-assert.js | A | verify coverage |
| scripts/plan-freeze.js | A | freeze research plan |
| scripts/ledger-add.js | A | progress ledger CLI |
| scripts/docs-validate.js | A | docs presence check |

## Startup/Env
- Requires `JWT_SECRET`, `SRP_HMAC_SECRET`, and MySQL connection settings.
