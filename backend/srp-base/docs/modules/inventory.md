# Inventory Module

Provides item storage for characters:
- List items
- Add item
- Remove item

## Security
- Requires `inventory:read` or `inventory:write` scopes via JWT.
- Mutating endpoints use Idempotency-Key headers.
