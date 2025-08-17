-- Regen OFF & RP globals
local function applyRegenOff()
  SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
  SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
end

local function applyRPGlobals()
  SetPedDensityMultiplierThisFrame(SRP_Config.QoL.densityScale or 0.8)
  SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
  SetVehicleDensityMultiplierThisFrame(0.8)
  SetRandomVehicleDensityMultiplierThisFrame(0.5)
  SetCreateRandomCops(false)
  SetCreateRandomCopsNotOnScenarios(false)
  SetCreateRandomCopsOnScenarios(false)
  DisablePlayerVehicleRewards(PlayerId())
  InvalidateIdleCam()
  InvalidateIdleCam()
  N_0x9e4cfff989258472() -- InvalidateIdleCam()
end

CreateThread(function()
  while true do
    applyRPGlobals()
    Wait(0)
  end
end)

AddEventHandler('playerSpawned', function()
  applyRegenOff()
end)

-- HUD relay
RegisterNetEvent('srp:ui:hud:set')
AddEventHandler('srp:ui:hud:set', function(delta)
  SendNUIMessage({ app = 'hud', action = 'set', payload = delta })
end)

-- Spawn choose (characters resource will open UI; base just signals)
RegisterNetEvent('srp:spawn:choose')
AddEventHandler('srp:spawn:choose', function()
  -- Optionally show a loading NUI; left blank by base
end)

-- Telemetry sampling
CreateThread(function()
  Wait(5000)
  while true do
    local ped = PlayerPedId()
    local vx,vy,vz = table.unpack(GetEntityVelocity(ped))
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 3.6
    local x,y,z = table.unpack(GetEntityCoords(ped))
    TriggerServerEvent('srp:telemetry:sample', {x=x,y=y,z=z}, speed)
    Wait(2000)
  end
end)