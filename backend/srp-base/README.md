# SRP Base Service

Node.js service providing base account and character management for SRP.

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

## Testing

```
cd backend/srp-base
npm install
npm test
```

Sample tests cover the in-memory repository and selected middleware (auth and idempotency). Add new tests under `tests/` with the `*.test.js` suffix.
