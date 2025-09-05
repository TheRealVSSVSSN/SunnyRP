# Coverage Map

## Summary Table
| repo | path | files | events | rpcs | loops | persistence | cluster | status |
|------|------|-------|--------|------|-------|-------------|---------|--------|
| NoPixelServer | np-base | 26 | 107 | 0 | 24 | 35 | sessions | SCANNED |
| NoPixelServer | baseevents | 4 | 5 | 0 | 4 | 0 | telemetry | SCANNED |
| NoPixelServer | np-infinity | 7 | 10 | 5 | 5 | 0 | world | SCANNED |
| NoPixelServer | np-voice | 19 | 83 | 5 | 13 | 0 | voice | SCANNED |
| NoPixelServer | np-log | 2 | 0 | 0 | 0 | 4 | telemetry | SCANNED |
| NoPixelServer | np-scoreboard | 3 | 16 | 0 | 4 | 0 | ux | SCANNED |
| NoPixelServer | np-votesystem | 3 | 123 | 1 | 3 | 37 | ux | SCANNED |
| NoPixelServer | np-whitelist | 2 | 0 | 0 | 2 | 3 | sessions | SCANNED |
| NoPixelServer | rconlog | 3 | 8 | 0 | 2 | 0 | telemetry | SCANNED |
| NoPixelServer | runcode | 7 | 15 | 1 | 2 | 0 | system | SCANNED |
| NoPixelServer | sessionmanager | 3 | 6 | 0 | 1 | 0 | sessions | SCANNED |
| NoPixelServer | spawnmanager | 2 | 2 | 7 | 3 | 0 | sessions | SCANNED |
| NoPixelServer | webpack | 4 | 0 | 0 | 0 | 0 | tooling | SCANNED |
| NoPixelServer | yarn | 3 | 0 | 0 | 2 | 2 | tooling | SCANNED |
| NoPixelServer | PolyZone | 14 | 49 | 0 | 17 | 0 | world | SCANNED |
| NoPixelServer | chat | 9 | 35 | 0 | 2 | 0 | ux | SCANNED |
| NoPixelServer | connectqueue | 4 | 8 | 1 | 7 | 0 | queue | SCANNED |
| NoPixelServer | coordsaver | 3 | 8 | 0 | 0 | 0 | world | SCANNED |
| NoPixelServer | cron | 2 | 1 | 0 | 1 | 0 | scheduler | SCANNED |
| NoPixelServer | hardcap | 3 | 3 | 0 | 2 | 0 | queue | SCANNED |
| NoPixelServer | jobsystem | 3 | 15 | 0 | 2 | 0 | jobs | SCANNED |
| NoPixelServer | koil-debug | 3 | 6 | 0 | 2 | 0 | telemetry | SCANNED |
| NoPixelServer | koilWeatherSync | 3 | 66 | 0 | 4 | 0 | world | SCANNED |
| NoPixelServer | koillove | 1 | 0 | 0 | 0 | 0 | ux | SCANNED |
| NoPixelServer | mapmanager | 4 | 18 | 0 | 4 | 0 | world | SCANNED |
| NoPixelServer | minimap | 2 | 0 | 0 | 3 | 0 | ux | SCANNED |
| NoPixelServer | np-barriers | 2 | 9 | 0 | 0 | 0 | world | SCANNED |
| NoPixelServer | np-broadcaster | 3 | 9 | 0 | 2 | 0 | comms | SCANNED |
| NoPixelServer | np-cid | 4 | 9 | 0 | 2 | 0 | sessions | SCANNED |
| NoPixelServer | np-errorlog | 3 | 1 | 0 | 0 | 0 | telemetry | SCANNED |
| NoPixelServer | np-hospitalization | 3 | 34 | 0 | 6 | 2 | world | SCANNED |
| NoPixelServer | np-login | 6 | 20 | 0 | 5 | 0 | sessions | SCANNED |
| NoPixelServer | np-restart | 3 | 38 | 0 | 1 | 0 | system | SCANNED |
| NoPixelServer | np-secondaryjobs | 3 | 185 | 0 | 1 | 2 | jobs | SCANNED |
| NoPixelServer | np-taskbar | 3 | 15 | 0 | 0 | 0 | ux | SCANNED |
| NoPixelServer | np-taskbarskill | 3 | 6 | 0 | 0 | 0 | ux | SCANNED |
| NoPixelServer | np-taskbarthreat | 3 | 5 | 0 | 0 | 0 | ux | SCANNED |
| NoPixelServer | np-tasknotify | 3 | 4 | 0 | 0 | 0 | ux | SCANNED |
| NoPixelServer | pNotify | 4 | 9 | 0 | 16 | 0 | ux | SCANNED |
| NoPixelServer | pPassword | 7 | 0 | 0 | 0 | 0 | security | SCANNED |
| essentialmode | . | 13 | 173 | 0 | 12 | 13 | sessions | SCANNED |
| es_extended | . | 40 | 127 | 0 | 25 | 14 | sessions | SCANNED |
| ND_Core-main | . | 40 | 79 | 6 | 9 | 22 | sessions | SCANNED |
| FiveM-FSN-Framework | . | 362 | 3007 | 0 | 510 | 81 | sessions | SCANNED |
| qb-core | . | 78 | 157 | 0 | 6 | 19 | sessions | SCANNED |
| vRP | . | 121 | 21 | 0 | 103 | 36 | sessions | SCANNED |
| vorp_core-lua | . | 50 | 176 | 17 | 16 | 29 | sessions | SCANNED |
| cfx-server-data | resources | 81 | 137 | 0 | 30 | 0 | world | SCANNED |

## Notes & Mapping
- `np-errorlog` informed the **telemetry** module for error log storage and broadcasting.
- Gateway now uses per-domain namespaces with validated handshakes.
- Source to SRP module mapping:
  - np-base → sessions
  - baseevents → telemetry
  - np-infinity → world (entity streaming)
  - np-voice → voice
  - np-log → telemetry
  - np-scoreboard → ux
  - np-votesystem → ux
  - np-whitelist → sessions
  - rconlog → telemetry
  - runcode → system
  - sessionmanager → sessions
  - spawnmanager → sessions
  - webpack → tooling
  - yarn → tooling
  - PolyZone → world
  - chat → ux
  - connectqueue → queue
  - coordsaver → world
  - cron → scheduler
  - hardcap → queue
  - jobsystem → jobs
  - koil-debug → telemetry
  - koilWeatherSync → world
  - koillove → ux
  - mapmanager → world
  - minimap → ux
  - np-barriers → world
  - np-broadcaster → voice (broadcast limit)
  - np-cid → sessions
  - np-errorlog → telemetry
  - np-hospitalization → world
  - np-login → sessions
  - np-restart → system
  - np-secondaryjobs → jobs
  - np-taskbar → ux
  - np-taskbarskill → ux
  - np-taskbarthreat → ux
  - np-tasknotify → ux
  - pNotify → ux
  - pPassword → security
- Additional frameworks (essentialmode, es_extended, ND_Core-main, FiveM-FSN-Framework, qb-core, vRP, vorp_core-lua) and cfx-server-data resources were scanned for parity; no direct module mapping.
