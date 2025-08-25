# world module

Provides APIs to read and update global world state and manage weather forecasts.

## Routes

- `GET /v1/world/state`
- `POST /v1/world/state`
- `GET /v1/world/forecast`
- `POST /v1/world/forecast`

## Repository Contracts

- `getWorldState()` – fetch latest world state.
- `updateWorldState({ time, weather, density })` – append new world state.
- `getForecast()` – fetch latest forecast schedule.
- `updateForecast(forecast)` – store forecast array.

## Edge Cases

- Missing world state or forecast returns `null`.
- Forecast defaults to an empty array when not provided.
