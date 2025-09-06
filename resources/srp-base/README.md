# srp-base (Lua)

Failover glue for SunnyRP. Proxies to Node by default and stores data via GHMattiMySQL when Node is overloaded.

## ConVars
- `srp_internal_key` shared secret for Node↔Lua
- `srp_node_base_url` Node base URL (default http://127.0.0.1:4000)

## Failover
The circuit breaker opens when Node signals overload or becomes unreachable. During this time, writes queue and persist through GHMattiMySQL if present.
