# srp-base Backend

Express-based Node.js service providing REST, internal RPC, and WebSocket endpoints for SRP.

## Run

```sh
cd backend/srp-base
cp .env.example .env
npm install
npm start
```

## Endpoints
- `GET /v1/health`
- `GET /v1/ready`
- `GET /v1/info`
- `POST /internal/srp/rpc`
- `GET|POST|DELETE /v1/accounts/:accountId/characters`
