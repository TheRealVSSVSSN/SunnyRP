-- resources/sunnyrp/chat/client/main.lua
SRP = SRP or {}

-- Open input on T
RegisterCommand('srp_chat', function()
  SendNUIMessage({ action = 'open' })
  SetNuiFocus(true, true)
end, false)
RegisterKeyMapping('srp_chat', 'Open chat', 'keyboard', 'T')

-- Receive messages and add to feed
RegisterNetEvent('srp:chat:message', function(msg)
  -- Always treat text as plain text; UI escapes it
  SendNUIMessage({ action = 'message', payload = msg })
end)

-- NUI -> server submit
RegisterNUICallback('submit', function(data, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })
  TriggerServerEvent('srp:chat:submit', { text = data and data.text or '' })
  cb({ ok = true })
end)

-- NUI -> close only
RegisterNUICallback('close', function(_, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })
  cb({ ok = true })
end)