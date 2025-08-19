# Framework Compliance – Node.js Service

This document defines a **Framework Compliance Rubric** for the unified
`srp‑base` Node.js backend and evaluates the current implementation
against it.  The rubric is derived from authoritative sources on
Node.js project architecture and FiveM server scripting.  Each best
practice is supported by citations.

## Rubric – What a Robust Node.js Framework Should Have

| Aspect | Description | Source |
|---|---|---|
| **Layered architecture** | Separate concerns into controller (route), service and data access layers.  Avoid placing business logic directly in route handlers【675978276583475†L178-L186】.  The service layer encapsulates business rules and orchestrates workflows, while the data access layer handles persistence【675978276583475†L224-L239】. | LogRocket guide on Node.js architecture【675978276583475†L178-L186】【675978276583475†L224-L239】 |
| **Configuration management** | Store configuration and sensitive credentials in a dedicated `/config` directory and load them via environment variables.  Centralising config improves stability and prevents accidental leakage of secrets【675978276583475†L241-L256】. | LogRocket guide【675978276583475†L241-L256】 |
| **Service and data layers** | Introduce explicit service and repository layers to encapsulate business logic and database interactions.  This improves testability and separation of concerns【675978276583475†L224-L239】. | LogRocket guide【675978276583475†L224-L239】 |
| **Dependency injection** | Pass dependencies into modules instead of hard‑coding them.  DI simplifies unit testing, reduces coupling and improves scalability【675978276583475†L275-L294】. | LogRocket guide【675978276583475†L275-L294】 |
| **Unit testing** | Implement unit tests using frameworks like Mocha or Jest to verify correctness and catch regressions early【675978276583475†L325-L338】. | LogRocket guide【675978276583475†L325-L338】 |
| **Logging** | Use structured logging libraries (e.g. Pino or Winston) to produce machine‑readable logs that include context such as request IDs and trace IDs.  Proper logging aids debugging and auditing【896482121972210†L697-L725】. | ScoutAPM best practices【896482121972210†L697-L725】 |
| **Error handling** | Capture errors with `try/catch` and centralise error responses.  A unified error handler prevents uncaught exceptions from crashing the process【896482121972210†L731-L754】. | ScoutAPM best practices【896482121972210†L731-L754】 |
| **Event‑driven design** | Employ the publish–subscribe model to decouple modules and handle asynchronous workflows.  In FiveM, network events (`onNet`/`emitNet`) provide this mechanism【989807552563889†L150-L218】.  Node services can use event emitters or message queues to achieve similar decoupling【896482121972210†L403-L459】. | Cfx API docs【989807552563889†L150-L218】; ScoutAPM guide【896482121972210†L403-L459】 |
| **Clean code and modularity** | Use linters and formatters to enforce coding style; adhere to SOLID and DRY principles.  Break large modules into smaller ones and avoid global state【896482121972210†L482-L525】. | ScoutAPM best practices【896482121972210†L482-L525】 |
| **Environment management** | Load configuration from `.env` files using a library like `dotenv`.  Avoid hard‑coding secrets or tokens in source code【896482121972210†L592-L648】. | ScoutAPM best practices【896482121972210†L592-L648】 |
| **Testing & CI** | Integrate tests into a continuous integration pipeline.  Use test coverage reports to monitor code health and catch errors before deployment【896482121972210†L654-L694】. | ScoutAPM best practices【896482121972210†L654-L694】 |

## Evaluation of `srp‑base`

| Rubric Item | Compliance Notes |
|---|---|
| **Layered architecture** | The service follows a layered pattern: routes in `src/routes` handle HTTP requests, delegate business logic to repositories and service modules in `src/repositories` and `src/services`, and persist data via a MySQL adapter.  The core infrastructure (middleware, config, utils) is isolated from domain logic. |
| **Configuration management** | Configuration is centralised in `src/config/env.js`, which reads environment variables via `dotenv` and exposes defaults.  Secrets and tunables (API token, DB credentials, feature flags) are not hard‑coded. |
| **Service and data layers** | Domain logic is encapsulated in repository modules (e.g. `bennysRepository.js`, `doorsRepository.js`) and service files.  Routes remain thin controllers that perform validation and call repository functions. |
| **Dependency injection** | The current design uses simple factory functions and explicit imports.  While providers (e.g. for players) can be swapped via configuration, there is no dedicated DI container.  Introducing DI for repositories and external services could further improve testability. |
| **Unit testing** | There are no test suites in this repository.  Adding unit tests for repositories and routes using a framework such as Jest is recommended. |
| **Logging** | A structured logger is implemented in `src/utils/logger.js` using Pino.  Logs include timestamps and can be configured via environment variables.  Request IDs are attached via middleware. |
| **Error handling** | Errors are caught in route handlers and forwarded to a global error handler in `app.js`, which logs the error and returns a standard JSON envelope. |
| **Event‑driven design** | As an HTTP API the service does not implement an event bus, but it does persist domain events in an outbox table.  FiveM network events are handled by the Lua layer (outside this service) and forwarded via HTTP. |
| **Clean code and modularity** | The code is modular and uses CommonJS modules.  Each domain resides in its own file.  ESLint and Prettier configuration are absent; adding them would enforce consistent style. |
| **Environment management** | The `dotenv` library loads environment variables and the `env.js` config file ensures required variables are present. |
| **Testing & CI** | There is no CI pipeline or test suite.  Future work should include setting up continuous integration with linting and test execution. |

## Remaining Gaps / TODOs

* **Testing:** incorporate unit and integration tests using Jest or Mocha, and add a CI pipeline.
* **Dependency Injection:** refactor services and repositories to accept dependencies (such as the database connection) via constructors to improve testability.
* **Linting and Formatting:** add ESLint and Prettier configurations to enforce coding standards and catch issues early【896482121972210†L482-L525】.
* **Event bus:** implement an internal event emitter or message queue to decouple complex workflows if required by future features.
* **Enhanced Metrics:** expand Prometheus metrics to include domain‑specific counters and error rates.