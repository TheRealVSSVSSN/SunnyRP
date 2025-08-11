-- resources/sunnyrp/admin/client/main.lua

local noclip = false
local spectating = false
local spectateTarget = -1

-- ===== NUI =====
RegisterNetEvent('srp:admin:open', function()
  SetNuiFocus(true, true)
  SendNUIMessage({ type='admin:open' })
end)

RegisterNUICallback('admin:close', function(_, cb)
  SetNuiFocus(false, false)
  cb({ ok = true })
end)

RegisterNUICallback('admin:requestPlayers', function(_, cb)
  -- players list via backend
  TriggerServerEvent('srp:admin:requestPlayers')
  cb({ ok = true })
end)

RegisterNetEvent('srp:admin:players', function(rows)
  SendNUIMessage({ type='admin:players', data=rows or {} })
end)

RegisterNUICallback('admin:action', function(data, cb)
  TriggerServerEvent('srp:admin:action', data.action, data.params or {})
  cb({ ok = true })
end)

-- ===== Actions client-side =====

-- goto: actor -> target
RegisterNetEvent('srp:admin:client:goto', function(targetServerId)
  local pid = GetPlayerFromServerId(targetServerId)
  if pid == -1 then return end
  local tgtPed = GetPlayerPed(pid)
  local x,y,z = table.unpack(GetEntityCoords(tgtPed))
  SetEntityCoords(PlayerPedId(), x, y+1.0, z, false, false, false, false)
end)

-- bring: target -> actor
RegisterNetEvent('srp:admin:client:bring', function(actorSrc)
  local pid = GetPlayerFromServerId(actorSrc)
  if pid == -1 then return end
  local actorPed = GetPlayerPed(pid)
  local x,y,z = table.unpack(GetEntityCoords(actorPed))
  SetEntityCoords(PlayerPedId(), x, y+1.2, z, false, false, false, false)
end)

-- spectate toggle (shadow spectate)
RegisterNetEvent('srp:admin:client:spectate', function(targetServerId)
  if spectating then
    NetworkSetInSpectatorMode(false, 0)
    spectating = false
    spectateTarget = -1
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityCollision(PlayerPedId(), true, true)
    return
  end
  local pid = GetPlayerFromServerId(targetServerId)
  if pid == -1 then return end
  local tgtPed = GetPlayerPed(pid)
  spectating = true
  spectateTarget = targetServerId
  -- shadow: hide self, no collision
  SetEntityVisible(PlayerPedId(), false, false)
  SetEntityCollision(PlayerPedId(), false, false)
  NetworkSetInSpectatorMode(true, tgtPed)
end)

-- noclip toggle
local function setNoclip(enabled)
  noclip = enabled
  local ped = PlayerPedId()
  SetEntityInvincible(ped, enabled)
  SetEntityCollision(ped, not enabled, not enabled)
  FreezeEntityPosition(ped, false)
end

RegisterNetEvent('srp:admin:client:noclip', function()
  setNoclip(not noclip)
end)

CreateThread(function()
  local speed = 1.8
  while true do
    Wait(0)
    if noclip then
      local ped = PlayerPedId()
      local x,y,z = table.unpack(GetEntityCoords(ped))
      local dx,dy,dz = 0.0,0.0,0.0
      if IsControlPressed(0, 32) then dz = dz + speed end -- W
      if IsControlPressed(0, 33) then dz = dz - speed end -- S
      if IsControlPressed(0, 34) then dx = dx - speed end -- A
      if IsControlPressed(0, 35) then dx = dx + speed end -- D
      if IsControlPressed(0, 21) then speed = 3.0 else speed = 1.8 end -- Shift
      local heading = GetGameplayCamRot(0).z
      local rad = math.rad(heading)
      local nx = x + (dx * math.cos(rad) - dz * math.sin(rad))
      local ny = y + (dx * math.sin(rad) + dz * math.cos(rad))
      local nz = z + (IsControlPressed(0, 85) and 1.0 or 0) - (IsControlPressed(0, 48) and 1.0 or 0) -- Q/E
      SetEntityCoordsNoOffset(ped, nx, ny, nz, true, true, true)
    end
  end
end)

-- cleanup
RegisterNetEvent('srp:admin:client:cleanup', function(actorSrc, radius)
  local me = GetPlayerFromServerId(actorSrc)
  local mePed = GetPlayerPed(me)
  local x,y,z = table.unpack(GetEntityCoords(mePed))
  -- vehicles
  for veh in EnumerateVehicles() do
    if #(GetEntityCoords(veh) - vector3(x,y,z)) < radius then
      if not IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
      end
    end
  end
  -- peds
  for ped in EnumeratePeds() do
    if ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
      if #(GetEntityCoords(ped) - vector3(x,y,z)) < radius then
        DeleteEntity(ped)
      end
    end
  end
end)

-- small enumerators (client)
function EnumerateVehicles() return coroutine.wrap(function()
  local handle, veh = FindFirstVehicle()
  local ok; repeat coroutine.yield(veh); ok, veh = FindNextVehicle(handle) until not ok
  EndFindVehicle(handle)
end) end
function EnumeratePeds() return coroutine.wrap(function()
  local handle, ped = FindFirstPed()
  local ok; repeat coroutine.yield(ped); ok, ped = FindNextPed(handle) until not ok
  EndFindPed(handle)
end) end