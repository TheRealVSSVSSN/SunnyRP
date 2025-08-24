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

Manually verify the wise wheels endpoints:

```
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/wise-wheels/spins/char123
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ww1' -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","prize":"cash"}' \
  http://localhost:3010/v1/wise-wheels/spins
```

Manually verify the boatshop endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/boatshop
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: b1' -H 'Content-Type: application/json' \
  -d '{"characterId":"char123","boatId":1,"plate":"SEA123"}' \
  http://localhost:3010/v1/boatshop/purchase
```

Manually verify the assets endpoints:

```
curl -H 'X-API-Token: <token>' "http://localhost:3010/v1/assets?ownerId=1"
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: a1' -H 'Content-Type: application/json' \
  -d '{"ownerId":1,"url":"https://example.com/img.png","type":"image/png"}' \
  http://localhost:3010/v1/assets
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/assets/1
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/assets/1
```

Manually verify the clothes endpoints:

```
curl -H 'X-API-Token: <token>' "http://localhost:3010/v1/clothes?characterId=1"
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: c1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"slot":"casual","data":{"pants":1}}' \
  http://localhost:3010/v1/clothes
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/clothes/1
```

Manually verify the apartments endpoints:

```sh
curl -H 'X-API-Token: <token>' "http://localhost:3010/v1/apartments?characterId=1"
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ap1' -H 'Content-Type: application/json' \
  -d '{"name":"Eclipse Tower","location":{},"price":1000}' \
  http://localhost:3010/v1/apartments
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ap2' -H 'Content-Type: application/json' \
  -d '{"characterId":1}' \
  http://localhost:3010/v1/apartments/1/residents
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/apartments/1/residents/1
```

Manually verify the economy endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/char123/account
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: b1' -H 'Content-Type: application/json' \
  -d '{"amount":100}' http://localhost:3010/v1/characters/char123/account:deposit
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: b2' -H 'Content-Type: application/json' \
  -d '{"amount":50}' http://localhost:3010/v1/characters/char123/account:withdraw
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: b3' -H 'Content-Type: application/json' \
  -d '{"fromCharacterId":"char123","toCharacterId":"char456","amount":25}' \
  http://localhost:3010/v1/transactions
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/char123/transactions
```

Manually verify the base events endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/base-events?limit=10
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: be1' -H 'Content-Type: application/json' \
  -d '{"accountId":"hex123","characterId":1,"eventType":"playerJoined"}' \
  http://localhost:3010/v1/base-events
```

Manually verify the camera endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/camera/photos/1
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: cam1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"imageUrl":"https://example.com/photo.jpg"}' \
  http://localhost:3010/v1/camera/photos
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/camera/photos/1
```

Manually verify the hud endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/hud
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hud1' -H 'Content-Type: application/json' \
  -d '{"speedUnit":"mph","showFuel":true}' \
  http://localhost:3010/v1/characters/1/hud
```

Manually verify the carwash endpoints:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: cw1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"plate":"ABC123","location":"downtown","cost":100}' \
  http://localhost:3010/v1/carwash
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/carwash/history/1
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/vehicles/ABC123/dirt
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: cw2' -H 'Content-Type: application/json' \
  -X PATCH -d '{"dirt":50}' http://localhost:3010/v1/vehicles/ABC123/dirt
```

Manually verify the chat endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/chat/messages/1
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: chat1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"channel":"ooc","message":"Hello"}' \
  http://localhost:3010/v1/chat/messages
```

Manually verify the connect queue priority endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/connectqueue/priorities
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: qp1' -H 'Content-Type: application/json' \
  -d '{"accountId":1,"priority":10,"reason":"donor"}' \
  http://localhost:3010/v1/connectqueue/priorities
curl -H 'X-API-Token: <token>' -X DELETE -H 'X-Idempotency-Key: qp2' http://localhost:3010/v1/connectqueue/priorities/1
```
