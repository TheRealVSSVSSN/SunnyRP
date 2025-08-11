-- Client-side actual spawn: fades, model, resurrect, coords
RegisterNetEvent('srp:spawn:do', function(pos)
  DoScreenFadeOut(500); while not IsScreenFadedOut() do Wait(0) end

  local ped = PlayerPedId()
  local model = `mp_m_freemode_01`
  RequestModel(model); while not HasModelLoaded(model) do Wait(0) end
  SetPlayerModel(PlayerId(), model)
  SetPedDefaultComponentVariation(PlayerPedId())
  SetModelAsNoLongerNeeded(model)

  -- Teleport & resurrect
  local x,y,z,h = pos.x+0.0, pos.y+0.0, pos.z+0.0, (pos.heading or 0.0)+0.0
  SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, false, false, false)
  NetworkResurrectLocalPlayer(x, y, z, h, true, true, false)
  ClearPedTasksImmediately(PlayerPedId())
  RemoveAllPedWeapons(PlayerPedId(), true)
  ClearPlayerWantedLevel(PlayerId())
  SetEntityHeading(PlayerPedId(), h)
  FreezeEntityPosition(PlayerPedId(), false)

  DoScreenFadeIn(800)
end)