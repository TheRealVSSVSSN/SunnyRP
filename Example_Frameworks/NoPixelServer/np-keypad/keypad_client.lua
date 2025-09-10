--[[ 
    -- Type: Client Script
    -- Name: keypad_client
    -- Use: Handles NUI keypad interactions for traphouse access
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]

local currentLocation

--[[ 
    -- Type: Function
    -- Name: openUI
    -- Use: Shows keypad and enables input focus
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function openUI()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end

--[[ 
    -- Type: Function
    -- Name: closeUI
    -- Use: Hides keypad and clears input focus
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function closeUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

--[[ 
    -- Type: Callback
    -- Name: close
    -- Use: Handles closing the keypad from NUI
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb({})
end)

--[[ 
    -- Type: Callback
    -- Name: complete
    -- Use: Processes submitted PIN codes
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
RegisterNUICallback('complete', function(data, cb)
    if currentLocation and data and data.pin then
        TriggerEvent('traphouse:open', currentLocation, data.pin)
    end
    closeUI()
    cb({})
end)

--[[ 
    -- Type: Event
    -- Name: trap:attempt
    -- Use: Opens keypad for the specified location
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
RegisterNetEvent('trap:attempt', function(num)
    currentLocation = num
    openUI()
end)

--[[ 
    -- Type: Event
    -- Name: onResourceStop
    -- Use: Ensures NUI focus is released when resource stops
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

