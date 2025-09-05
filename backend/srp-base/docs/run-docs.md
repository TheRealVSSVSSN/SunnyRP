# Run Documentation

## Summary
Implemented session login password verification, CID assignment, and hospitalization flows informed by NoPixel `np-login`, `np-cid`, and `np-hospitalization` resources.
Added world zone and barrier management guided by `np-infinity`, `PolyZone`, and `np-barriers`.
Introduced UX module with chat, voting, taskbar progress, and broadcast messaging inspired by `chat`, `np-votesystem`, `np-taskbar`, and `np-broadcaster`.
Extended telemetry with RCON logging, remote code execution, restart scheduling, and debug hooks based on `rconlog`, `runcode`, `np-restart`, and `koil-debug`.
Added tests ensuring new endpoints enforce authentication.
Implemented sessions whitelist and hardcap management informed by NoPixel `np-whitelist` and `hardcap` resources.
Introduced jobs module with primary and secondary job support inspired by `jobsystem` and `np-secondaryjobs`.
Added coordinate saving, spawn logging, broadcaster state, and expanded notifications guided by `coordsaver`, `spawnmanager`, `np-broadcaster`, `np-taskbarskill`, `np-taskbarthreat`, `np-tasknotify`, and `pNotify`.
Extended voice module with broadcast limits and active listing informed by `np-broadcaster`.
Added infinity entity coordinate tracking with scheduled purge based on `np-infinity`.
Added weather synchronization guided by `koilWeatherSync` with REST control and real-time broadcast.
Added tests ensuring sessions, jobs, and weather endpoints enforce authentication.
Added test ensuring sessions whitelist endpoints enforce authentication.
Refactored WebSocket gateway with domain namespaces, account and character validation, and broadcast rate limiting.

## Testing
- `npm test`

## Outstanding

- Scan for gaps