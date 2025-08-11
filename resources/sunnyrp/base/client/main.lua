SRP = SRP or {}
RegisterNetEvent('srp:base:hello', function(msg)
  SendNUIMessage({ type = 'hello', payload = msg or 'hello from server' })
end)

-- Simple dev key to toggle UI (F10)
local show = false
CreateThread(function()
  while true do
    Wait(0)
    if IsControlJustReleased(0, 57) then -- F10
      show = not show
      SetNuiFocus(show, show)
      SendNUIMessage({ type = 'toggle', show = show })
    end
  end
end)

RegisterNUICallback('nui:ping', function(data, cb)
  cb({ ok = true, echo = data })
end)