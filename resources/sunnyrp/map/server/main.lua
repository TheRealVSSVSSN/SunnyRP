SRP = SRP or {}
SRP.Map = SRP.Map or {}
SRP.Map.__zones = SRP.Map.__zones or {}        -- id -> zone def (server copy with callbacks)
SRP.Map.__zoneIdSeq = 0
SRP.Map.__lastTelemetry = {}                   -- src -> last sent ms

-- ========== PUBLIC API ==========

-- Register a zone (server-side). Broadcasts to all players (or one, if targetSrc set)
-- def: { name, type='circle'|'poly', data={}, blip?={}, persist?=false, onEnter?=fn(src, z), onExit?=fn(src, z), targetSrc?=nil }
SRP.Map.RegisterZone = function(def)
  SRP.Map.__zoneIdSeq = SRP.Map.__zoneIdSeq + 1
  local id = SRP.Map.__zoneIdSeq
  def.id = id
  SRP.Map.__zones[id] = def

  -- optional: persist to backend map_zones
  if def.persist then
    SRP.Fetch({ path='/admin/audit', method='GET' }) -- no-op warmup
    -- fire-and-forget create (ignore duplicate name errors)
    local payload = {
      name = def.name or ('zone_'..id),
      type = def.type,
      data = def.data,
      blip = def.blip or nil,
      created_by = nil
    }
    -- Using createZone would need an endpoint; we only store via DB later. Omit network call here.
  end

  local target = def.targetSrc
  if target then
    TriggerClientEvent('srp:map:registerZone', target, { id = id, name = def.name, type = def.type, data = def.data, blip = def.blip or nil })
  else
    TriggerClientEvent('srp:map:registerZone', -1, { id = id, name = def.name, type = def.type, data = def.data, blip = def.blip or nil })
  end
  return id
end

-- Remove a zone
SRP.Map.RemoveZone = function(id)
  SRP.Map.__zones[id] = nil
  TriggerClientEvent('srp:map:removeZone', -1, id)
end

-- Simple blip registry without zone
-- blip: { id?, name, text, sprite, color, scale, coords={x,y,z}, shortRange=true }
SRP.Map.RegisterBlip = function(blip, targetSrc)
  TriggerClientEvent('srp:map:blip:add', targetSrc or -1, blip)
end

-- Routing bucket setter (and mirror to character_state via backend optional)
SRP.Map.SetBucket = function(src, bucket, opts)
  SetPlayerRoutingBucket(src, tonumber(bucket) or 0)
  if opts and opts.persist and SRP.Characters and SRP.Characters.activeBySrc and SRP.Characters.activeBySrc[src] then
    local charId = SRP.Characters.activeBySrc[src]
    SRP.Fetch({ path = '/characters/state/position', method='POST', body = { characterId = charId, position = nil, routing_bucket = bucket } })
  end
end

-- ========== EVENTS (client -> server) ==========

-- Zone enter/exit callbacks from clients
RegisterNetEvent('srp:map:zone:entered', function(zoneId)
  local src = source
  local z = SRP.Map.__zones[zoneId]
  if z and z.onEnter then
    pcall(z.onEnter, src, z)
  end
end)

RegisterNetEvent('srp:map:zone:exited', function(zoneId)
  local src = source
  local z = SRP.Map.__zones[zoneId]
  if z and z.onExit then
    pcall(z.onExit, src, z)
  end
end)

-- Telemetry intake from clients, throttled server-side and forwarded to backend
RegisterNetEvent('srp:map:telemetry:pos', function(payload)
  local src = source
  local interval = tonumber(GetConvar('srp_map_telemetry_interval_ms', '1500')) or 1500
  local now = GetGameTimer()
  local last = SRP.Map.__lastTelemetry[src] or 0
  if (now - last) < interval then return end
  SRP.Map.__lastTelemetry[src] = now

  -- find userId & active charId (from Phase B/C caches)
  local user = (SRP.Identity and SRP.Identity.cacheBySrc and SRP.Identity.cacheBySrc[src]) and SRP.Identity.cacheBySrc[src].user or nil
  local charId = (SRP.Characters and SRP.Characters.activeBySrc) and SRP.Characters.activeBySrc[src] or nil
  if not user or not charId then return end

  local body = {
    userId = user.id,
    characterId = charId,
    position = payload.position,
    routing_bucket = payload.routing_bucket or nil,
    speed = payload.speed or nil,
    ts = payload.ts or nil
  }
  local headers = {
    ['X-API-Token'] = SRP.Config.ApiToken,
    ['Content-Type'] = 'application/json',
    ['X-SRP-Telemetry'] = GetConvar('srp_map_telemetry', 'true')
  }
  -- We rely on SRP.Fetch (adds token); passing headers here only for reference
  SRP.Fetch({ path='/map/position', method='POST', body = body })
end)

-- Clean up cache
AddEventHandler('playerDropped', function() SRP.Map.__lastTelemetry[source] = nil end)

-- ========== EXAMPLE: register a sample zone at startup ==========
CreateThread(function()
  -- Example circle zone at Legion Square with a blip + callbacks
  local id = SRP.Map.RegisterZone({
    name = 'legion_square',
    type = 'circle',
    data = { center = { x = 215.76, y = -925.35, z = 30.69 }, radius = 60.0 },
    blip = { text = 'Legion Square', sprite = 280, color = 29, scale = 0.8, coords = { x = 215.76, y = -925.35, z = 30.69 }, shortRange = true },
    onEnter = function(src, z) TriggerClientEvent('chat:addMessage', src, { args = {'SRP', 'You entered ^2'..z.name} }) end,
    onExit  = function(src, z) TriggerClientEvent('chat:addMessage', src, { args = {'SRP', 'You left ^1'..z.name} }) end
  })
end)