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

Manually verify PolicePack endpoints:

```sh
# Create a character for an account
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: c1' \
  -H 'Content-Type: application/json' \
  -d '{"first_name":"John","last_name":"Doe"}' \
  http://localhost:3010/v1/accounts/hex123/characters

# Select the character
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/accounts/hex123/characters/1:select

# Append custody entry
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: e1' \
  -H 'Content-Type: application/json' \
  -d '{"handlerId":1,"action":"bagged"}' \
  http://localhost:3010/v1/evidence/items/10/custody
```

Manually verify the zones endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/zones
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: z1' -H 'Content-Type: application/json' \
  -d '{"name":"prison","type":"poly","data":{}}' \
  http://localhost:3010/v1/zones
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/zones/1
```

Manually verify the wise audio endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/wise-audio/tracks/char123
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: w1' -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","label":"greeting","url":"http://example.com/greet.ogg"}' \
  http://localhost:3010/v1/wise-audio/tracks
```

Manually verify the wise imports endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/wise-imports/orders/char123
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: wi1' -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","model":"sultan"}' \
  http://localhost:3010/v1/wise-imports/orders
```

Manually verify the wise uc endpoints:

```
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/wise-uc/profiles/char123
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: uc1' -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","alias":"Shadow","active":true}' \
  http://localhost:3010/v1/wise-uc/profiles
```
