#!/usr/bin/env node
import fs from 'fs';
import { execSync } from 'child_process';

function parseArgs(){
  const args=process.argv.slice(2);
  const out={};
  for(let i=0;i<args.length;i+=2){
    const key=args[i].replace(/^--/, '');
    const val=args[i+1];
    out[key]=val;
  }
  return out;
}

const opts=parseArgs();
if(!opts.repo || !opts.path){
  console.error('usage: research-log-append.js --repo <repo> --path <path> [--notes <text>]');
  process.exit(1);
}
const baseDir=`${opts.repo}/${opts.path}`;
function run(cmd){
  try{
    return execSync(cmd,{stdio:['pipe','pipe','ignore'],encoding:'utf8'}).trim();
  }catch{
    return '';
  }
}
const fileList=run(`rg --files ${baseDir}`).split('\n').filter(Boolean);
const fileCount=fileList.length;
function collect(pattern){
  const out=new Set();
  const re=new RegExp(pattern,'g');
  for(const f of fileList){
    const data=fs.readFileSync(f,'utf8');
    let m; while((m=re.exec(data))){out.add(m[1]);}
  }
  return Array.from(out).slice(0,25);
}
const events=collect("RegisterNetEvent\\(['\"]([^'\"]+)['\"]");
const rpcs=collect("RPC\.register\\(['\"]([^'\"]+)['\"]");
const loops=run(`rg -l "Citizen\\.CreateThread" ${baseDir}`)?['Citizen.CreateThread']:[];
const persistence=[];
const notes=opts.notes||'';
const timestamp=new Date().toISOString().replace(/\.\d{3}Z$/,'Z');
let entry=`### [${timestamp}] ${opts.repo}:${opts.path}\n`;
entry+=`- files_scanned: ${fileCount}\n`;
entry+=`- signals:\n`;
entry+=`  - events: [${events.join(', ')}]\n`;
entry+=`  - rpcs: [${rpcs.join(', ')}]\n`;
entry+=`  - loops: [${loops.join(', ')}]\n`;
entry+=`  - persistence: [${persistence.join(', ')}]\n`;
entry+=`- notes: ${notes}\n`;
fs.appendFileSync('backend/srp-base/docs/research-log.md', entry);
