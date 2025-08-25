# Database Utility

Provides low-level MySQL helpers for repositories. Supports named parameters (`@name`), scalar queries and multi-step transactions.

## Functions

| Function | Description |
|---|---|
| `query(sql, params)` | Execute a statement with positional or named parameters and return resulting rows. |
| `scalar(sql, params)` | Return the first column of the first row or `null` when no rows match. |
| `transaction(steps)` | Execute an array of `{ sql, params }` steps atomically. Returns `true` on commit and `false` on rollback. |
| `getConnection()` | Acquire a dedicated connection from the pool for manual transaction control. |

## Parameter formats

- Arrays: `[1, 2]` map to `?` placeholders.
- Objects: `{ id: 3 }` map to `@id` placeholders.

## Implementation details

- Repository file: `src/repositories/db.js`.
- Uses `mysql2/promise` connection pool with `utf8mb4` charset.
- Logs connection issues and transaction rollbacks via the shared logger.

