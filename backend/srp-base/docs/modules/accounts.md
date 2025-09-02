# Accounts Module

Provides multi-character account management:
- List characters
- Create character
- Select active character
- Soft-delete character

## Security
- Requires `accounts:read` or `accounts:write` scopes via JWT.
- Mutating endpoints use Idempotency-Key headers.