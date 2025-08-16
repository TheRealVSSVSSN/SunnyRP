-- resources/sunnyrp/vehicles/server/main.lua
SRP = SRP or {}
SRP.Vehicles = SRP.Vehicles or {}
local CFG = SRP.Vehicles.Config

-- In-memory live map: [vehId] = { entity=entityId, net=netId, lastSync=ms }
local Live = {}
-- Cached list of world vehicles (state=world)
local WorldList = {}  -- array of { id, model, plate, last_position, condition, ... }

-- Fuel hook (replace if you have a fuel resource)
SRP.Fuel = SRP.Fuel or {}
SRP.Fuel.Get = SRP.Fuel.Get or function(veh) return 100.0 end
SRP.Fuel.Set = SRP.Fuel.Set or function(veh, val) end

-- ========== Helpers ==========
local function vehKey(ent) return ('ent:%s'):format(tostring(ent)) end

local function fetchWorldVehicles()
  local res = SRP.Fetch({ path = '/vehicles?state=world', method = 'GET' })
  local list = {}
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.ok and obj.data then list = obj.data end
  end
  WorldList = list
end

local function ensureModel(model)
  local hash = (type(model) == 'string' and joaat(model)) or tonumber(model) or 0
  if not IsModelInCdimage(hash) then return 0 end
  if not HasModelLoaded(hash) then
    RequestModel(hash)
    local t = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(0) end
  end
  return hash
end

local function spawnVehicleRecord(rec)
  if Live[rec.id] and DoesEntityExist(Live[rec.id].entity) then return Live[rec.id].entity end
  local pos = rec.last_position or { x = 0.0, y = 0.0, z = 72.0, heading = 0.0, bucket = 0 }
  local hash = ensureModel(rec.model)
  if hash == 0 then return nil end

  local veh = CreateVehicle(hash, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0, pos.heading or 0.0, true, true)
  if not veh or veh == 0 then return nil end

  local netId = NetworkGetNetworkIdFromEntity(veh)
  SetNetworkIdExistsOnAllMachines(netId, true)
  SetEntityAsMissionEntity(veh, true, false)
  SetVehicleNumberPlateText(veh, tostring(rec.plate or 'SRP'))

  -- condition
  local cond = rec.condition or {}
  SetVehicleEngineHealth(veh, cond.engine or 1000.0)
  SetVehicleBodyHealth(veh, cond.body or 1000.0)
  SetVehicleDirtLevel(veh, cond.dirt or 0.0)
  if CFG.fuelHook then SRP.Fuel.Set(veh, cond.fuel or 100.0) end

  -- store live map
  Live[rec.id] = { entity = veh, net = netId, lastSync = GetGameTimer() }

  -- mark active in DB
  SRP.Fetch({ path = '/vehicles/state', method = 'POST', body = {
    vehicle_id = rec.id, active = true, active_entity = vehKey(veh), pos = rec.last_position, condition = rec.condition
  }})

  return veh
end

local function despawnVehicle(vehId)
  local live = Live[vehId]
  if not live then return end
  if DoesEntityExist(live.entity) then
    DeleteEntity(live.entity)
  end
  Live[vehId] = nil
end

local function distance2(a, b)
  local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
  return dx*dx + dy*dy + dz*dz
end

local function anyPlayerNear(pos, radius)
  local r2 = radius * radius
  for _, sid in ipairs(GetPlayers()) do
    local ped = GetPlayerPed(sid)
    if ped and ped ~= 0 then
      local p = GetEntityCoords(ped)
      if distance2({x=p.x,y=p.y,z=p.z}, pos) <= r2 then return true end
    end
  end
  return false
end

-- ========== Streaming controller ==========
CreateThread(function()
  fetchWorldVehicles()
  while true do
    -- spawn near players
    for _, rec in ipairs(WorldList) do
      if not Live[rec.id] then
        local pos = rec.last_position
        if pos and anyPlayerNear(pos, CFG.streamRadius) then
          spawnVehicleRecord(rec)
        end
      end
    end
    -- despawn far away
    for vehId, live in pairs(Live) do
      local rec
      for _, r in ipairs(WorldList) do if r.id == vehId then rec = r break end end
      if rec and rec.last_position and not anyPlayerNear(rec.last_position, CFG.despawnRadius) then
        despawnVehicle(vehId)
        -- keep DB active flag? We mark inactive on next sync; no-op here for perf
      end
    end
    Wait(2000)
  end
end)

-- ========== Periodic state sync ==========
CreateThread(function()
  while true do
    Wait(CFG.syncInterval)
    for vehId, live in pairs(Live) do
      if DoesEntityExist(live.entity) then
        local v = live.entity
        local x,y,z = table.unpack(GetEntityCoords(v))
        local h = GetEntityHeading(v)
        local cond = {
          engine = GetVehicleEngineHealth(v) + 0.0,
          body = GetVehicleBodyHealth(v) + 0.0,
          dirt = GetVehicleDirtLevel(v) + 0.0,
          fuel = CFG.fuelHook and (SRP.Fuel.Get(v) + 0.0) or nil
        }
        SRP.Fetch({ path = '/vehicles/state', method = 'POST', body = {
          vehicle_id = vehId, pos = { x=x, y=y, z=z, heading=h, bucket = 0 }, condition = cond, active = true, active_entity = vehKey(v)
        }})
      end
    end
  end
end)

-- ========== Ownership, keys, store/retrieve ==========
local function getActiveCharId(src)
  return SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
end

RegisterNetEvent('srp:vehicles:register', function(data)
  local src = source
  local charId = getActiveCharId(src); if not charId then return end
  local body = {
    owner_char_id = charId,
    model = tostring(data.model or 'sultan'),
    display_name = data.display_name or nil,
    plate = data.plate or nil,
    mods = data.mods or nil,
    condition = data.condition or nil
  }
  local res = SRP.Fetch({ path='/vehicles/register', method='POST', body=body })
  if res and res.status == 200 then
    TriggerClientEvent('srp:notify', src, 'Vehicle registered.')
  end
end)

-- Store (put away into hidden garage)
RegisterNetEvent('srp:vehicles:store', function(payload)
  local src = source
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end
  local res = SRP.Fetch({ path='/vehicles/store', method='POST', body={ vehicle_id = vehId, garage_id = payload.garage_id or nil } })
  if res and res.status == 200 then
    despawnVehicle(vehId)
    -- also update WorldList state
    for i, r in ipairs(WorldList) do if r.id == vehId then table.remove(WorldList, i) break end end
    TriggerClientEvent('srp:notify', src, 'Vehicle stored.')
  end
end)

-- Retrieve (spawn at position)
RegisterNetEvent('srp:vehicles:retrieve', function(payload)
  local src = source
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end

  local ped = GetPlayerPed(src)
  local p = GetEntityCoords(ped)
  local h = GetEntityHeading(ped)

  local pos = payload.position or { x = p.x, y = p.y, z = p.z, heading = h, bucket = 0 }
  local res = SRP.Fetch({ path='/vehicles/retrieve', method='POST', body={ vehicle_id = vehId, pos = pos } })
  if res and res.status == 200 then
    -- Refresh the record & spawn
    local rec = nil
    do
      local r2 = SRP.Fetch({ path='/vehicles?state=world', method='GET' })
      if r2 and r2.status == 200 then
        local ok, obj = pcall(function() return json.decode(r2.body or '{}') end)
        if ok and obj and obj.ok then
          WorldList = obj.data or WorldList
          for _, r in ipairs(WorldList) do if r.id == vehId then rec = r break end end
        end
      end
    end
    if rec then spawnVehicleRecord(rec) end
    TriggerClientEvent('srp:notify', src, 'Vehicle retrieved.')
  end
end)

-- Title transfer (owner must call)
RegisterNetEvent('srp:vehicles:title:transfer', function(payload)
  local src = source
  local fromChar = getActiveCharId(src); if not fromChar then return end
  if GetConvar('srp_veh_allow_title_transfer', 'true') ~= 'true' then return end
  local toChar = tonumber(payload.to_char_id or 0); if toChar <= 0 then return end
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end
  local res = SRP.Fetch({ path='/vehicles/transfer', method='POST',
    body={ vehicle_id=vehId, from_char_id=fromChar, to_char_id=toChar } })
  if res and res.status == 200 then
    TriggerClientEvent('srp:notify', src, 'Title transferred.')
  end
end)

-- Keys share/revoke
RegisterNetEvent('srp:vehicles:keys:grant', function(payload)
  local src = source
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end
  local targetChar = tonumber(payload.char_id or 0)
  if targetChar <= 0 and payload.target_src then
    targetChar = getActiveCharId(tonumber(payload.target_src))
  end
  if not targetChar then return end
  SRP.Fetch({ path='/vehicles/keys/grant', method='POST', body={ vehicle_id=vehId, char_id=targetChar, granted_by=getActiveCharId(src) } })
end)

RegisterNetEvent('srp:vehicles:keys:revoke', function(payload)
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end
  local targetChar = tonumber(payload.char_id or 0); if targetChar <= 0 then return end
  SRP.Fetch({ path='/vehicles/keys/revoke', method='POST', body={ vehicle_id=vehId, char_id=targetChar } })
end)

-- Impound / Junk (admin or damage logic)
RegisterNetEvent('srp:vehicles:impound', function(payload)
  local vehId = tonumber(payload.vehicle_id or 0); if vehId <= 0 then return end
  local yard = tostring(payload.yard_id or CFG.impoundYard)
  local reason = tostring(payload.reason or 'towed')
  SRP.Fetch({ path='/vehicles/impound', method='POST', body={ vehicle_id=vehId, yard_id=yard, reason=reason, fee=payload.fee or 0 } })
  despawnVehicle(vehId)
end)

-- Admin delete
RegisterNetEvent('srp:vehicles:admin:delete', function(vehId)
  vehId = tonumber(vehId or 0); if vehId <= 0 then return end
  SRP.Fetch({ path='/vehicles/'..vehId, method='DELETE' })
  despawnVehicle(vehId)
end)

-- When resource starts, mark all previous live as inactive (safety)
AddEventHandler('onResourceStart', function(res)
  if res ~= GetCurrentResourceName() then return end
  fetchWorldVehicles()
  -- best-effort: mark inactive will happen on next /state writes; no explicit call here to avoid spam
end)