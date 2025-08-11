SRP = SRP or {}
SRP.Map = SRP.Map or {}
local Zones = {}           -- id -> { type, name, data, inside=false }
local Blips = {}           -- id/name -> blip handle
local lastPos = nil
local lastBucket = 0

local function readConvarBool(name, def)
  return (GetConvar(name, def and 'true' or 'false') == 'true')
end

-- ========== Zone math ==========
local function pointInCircle(px, py, cx, cy, r)
  local dx, dy = px - cx, py - cy
  return (dx*dx + dy*dy) <= (r*r)
end

local function pointInPoly(px, py, poly)
  -- ray casting
  local inside = false
  local j = #poly
  for i=1,#poly do
    local xi, yi = poly[i].x, poly[i].y
    local xj, yj = poly[j].x, poly[j].y
    local intersect = ((yi>py) ~= (yj>py)) and (px < (xj-xi)*(py-yi)/(yj-yi+0.0000001)+xi)
    if intersect then inside = not inside end
    j = i
  end
  return inside
end

-- ========== Zone registration from server ==========
RegisterNetEvent('srp:map:registerZone', function(z)
  Zones[z.id] = { id=z.id, name=z.name, type=z.type, data=z.data, inside=false }
  -- optional blip
  if z.blip then
    local b = z.blip
    local blip = AddBlipForCoord(b.coords.x+0.0, b.coords.y+0.0, (b.coords.z or 0.0)+0.0)
    SetBlipSprite(blip, b.sprite or 1)
    SetBlipScale(blip, b.scale or 0.8)
    SetBlipColour(blip, b.color or 0)
    SetBlipAsShortRange(blip, b.shortRange ~= false)
    BeginTextCommandSetBlipName('STRING'); AddTextComponentString(b.text or z.name or 'Zone'); EndTextCommandSetBlipName(blip)
    Blips[b.name or z.name or ('zone_'..tostring(z.id))] = blip
  end
end)

RegisterNetEvent('srp:map:removeZone', function(id)
  if Zones[id] then Zones[id] = nil end
end)

RegisterNetEvent('srp:map:blip:add', function(b)
  local blip = AddBlipForCoord(b.coords.x+0.0, b.coords.y+0.0, (b.coords.z or 0.0)+0.0)
  SetBlipSprite(blip, b.sprite or 1)
  SetBlipScale(blip, b.scale or 0.8)
  SetBlipColour(blip, b.color or 0)
  SetBlipAsShortRange(blip, b.shortRange ~= false)
  BeginTextCommandSetBlipName('STRING'); AddTextComponentString(b.text or b.name or 'Blip'); EndTextCommandSetBlipName(blip)
  Blips[b.name or ('blip_'..tostring(b.id or math.random(10000)))] = blip
end)

-- ========== Telemetry + zone tick ==========
CreateThread(function()
  local telemetryOn = readConvarBool('srp_map_telemetry', true)
  local interval = tonumber(GetConvar('srp_map_telemetry_interval_ms', '1500')) or 1500
  local minMove = tonumber(GetConvar('srp_map_telemetry_min_move', '0.7')) or 0.7

  while true do
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local vx, vy, vz = table.unpack(GetEntityVelocity(ped))
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 2.236936 -- m/s -> mph approx

    -- Zone checks
    for _, z in pairs(Zones) do
      local inside = false
      if z.type == 'circle' then
        inside = pointInCircle(coords.x, coords.y, z.data.center.x, z.data.center.y, z.data.radius)
      elseif z.type == 'poly' then
        inside = pointInPoly(coords.x, coords.y, z.data.points)
        if inside and (z.data.minZ or z.data.maxZ) then
          local zOK = true
          if z.data.minZ and coords.z < z.data.minZ then zOK = false end
          if z.data.maxZ and coords.z > z.data.maxZ then zOK = false end
          inside = zOK
        end
      end

      if inside and not z.inside then
        z.inside = true
        TriggerServerEvent('srp:map:zone:entered', z.id)
      elseif (not inside) and z.inside then
        z.inside = false
        TriggerServerEvent('srp:map:zone:exited', z.id)
      end
    end

    -- Telemetry throttled client-side by interval & movement threshold; server also throttles
    if telemetryOn then
      local moved = 9999.0
      if lastPos then
        local dx, dy, dz = coords.x - lastPos.x, coords.y - lastPos.y, coords.z - lastPos.z
        moved = math.sqrt(dx*dx + dy*dy + dz*dz)
      end
      if not lastPos or moved >= minMove then
        local pos = { x = coords.x+0.0, y = coords.y+0.0, z = coords.z+0.0, heading = heading+0.0 }
        local bucket = GetPlayerRoutingBucket(PlayerId())
        TriggerServerEvent('srp:map:telemetry:pos', {
          position = pos,
          routing_bucket = bucket,
          speed = speed,
          ts = nil
        })
        lastPos = pos
        lastBucket = bucket
      end
    end

    Wait(interval)
  end
end)