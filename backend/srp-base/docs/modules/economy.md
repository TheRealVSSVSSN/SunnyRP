# Economy Module

The **economy** module provides basic banking features for characters, including
account balances and peer-to-peer transfers. Balances are stored in whole cents
to avoid floating point errors.

## Feature flag

There is no feature flag for the economy module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/account`** | Retrieve or create the character's bank account. | 60/min per IP | Required | Yes | None | `BankAccount` |
| **POST `/v1/characters/{characterId}/account:deposit`** | Deposit funds into the account. | 30/min per IP | Required | Yes | `{ amount: integer }` | `{ balance: integer }` |
| **POST `/v1/characters/{characterId}/account:withdraw`** | Withdraw funds from the account, clamping at zero. | 30/min per IP | Required | Yes | `{ amount: integer }` | `{ balance: integer }` |
| **GET `/v1/characters/{characterId}/transactions`** | List recent transactions for the character. | 60/min per IP | Required | Yes | `limit` query optional | `{ transactions: Transaction[] }` |
| **POST `/v1/transactions`** | Transfer funds between characters. | 30/min per IP | Required | Yes | `TransactionCreateRequest` | `{ id: integer, senderBalance: integer }` |
| **GET `/v1/transactions/{id}`** | Retrieve a transaction by ID. | 60/min per IP | Required | Yes | None | `Transaction` |
| **POST `/v1/invoices`** | Create an invoice from one character to another. | 30/min per IP | Required | Yes | `InvoiceCreateRequest` | `{ id: integer }` |
| **GET `/v1/characters/{characterId}/invoices`** | List invoices involving the character. | 60/min per IP | Required | Yes | `status` query optional | `{ invoices: Invoice[] }` |
| **POST `/v1/invoices/{id}:pay`** | Pay an invoice. | 30/min per IP | Required | Yes | `{ characterId: string }` | `{ paid: boolean }` |
| **POST `/v1/invoices/{id}:cancel`** | Cancel an invoice. | 30/min per IP | Required | Yes | `{ characterId: string }` | `{ cancelled: boolean }` |

### Schemas

* **BankAccount** –
  ```yaml
  id: integer
  character_id: string
  balance: integer
  ```
* **Transaction** –
  ```yaml
  id: integer
  from_character_id: string
  to_character_id: string
  amount: integer
  reason: string | null
  created_at: string (date-time)
  ```
* **TransactionCreateRequest** –
  ```yaml
  fromCharacterId: string (required)
  toCharacterId: string (required)
  amount: integer (required)
  reason: string (optional)
  ```
* **Invoice** –
  ```yaml
  id: integer
  from_character_id: string
  to_character_id: string
  amount: integer
  reason: string | null
  status: string
  due_at: string | null (date-time)
  created_at: string (date-time)
  updated_at: string (date-time)
  ```
* **InvoiceCreateRequest** –
  ```yaml
  fromCharacterId: string (required)
  toCharacterId: string (required)
  amount: integer (required)
  reason: string (optional)
  dueAt: string (optional, date-time)
  ```

## Implementation details

* **Repository:** `src/repositories/economyRepository.js` manages accounts and transactions with parameterised SQL queries.
* **Migration:** `src/migrations/033_update_economy_character_scoping.sql` migrates economy tables to use `character_id` columns.
* **Routes:** `src/routes/economy.routes.js` exposes account and transaction endpoints with validation and standard response envelopes.
* **OpenAPI:** `openapi/api.yaml` defines `BankAccount`, `Transaction` and `Invoice` schemas and associated paths.
* **Realtime:** deposit, withdraw, transaction and invoice actions broadcast via WebSocket topic `banking` and webhook dispatcher.

## Future work

Future iterations may introduce loans, business accounts and scheduled payments.
