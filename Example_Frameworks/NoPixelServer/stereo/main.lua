--[[
    -- Type: Event
    -- Name: stereoGui
    -- Use: Toggles the in-vehicle radio interface
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]

local guiOpen = false

RegisterNetEvent('stereoGui', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) or not hasRadio() then return end

    if exports['isPed']:isPed('incall') then
        TriggerEvent('DoShortHudText', 'You can not do that while in a call!', 2)
        return
    end

    guiOpen = not guiOpen
    SetNuiFocus(guiOpen, guiOpen)
    SendNUIMessage({ open = guiOpen })
end)

--[[
    -- Type: Function
    -- Name: hasRadio
    -- Use: Checks player inventory for a radio
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
local function hasRadio()
    return exports['np-inventory']:hasEnoughOfItem('radio', 1, false)
end

RegisterNUICallback('click', function(_, cb)
    PlaySound(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
    cb({})
end)

RegisterNUICallback('volumeUp', function(_, cb)
    TriggerEvent('TokoVoip:UpVolumeBroadcast')
    cb({})
end)

RegisterNUICallback('volumeDown', function(_, cb)
    TriggerEvent('TokoVoip:DownVolumeBroadcast')
    cb({})
end)

RegisterNUICallback('cleanClose', function(_, cb)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radioclick', 0.6)
    guiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ open = false })
    TriggerEvent('animation:radio', guiOpen)
    cb({})
end)

RegisterNUICallback('poweredOn', function(data, cb)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radioclick', 0.6)
    local channel = tonumber(data.channel) or 0
    if channel == 1982.9 then channel = 19829 end
    TriggerEvent('TokoVoip:broadcastListening', channel)
    cb({})
end)

RegisterNUICallback('poweredOff', function(_, cb)
    TriggerEvent('TokoVoip:broadcastListening', 0)
    cb({})
end)

RegisterNUICallback('channelChange', function(data, cb)
    local channel = tonumber(data.channel) or 0
    if channel == 1982.9 then channel = 19829 end
    TriggerEvent('TokoVoip:broadcastListening', channel)
    cb({})
end)

RegisterNUICallback('close', function(data, cb)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radioclick', 0.6)
    local channel = tonumber(data.channel) or 0
    if channel == 1982.9 then channel = 19829 end
    TriggerEvent('TokoVoip:broadcastListening', channel)
    guiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ open = false })
    TriggerEvent('animation:radio', guiOpen)
    cb({})
end)

CreateThread(function()
    while true do
        if guiOpen then
            Wait(0)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 16, true)
            DisableControlAction(0, 17, true)
            DisableControlAction(0, 99, true)
            DisableControlAction(0, 100, true)
            DisableControlAction(0, 115, true)
            DisableControlAction(0, 116, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 106, true)

            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                guiOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ open = false })
            end
        else
            Wait(20)
        end
    end
end)

