-- resources/sunnyrp/leoems/client/main.lua

-- Receive new dispatch calls (show toast + optional map ping)
RegisterNetEvent('srp:dispatch:new', function(call)
  local loc = call.location or {}
  BeginTextCommandThefeedPost("STRING"); AddTextComponentSubstringPlayerName(("~y~%s~s~: %s"):format(call.kind, call.summary)); EndTextCommandThefeedPostTicker(false, false)
  if loc.x and loc.y and loc.z then
    local blip = AddBlipForCoord(loc.x+0.0,loc.y+0.0,loc.z+0.0)
    SetBlipSprite(blip, 161); SetBlipScale(blip, 1.0); SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString("Dispatch Call"); EndTextCommandSetBlipName(blip)
    Citizen.CreateThread(function()
      Wait(tonumber(GetConvar('srp_dispatch_blip_time_ms','120000')))
      RemoveBlip(blip)
    end)
  end
end)

-- Police: cuff & escort basics
RegisterNetEvent('srp:police:cuff', function(officerSrc)
  local ped = PlayerPedId()
  RequestAnimDict("mp_arresting"); while not HasAnimDictLoaded("mp_arresting") do Wait(0) end
  TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)
  SetEnableHandcuffs(ped, true)
  DisablePlayerFiring(PlayerId(), true)
end)

RegisterNetEvent('srp:police:escort', function(officerSrc)
  local officer = GetPlayerFromServerId(officerSrc)
  local ped = PlayerPedId()
  local offPed = GetPlayerPed(officer)
  AttachEntityToEntity(ped, offPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
end)

-- EMS: revive basic
RegisterNetEvent('srp:ems:revive', function()
  local ped = PlayerPedId()
  ResurrectPed(ped)
  ClearPedBloodDamage(ped)
  SetEntityHealth(ped, 200)
  ClearPedTasksImmediately(ped)
end)

-- ===== MDT NUI (minimal scaffolding) =====
RegisterCommand('mdt', function()
  -- job-gated
  SendNUIMessage({ type='mdt:open' }); SetNuiFocus(true, true)
end)

RegisterNUICallback('mdt:close', function(_, cb) SetNuiFocus(false, false); cb({ ok=true }) end)
RegisterNUICallback('mdt:list', function(data, cb) TriggerServerEvent('srp:mdt:list', data or {}); cb({ ok=true }) end)
RegisterNUICallback('mdt:create', function(data, cb) TriggerServerEvent('srp:mdt:create', data or {}); cb({ ok=true }) end)

RegisterNetEvent('srp:mdt:list:resp', function(rows) SendNUIMessage({ type='mdt:list', data=rows or {} }) end)
RegisterNetEvent('srp:mdt:create:resp', function(row) SendNUIMessage({ type='mdt:created', data=row }) end)