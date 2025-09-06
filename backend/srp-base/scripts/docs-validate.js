#!/usr/bin/env node
import fs from 'fs';
const required=[
'backend/srp-base/docs/coverage-map.md',
'backend/srp-base/docs/gap-closure-report.md',
'backend/srp-base/docs/research-log.md',
'backend/srp-base/docs/progress-ledger.md',
'backend/srp-base/docs/research-summary.md',
'backend/srp-base/docs/plan.json'
];
let ok=true;
for(const f of required){if(!fs.existsSync(f)||!fs.readFileSync(f,'utf8').trim()){console.error('missing or empty',f);ok=false;}}
if(!ok){process.exit(1);} else {console.log('docs ok');}
