#!/usr/bin/env node
import fs from 'fs';
const required=['backend/srp-base/docs/coverage-map.md','backend/srp-base/docs/gap-closure-report.md','backend/srp-base/docs/research-log.md'];
for(const f of required){if(!fs.existsSync(f)||!fs.readFileSync(f,'utf8').trim()){console.error('missing or empty',f);process.exit(1);}}
const plan={generatedAt:new Date().toISOString()};
fs.writeFileSync('backend/srp-base/docs/plan.json',JSON.stringify(plan,null,2));
console.log('plan frozen');
