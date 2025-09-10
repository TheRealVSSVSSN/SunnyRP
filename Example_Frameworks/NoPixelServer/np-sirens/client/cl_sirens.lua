--[[
    -- Type: Thread
    -- Name: DisableDistantSirens
    -- Use: Continuously disables distant police sirens to reduce ambient noise
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local UPDATE_INTERVAL = 500 -- milliseconds between checks

CreateThread(function()
    while true do
        DistantCopCarSirens(false)
        Wait(UPDATE_INTERVAL)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DistantCopCarSirens(true)
    end
end)
