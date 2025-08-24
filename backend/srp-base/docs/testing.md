# Testing Notes

Automated test suites are not yet implemented. Manually verify the diamond blackjack endpoints after deployment:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/diamond-blackjack/hands/char123
```

Manually verify the interact sound endpoints:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: 1' \
  -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","sound":"ding","volume":0.5}' \
  http://localhost:3010/v1/interact-sound/plays
```

Manually verify the door endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/doors
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: 1' -H 'Content-Type: application/json' \
  -d '{"doorId":"front","locked":true}' http://localhost:3010/v1/doors
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: 2' -H 'Content-Type: application/json' \
  -d '{"locked":false}' http://localhost:3010/v1/doors/front/state
```
