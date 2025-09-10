--[[
    -- Type: Script
    -- Name: server.lua
    -- Use: Handles validation for security truck heists
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local robbedLicenses = {}

--[[
    -- Type: Event
    -- Name: sec:checkRobbed
    -- Use: Prevents a truck from being robbed more than once
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('sec:checkRobbed')
AddEventHandler('sec:checkRobbed', function(license)
    local src = source
    if robbedLicenses[license] then
        return
    end
    robbedLicenses[license] = true
    TriggerClientEvent('sec:AllowHeist', src)
end)
