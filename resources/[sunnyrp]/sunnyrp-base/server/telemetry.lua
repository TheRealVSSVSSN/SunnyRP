-- Anti-cheat telemetry checks (speed/teleport) -> backend telemetry
local function maxSpeed() return (SRP_Config.AntiCheat.maxSpeedKmh or 280) end
local function maxTp()    return (SRP_Config.AntiCheat.maxTeleportMeters or 120) end

local lastPos = {}

RegisterNetEvent('srp:telemetry:sample', function(pos, speed)
  local src = source
  if type(pos) ~= 'table' then return end

  -- Speed check
  if speed and speed > maxSpeed() then
    SRP_HTTP.Fetch('POST', '/telemetry/anomaly', { src = src, kind = 'speed', speed = speed }, { retries = 0 })
  end

  -- Teleport check
  local prev = lastPos[src]
  lastPos[src] = { x = pos.x, y = pos.y, z = pos.z, t = GetGameTimer() }
  if prev then
    local dx, dy, dz = pos.x - prev.x, pos.y - prev.y, pos.z - prev.z
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    if dist > maxTp() then
      SRP_HTTP.Fetch('POST', '/telemetry/anomaly', { src = src, kind = 'teleport', meters = dist }, { retries = 0 })
    end
  end
end)

AddEventHandler('playerDropped', function()
  lastPos[source] = nil
end)