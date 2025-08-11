-- Apply world toggles on the client: regen, dispatch, density, respawn control.

local world = { disableRegen=true, autoRespawn=false, disableDispatch=true, density=0.8 }

RegisterNetEvent('srp:world:cfg')
AddEventHandler('srp:world:cfg', function(cfg)
  for k,v in pairs(cfg or {}) do world[k] = v end
end)

CreateThread(function()
  while true do
    -- Health regen
    if world.disableRegen then
      SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
      SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
    end

    -- Dispatch / cops / randoms
    if world.disableDispatch then
      DisablePlayerVehicleRewards(PlayerId())
      SetCreateRandomCops(false)
      SetCreateRandomCopsNotOnScenarios(false)
      SetCreateRandomCopsOnScenarios(false)
    end

    -- Density (ped/veh)
    local d = world.density or 0.8
    SetVehicleDensityMultiplierThisFrame(d)
    SetPedDensityMultiplierThisFrame(d)
    SetScenarioPedDensityMultiplierThisFrame(d, d)
    SetRandomVehicleDensityMultiplierThisFrame(d)
    SetParkedVehicleDensityMultiplierThisFrame(d)

    Wait(0)
  end
end)

-- Prevent auto respawn by blocking the default flow (simple approach)
local lastAlive = true
CreateThread(function()
  while true do
    local ped = PlayerPedId()
    local alive = not IsEntityDead(ped)
    if lastAlive and not alive and world.autoRespawn == false then
      -- Block default quick respawn by waiting for a revive/EMS script to handle it
      local t = GetGameTimer()
      while IsEntityDead(ped) and (GetGameTimer() - t) < 30000 do
        Wait(0)
      end
    end
    lastAlive = alive
    Wait(250)
  end
end)