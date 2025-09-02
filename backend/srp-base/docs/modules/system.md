# System Module

Provides service health and metadata endpoints and emits periodic server time to WebSocket clients and registered webhooks.

## Routes
- `GET /v1/health`
- `GET /v1/ready`
- `GET /v1/info`
- `GET /v1/time`
- `GET /metrics` – exposes default and per-route HTTP metrics

## WebSocket Events
- `srp.system.time` – periodic server time broadcast.

## Webhooks
- `srp.system.time` – delivered to all configured endpoints.

## Security
- Endpoints are public; no authentication required.
