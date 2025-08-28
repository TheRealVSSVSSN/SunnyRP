# Manifest

- Added weather.gov proxy endpoints and periodic forecast sync.

| File | Action | Note |
|---|---|---|
| src/config/env.js | M | Added weathersync config block |
| src/routes/weathersync.routes.js | A | Forecast routes and weather.gov proxy |
| src/tasks/weathersync.js | A | Scheduler pulling api.weather.gov forecast |
| src/app.js | M | Mounted weathersync routes |
| src/server.js | M | Registered weathersync scheduler |
| openapi/api.yaml | M | Documented weathersync paths |
| docs/modules/weathersync.md | A | Module guide |
| docs/modules/world.md | M | Marked world forecast endpoints deprecated |
| docs/index.md | M | Logged weathersync update |
| docs/progress-ledger.md | M | Recorded koilWeatherSync entry |
| docs/naming-map.md | M | Added koilWeatherSync mapping |
| docs/events-and-rpcs.md | M | Mapped weathersync API |
| docs/BASE_API_DOCUMENTATION.md | M | Documented weathersync endpoints |
| docs/run-docs.md | M | Run summary |
| docs/research-log.md | M | Logged weather.gov research |
