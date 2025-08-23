# Security Notes

- All requests must include `X-API-Token`.
- Optional HMAC protection via `X-Ts`, `X-Nonce` and `X-Sig` headers.
- Mutating endpoints should provide `X-Idempotency-Key` for safe retries.
- Diamond blackjack routes inherit the same authentication and idempotency requirements.
