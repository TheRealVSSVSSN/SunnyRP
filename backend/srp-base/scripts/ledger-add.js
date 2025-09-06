#!/usr/bin/env node
import fs from 'fs';
function parseArgs(){const args=process.argv.slice(2);const out={};for(let i=0;i<args.length;i+=2){out[args[i].replace(/^--/,'')]=args[i+1];}return out;}
const opts=parseArgs();
const required=['run','type','scope','artifact','rationale','evidence'];
for(const r of required){if(!opts[r]){console.error('missing --'+r);process.exit(1);}}
const artifacts=opts.artifact.split(',').map(a=>a.trim());
const evidences=opts.evidence.split(',').map(e=>`"${e.trim()}"`);
const timestamp=new Date().toISOString().replace(/\.\d{3}Z$/,'Z');
let entry=`## [${timestamp}] ${opts.run} ${opts.type}\n`;
entry+=`- scope: ${opts.scope}\n`;
entry+='- artifacts:\n';
for(const a of artifacts){entry+=`  - ${a}\n`;}
entry+=`- rationale: ${opts.rationale}\n`;
entry+=`- linked_evidence: [ ${evidences.join(', ')} ]\n`;
entry+=`- notes: ${opts.notes||''}\n`;
fs.appendFileSync('backend/srp-base/docs/progress-ledger.md',entry);
