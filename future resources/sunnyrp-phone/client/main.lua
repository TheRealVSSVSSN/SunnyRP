-- resources/sunnyrp/phone/client/main.lua

local phoneOpen = false

-- Keybind (replace/route to your menu later)
CreateThread(function()
  while true do
    Wait(0)
    if IsControlJustPressed(0, 244) then -- M key by default
      if phoneOpen then
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'close' })
        phoneOpen = false
      else
        phoneOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'loading' })
        TriggerServerEvent('srp:phone:open')
      end
    end
  end
end)

-- Server → NUI bootstrap
RegisterNetEvent('srp:phone:open:data', function(payload)
  SendNUIMessage({ action='open', data=payload })
end)

-- Echo/push/bulk SMS updates
RegisterNetEvent('srp:phone:sms:echo', function(msg) SendNUIMessage({ action='sms_echo', data=msg }) end)
RegisterNetEvent('srp:phone:sms:push', function(msg) SendNUIMessage({ action='sms_push', data=msg }) end)
RegisterNetEvent('srp:phone:sms:bulk', function(list) SendNUIMessage({ action='sms_bulk', data=list }) end)

-- Contacts updates
RegisterNetEvent('srp:phone:contacts:update', function(list) SendNUIMessage({ action='contacts_update', data=list }) end)

-- NUI callbacks
RegisterNUICallback('sms_send', function(data, cb)
  TriggerServerEvent('srp:phone:sms:send', data)
  cb({ ok = true })
end)
RegisterNUICallback('contacts_save', function(data, cb)
  TriggerServerEvent('srp:phone:contacts:save', data)
  cb({ ok = true })
end)
RegisterNUICallback('contacts_delete', function(data, cb)
  TriggerServerEvent('srp:phone:contacts:delete', data)
  cb({ ok = true })
end)
RegisterNUICallback('ads_post', function(data, cb)
  TriggerServerEvent('srp:phone:ads:post', data)
  cb({ ok = true })
end)
RegisterNUICallback('close', function(_, cb)
  SetNuiFocus(false, false); phoneOpen = false; cb({ ok = true })
end)