# Scheduler Module

Persists and runs periodic tasks with drift control and jitter.

## Persistence
- `scheduler_runs` table stores `task_name` and `last_run`.

## Behavior
- Tasks register via `registerTask(name, intervalMs, handler)`.
- `scheduler.start()` loads previous run times and executes tasks.

## Security
- REST endpoints require `scheduler:read` or `scheduler:write` scopes.
