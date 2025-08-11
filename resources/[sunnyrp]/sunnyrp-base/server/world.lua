-- World toggles & broadcast: disable regen, auto-respawn, dispatch; density scaling.
-- Clients implement application in client/world.lua.

CreateThread(function()
  -- Broadcast initial world prefs to everyone
  Wait(1000)
  TriggerClientEvent('srp:world:cfg', -1, {
    disableRegen = true,
    autoRespawn = false,
    density = (SRP_Config.QoL and SRP_Config.QoL.densityScale) or 0.8,
    disableDispatch = true,
  })
end)

AddEventHandler('playerJoining', function()
  local src = source
  TriggerClientEvent('srp:world:cfg', src, {
    disableRegen = true,
    autoRespawn = false,
    density = (SRP_Config.QoL and SRP_Config.QoL.densityScale) or 0.8,
    disableDispatch = true,
  })
end)

-- Live changes via Config Bus
AddEventHandler('srp:config:changed', function(patch)
  if patch and patch.QoL and patch.QoL.densityScale then
    TriggerClientEvent('srp:world:cfg', -1, {
      density = patch.QoL.densityScale
    })
  end
end)