# SRP Base Service

Node.js service providing base account and character management for SRP.

Version: 1.0.2

## Running

```
cd backend/srp-base
npm install
cp .env.example .env
npm start
```

Endpoints:
- `GET /v1/health`
- `GET /v1/ready`
- `GET /v1/info`
- `GET /v1/accounts/:accountId/characters`
- `POST /v1/accounts/:accountId/characters`
- `POST /v1/accounts/:accountId/characters/:characterId/select`
- `DELETE /v1/accounts/:accountId/characters/:characterId`

Internal RPC:
- `POST /internal/srp/rpc`

WebSocket namespace `/ws/base` requires `sid` and `accountId` query params.
