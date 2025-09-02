# Security

- HMAC request signing via `x-srp-signature`.
- Rate limiting: 100 req/min per IP.
- Idempotency enforced through `Idempotency-Key` header stored in database.
- Bearer tokens validated with `JWT_SECRET`; scopes gate access.
- Idempotency enforced through `Idempotency-Key` header on mutating endpoints.
- Roles and permissions persisted in database; scopes aggregated at request time.
- Outgoing webhooks signed with `x-srp-signature` using endpoint secret.
- `/metrics` endpoint is unauthenticated; restrict access as needed.

