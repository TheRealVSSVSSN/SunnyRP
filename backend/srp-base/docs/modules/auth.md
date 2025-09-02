# Auth Module

Handles credential verification, JWT issuance, and refresh token rotation.

## REST Endpoints
- `POST /v1/auth/token` – exchange credentials for access and refresh tokens.
- `POST /v1/auth/refresh` – rotate refresh token and issue new access token.

## Security
- Access tokens signed with `JWT_SECRET`.
- Refresh tokens stored with expiry in `auth_tokens` table.
- Scopes augmented from database-stored roles.

