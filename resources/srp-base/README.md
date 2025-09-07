# SRP Base Lua Resource

Glue and failover layer for the SRP base service.

Version: 1.0.1

## ConVars
- `srp_internal_key` – shared secret with Node service
- `srp_node_port` – node port (default 4000)

When the Node service reports overload or becomes unreachable, the circuit breaker opens and writes are persisted via `ghmattimysql` if available.
