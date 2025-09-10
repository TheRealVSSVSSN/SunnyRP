--[[
    -- Type: Command
    -- Name: togglexhair
    -- Use: Toggles the crosshair visibility override
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local crosshairActive = false
local disableXhair = false

RegisterCommand('togglexhair', function()
    disableXhair = not disableXhair

    if disableXhair and crosshairActive then
        crosshairActive = false
        SendNUIMessage({ action = 'hide' })
    end
end)

--[[
    -- Type: Thread
    -- Name: CrosshairControl
    -- Use: Manages crosshair visibility based on player state
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(500)

        local ped = PlayerPedId()

        if not disableXhair and not IsPedInAnyVehicle(ped, false) and IsPedArmed(ped, 6) then
            if not crosshairActive then
                crosshairActive = true
                SendNUIMessage({ action = 'show' })
            end
        elseif crosshairActive then
            crosshairActive = false
            SendNUIMessage({ action = 'hide' })
        end
    end
end)

