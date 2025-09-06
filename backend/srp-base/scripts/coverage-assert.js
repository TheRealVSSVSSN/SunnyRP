#!/usr/bin/env node
import fs from 'fs';
const required=["np-base","baseevents","np-infinity","np-voice","np-log","np-scoreboard","np-votesystem","np-whitelist","rconlog","runcode","sessionmanager","spawnmanager","webpack","yarn","PolyZone","chat","connectqueue","coordsaver","cron","hardcap","jobsystem","koil-debug","koilWeatherSync","koillove","mapmanager","minimap","np-barriers","np-broadcaster","np-cid","np-errorlog","np-hospitalization","np-login","np-restart","np-secondaryjobs","np-taskbar","np-taskbarskill","np-taskbarthreat","np-tasknotify","pNotify","pPassword"];
const content=fs.readFileSync('backend/srp-base/docs/coverage-map.md','utf8').split('\n');
const paths=new Set();
for(const line of content){if(!line||line.startsWith('repo'))continue;const cols=line.split('|').map(p=>p.trim());if(cols.length<2)continue;paths.add(cols[1]);}
const missing=required.filter(r=>!paths.has(r));
if(missing.length){console.error('Missing coverage for paths:',missing.join(', '));process.exit(1);} else {console.log('coverage ok');}
