# world module

Provides APIs to read and update global world state, manage weather forecasts and control timecycle overrides.

## Routes

- `GET /v1/world/state`
- `POST /v1/world/state`
- `GET /v1/world/forecast`
- `POST /v1/world/forecast`
- `GET /v1/world/timecycle`
- `POST /v1/world/timecycle`
- `DELETE /v1/world/timecycle`
- `GET /v1/world/ipls`
- `POST /v1/world/ipls`
- `DELETE /v1/world/ipls/{name}`

## Repository Contracts

- `getWorldState()` – fetch latest world state.
- `updateWorldState({ time, weather, density })` – append new world state.
- `getForecast()` – fetch latest forecast schedule.
- `updateForecast(forecast)` – store forecast array.
- `getTimecycleOverride()` – fetch current timecycle override.
- `setTimecycleOverride({ preset, expiresAt })` – set override preset and optional expiry.
- `clearTimecycleOverride()` – remove active override.
- `list()` – list IPL states.
- `set(name, enabled)` – upsert IPL state.
- `remove(name)` – delete IPL state.

## Edge Cases

- Missing world state, forecast or timecycle override returns `null`.
- Forecast defaults to an empty array when not provided.
- Listing IPLs returns an empty array if none stored.
