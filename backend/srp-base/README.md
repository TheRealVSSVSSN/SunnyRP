# srp-base

Node.js service providing core SunnyRP APIs and realtime gateway.

## Run
1. `cp .env.example .env`
2. `npm install`
3. `npm start`

## Endpoints
- `GET /v1/health`
- `GET /v1/ready`
- `GET /v1/info`
- `POST /v1/accounts/:accountId/characters`
- `GET /v1/accounts/:accountId/characters`
- `POST /v1/accounts/:accountId/characters/:characterId:select`
- `DELETE /v1/accounts/:accountId/characters/:characterId`
- `POST /internal/srp/rpc`

## Environment
See `.env.example` for tunables.
