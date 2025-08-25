# Testing Notes

Automated test suites are not yet implemented. Manually verify the diamond casino endpoints after deployment:

```sh
# Create a game
curl -H 'X-API-Token: <token>' -H 'Content-Type: application/json' -H 'X-Idempotency-Key: dc1' \
  -d '{"gameType":"blackjack"}' http://localhost:3010/v1/diamond-casino/games

# Place a bet
curl -H 'X-API-Token: <token>' -H 'Content-Type: application/json' -H 'X-Idempotency-Key: dc2' \
  -d '{"characterId":"char123","amount":100}' http://localhost:3010/v1/diamond-casino/games/1/bets

# Retrieve game with bets
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/diamond-casino/games/1
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
  -d '{"name":"prison","type":"poly","data":{},"expiresAt":"2025-12-31T00:00:00Z"}' \
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

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/cron/jobs
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: cron1' -H 'Content-Type: application/json' \
  -d '{"name":"paycheck","schedule":"0 * * * *","nextRun":"2025-08-24T00:00:00Z"}' \
  http://localhost:3010/v1/cron/jobs
Manually verify the coordsaver endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/coords
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: coord1' -H 'Content-Type: application/json' \\
  -d '{"name":"stash","x":1.0,"y":2.0,"z":3.0,"heading":90}' \\
  http://localhost:3010/v1/characters/1/coords
curl -H 'X-API-Token: <token>' -X DELETE -H 'X-Idempotency-Key: coord2' \\
  http://localhost:3010/v1/characters/1/coords/1
```

Manually verify the interiors endpoints:

```sh
curl -H 'X-API-Token: <token>' "http://localhost:3010/v1/apartments/1/interior?characterId=1"
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: int1' -H 'Content-Type: application/json' \\
  -d '{"characterId":1,"template":{}}' \\
  http://localhost:3010/v1/apartments/1/interior
```

Manually verify the emotes endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/emotes
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: emo1' -H 'Content-Type: application/json' \\
  -d '{"emote":"wave"}' \\
  http://localhost:3010/v1/characters/1/emotes
curl -H 'X-API-Token: <token>' -X DELETE -H 'X-Idempotency-Key: emo2' \\
  http://localhost:3010/v1/characters/1/emotes/wave
```
Manually verify the EMS endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/ems/records
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ems1' -H 'Content-Type: application/json' \\
  -d '{"patient_id":"1","doctor_id":"2","treatment":"bandaged"}' \\
  http://localhost:3010/v1/ems/records
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/ems/shifts/active
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ems2' -H 'Content-Type: application/json' \\
  -d '{"characterId":1}' http://localhost:3010/v1/ems/shifts
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ems3' http://localhost:3010/v1/ems/shifts/1/end
```

Manually verify the taxi endpoints:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: tx1' -H 'Content-Type: application/json' \
  -d '{"passengerCharacterId":1,"pickupX":0,"pickupY":0,"pickupZ":0}' \
  http://localhost:3010/v1/taxi/requests
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: tx2' -H 'Content-Type: application/json' \
  -d '{"driverCharacterId":2}' \
  http://localhost:3010/v1/taxi/requests/1/accept
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: tx3' -H 'Content-Type: application/json' \
  -d '{"driverCharacterId":2,"dropoffX":1,"dropoffY":1,"dropoffZ":1,"fare":50}' \
  http://localhost:3010/v1/taxi/requests/1/complete
```

Manually verify the furniture endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/furniture
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: furn1' -H 'Content-Type: application/json' \
  -d '{"item":"chair","x":0,"y":0,"z":0}' \
  http://localhost:3010/v1/characters/1/furniture
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: furn2' -X DELETE \
  http://localhost:3010/v1/characters/1/furniture/1
```

Manually verify the hospital admission endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/hospital/admissions/active
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hosp1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"reason":"injury"}' \
  http://localhost:3010/v1/hospital/admissions
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hosp2' \
  http://localhost:3010/v1/hospital/admissions/1/discharge
```

Manually verify the hardcap endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/hardcap/status
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hard1' -H 'Content-Type: application/json' \
  -d '{"maxPlayers":64,"reservedSlots":0}' \
  http://localhost:3010/v1/hardcap/config
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hard2' -H 'Content-Type: application/json' \
  -d '{"accountId":1,"characterId":1}' \
  http://localhost:3010/v1/hardcap/sessions
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: hard3' -X DELETE \
  http://localhost:3010/v1/hardcap/sessions/1
```

Manually verify the heli flight endpoints:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: heli1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"purpose":"patrol"}' \
  http://localhost:3010/v1/heli/flights
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: heli2' \
  http://localhost:3010/v1/heli/flights/1/end
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/heli/flights
```

Manually verify the import pack endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/import-pack/orders/character/1
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: imp1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"package":"starter","price":5000}' \
  http://localhost:3010/v1/import-pack/orders
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/import-pack/orders/1?characterId=1
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: imp2' \
  http://localhost:3010/v1/import-pack/orders/1/deliver
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: imp3' -H 'Content-Type: application/json' \
  -d '{"characterId":1}' \
  http://localhost:3010/v1/import-pack/orders/1/cancel

Manually verify the peds endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/ped
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: ped1' -H 'Content-Type: application/json' \
  -d '{"model":"mp_m_freemode_01","health":200,"armor":50}' \
  http://localhost:3010/v1/characters/1/ped
```

Manually verify the jailbreak endpoints:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: jb1' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"prison":"bolingbroke"}' \
  http://localhost:3010/v1/jailbreaks
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: jb2' -H 'Content-Type: application/json' \
  -d '{"success":true}' \
  http://localhost:3010/v1/jailbreaks/1/complete
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/jailbreaks/active
```

Manually verify the k9 endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/characters/1/k9s
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: k91' -H 'Content-Type: application/json' \
  -d '{"name":"Rex","breed":"German Shepherd"}' \
  http://localhost:3010/v1/characters/1/k9s
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: k92' -H 'Content-Type: application/json' \
  -d '{"active":true}' \
  http://localhost:3010/v1/characters/1/k9s/1/active
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: k93' -X DELETE \
  http://localhost:3010/v1/characters/1/k9s/1
Manually verify the jobs endpoints:
=======
=Manually verify the jobs endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/jobs
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: job1' -H 'Content-Type: application/json' \
  -d '{"name":"police","label":"Police"}' \
  http://localhost:3010/v1/jobs
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: job2' -H 'Content-Type: application/json' \
  -d '{"characterId":1,"jobId":1,"grade":0}' \
  http://localhost:3010/v1/jobs/assign
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/jobs/1/assignments
```

Manually verify the broadcaster endpoint:

```sh
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: bc1' -H 'Content-Type: application/json' \
  -d '{"characterId":1}' \
  http://localhost:3010/v1/broadcast/attempt
```

Manually verify the debug endpoint:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/debug/status
```

Manually verify the world state and forecast endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/world/state
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: 1' -H 'Content-Type: application/json' \
  -d '{"time":"12:00","weather":"CLEAR","density":{}}' \
  http://localhost:3010/v1/world/state
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/world/forecast
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: 2' -H 'Content-Type: application/json' \
  -d '{"forecast":[{"weather":"RAIN","duration":30}]}' \
  http://localhost:3010/v1/world/forecast
```

Manually verify the world timecycle endpoints:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/world/timecycle
curl -H 'X-API-Token: <token>' -H 'X-Idempotency-Key: tc1' -H 'Content-Type: application/json' \
  -d '{"preset":"w_xmas"}' \
  http://localhost:3010/v1/world/timecycle
curl -H 'X-API-Token: <token>' -X DELETE http://localhost:3010/v1/world/timecycle
```
