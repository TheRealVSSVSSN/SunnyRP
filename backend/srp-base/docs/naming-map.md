# Naming Map

| Source Term | SRP Term | Notes |
|-------------|----------|-------|
| np-base | srp-base | baseline service |
| character | character | multi-character support |
| account | account | |
| wallet | bank account | character financial account |
| item | item | stored inventory item |
| time sync | system time | periodic server clock broadcast |
| group | role | permission grouping |
| permission | scope | JWT/DB access unit |
| cron | scheduler | periodic task runner |
| np-log | webhook dispatcher | logging sink |
| np-scoreboard | scoreboard | active player listing |
| np-errorlog | telemetry | error log storage |
| connectqueue | queue | connection queue |
| np-voice | voice | voice channel membership |
| np-whitelist | whitelist | account allowlist |
| hardcap | hardcap | session player limit |
| jobsystem | jobs | job registry |
| np-secondaryjobs | secondary job | additional job slot |
| koilWeatherSync | weather | environmental sync |
| np-login | login password | server login |
| np-cid | cid | character identifier |
| np-hospitalization | hospitalization | recovery tracking |
| PolyZone | zone | world zones |
| np-infinity | infinity | entity streaming |
| np-barriers | barrier | world barrier |
| chat | chat | messaging |
| np-votesystem | voting | |
| np-taskbar | taskbar | progress UI |
| np-broadcaster | broadcast | voice broadcast management |
| coordsaver | coordinates | save last position |
| spawnmanager | spawn | spawn lifecycle |
| np-taskbarskill | task skill | skill meter |
| np-taskbarthreat | task threat | threat meter |
| np-tasknotify | task notify | task notifications |
| pNotify | notification | generic notices |
| rconlog | rcon | command logging |
| runcode | exec | remote code execution |
| np-restart | restart | scheduled restarts |
| koil-debug | debug | debug hooks |
| koilWeatherSync | weather | environmental sync |
| socket namespace | domain namespace | per-domain WebSocket channel |