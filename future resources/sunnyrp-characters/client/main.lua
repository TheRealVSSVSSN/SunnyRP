SRP = SRP or {}
local firstSpawned = false

-- Open char select when client is ready
AddEventHandler('playerSpawned', function()
  if firstSpawned then return end
  firstSpawned = true
  TriggerServerEvent('srp:ui:open:charselect')
end)

-- Receive char list & open NUI
RegisterNetEvent('srp:ui:charselect:data', function(payload)
  SetNuiFocus(true, true)
  SendNUIMessage({ type = 'char:list', data = payload })
end)

-- Close UI helper
RegisterNetEvent('srp:ui:charselect:close', function()
  SetNuiFocus(false, false)
  SendNUIMessage({ type = 'char:close' })
end)

-- NUI callbacks -> relay to server events
RegisterNUICallback('srp:characters:create', function(data, cb)
  TriggerServerEvent('srp:characters:create', data)
  cb({ ok = true })
end)

RegisterNUICallback('srp:characters:select', function(data, cb)
  TriggerServerEvent('srp:characters:select', data)
  cb({ ok = true })
end)

RegisterNUICallback('srp:characters:delete', function(data, cb)
  TriggerServerEvent('srp:characters:delete', data)
  cb({ ok = true })
end)