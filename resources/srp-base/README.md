# srp-base Resource

Provides HTTP handler, RPC dispatch, and failover logic for SRP when the Node backend is degraded.

## Convars
- `srp_node_base_url` – Node service URL (default `http://127.0.0.1:4000`)
- `srp_internal_key` – Shared secret for internal calls

## Failover
The circuit breaker opens when the Node service is overloaded or unreachable. While open, mutations are queued and persisted via GHMattiMySQL (if available). Once the Node service recovers, queued mutations replay sequentially.
