-- resources/sunnyrp/telemetry/client/main.lua
SRP = SRP or {}
SRP.Telemetry = SRP.Telemetry or {}
local CFG = SRP.Telemetry.Config

local lastSent = 0
local last = nil

local function vec(x,y,z) return vector3(x or 0.0, y or 0.0, z or 0.0) end

CreateThread(function()
  while true do
    Wait(CFG.sampleMs)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then goto continue end

    local p = GetEntityCoords(ped)
    local onFoot = not IsPedInAnyVehicle(ped, false)
    local speed = GetEntitySpeed(ped) -- m/s (native returns m/s)
    local now = GetGameTimer()

    -- send only if post rate allows
    if (now - lastSent) >= CFG.postRateMs then
      lastSent = now
      TriggerServerEvent('srp:telemetry:sample', {
        pos = { x = p.x, y = p.y, z = p.z },
        onFoot = onFoot,
        speed = speed
      })
    end

    ::continue::
  end
end)