# Banking Module

Manages character bank accounts and transactions:
- Retrieve account balance
- Deposit funds
- Withdraw funds
- List transactions

## Security
- Requires `banking:read` or `banking:write` scopes via JWT.
- Mutating endpoints use Idempotency-Key headers.
