# weathersync module

Provides weather synchronisation backed by api.weather.gov.

## Routes

- `GET /v1/weathersync/forecast`
- `POST /v1/weathersync/forecast`
- `GET /v1/weathersync/weather.gov?endpoint=`

## Repository Contracts

Uses `worldRepository` forecast methods:

- `getForecast()` – fetch latest forecast schedule.
- `updateForecast(forecast)` – store forecast array and broadcast.

## Edge Cases

- Proxy requests return upstream errors as `WEATHER_GOV_ERROR`.
- Scheduler skips if `WEATHERSYNC_ENABLED` or `WEATHER_GOV_POINT` not set.
