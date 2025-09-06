#!/usr/bin/env node
import fs from 'fs';
import { execSync } from 'child_process';
function parseArgs(){const args=process.argv.slice(2);const out={};for(let i=0;i<args.length;i+=2){const k=args[i].replace(/^--/,'');const v=args[i+1];out[k]=v;}return out;}
const opts=parseArgs();
if(!opts.repo||!opts.path){console.error('usage: research-log-append.js --repo <repo> --path <path> [--notes <text>]');process.exit(1);}
const baseDir=`${opts.repo}/${opts.path}`;
function run(cmd){try{return execSync(cmd,{stdio:['pipe','pipe','ignore']}).toString();}catch{return'';}}
const unique=list=>Array.from(new Set(list.filter(Boolean)));
const fileCount=run(`rg --files ${baseDir} | wc -l`).trim();
const events=unique(run(`rg "RegisterNetEvent\\(['\"]" ${baseDir} || true`).split('\n').map(l=>{const m=l.match(/RegisterNetEvent\(['"]([^'"\)]+)['"]/);return m?m[1]:null;}));
const rpcs=unique(run(`rg "RPC.register\\(['\"]" ${baseDir} || true`).split('\n').map(l=>{const m=l.match(/RPC.register\(['"]([^'"\)]+)['"]/);return m?m[1]:null;}));
const loops=unique(run(`rg "Citizen.CreateThread" ${baseDir} || true`).split('\n').filter(Boolean).map(()=> 'Citizen.CreateThread'));
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
