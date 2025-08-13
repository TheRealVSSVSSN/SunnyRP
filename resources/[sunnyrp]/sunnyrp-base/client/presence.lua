-- sunnyrp-base/client/presence.lua
-- Client ticker that samples position/zone/street/talking and sends to server.

local function convarOr(name, def)
  local v = GetConvar(name, '')
  if v == '' then return def end
  return v
end

local ENABLED   = (convarOr('srp_map_telemetry', 'true') == 'true')
local INTERVAL  = tonumber(convarOr('srp_map_telemetry_interval_ms', '1500')) or 1500

if not ENABLED then return end

local lastTalking = false

local function getZoneName(coords)
  local zoneHash = GetNameOfZone(coords.x, coords.y, coords.z)
  return zoneHash or ''
end

local function getStreetName(coords)
  local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
  local name1 = s1 and GetStreetNameFromHashKey(s1) or ''
  local name2 = s2 and GetStreetNameFromHashKey(s2) or ''
  if name2 ~= '' and name2 ~= name1 then
    return name1 .. ' / ' .. name2
  end
  return name1
end

local function isOnFoot()
  local ped = PlayerPedId()
  return not IsPedInAnyVehicle(ped, false)
end

CreateThread(function()
  while true do
    Wait(INTERVAL)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then goto continue end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local talking = NetworkIsPlayerTalking(PlayerId()) == 1

    local payload = {
      pos = { x = coords.x+0.0, y = coords.y+0.0, z = coords.z+0.0 },
      heading = heading+0.0,
      zone = getZoneName(coords),
      street = getStreetName(coords),
      talking = talking,
      onFoot = isOnFoot(),
      t = GetGameTimer(),
    }

    -- If nothing changed (inc talking), server guard will still accept but ignore; we keep it simple here.
    TriggerServerEvent('srp:presence:sample', payload)

    lastTalking = talking
    ::continue::
  end
end)