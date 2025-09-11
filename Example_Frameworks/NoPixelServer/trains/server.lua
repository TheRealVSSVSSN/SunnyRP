--[[
    -- Type: Server Script
    -- Name: server.lua
    -- Use: Manages host assignment for train routes
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]

local currentHost = -1

--[[
    -- Type: Event
    -- Name: trains:requestHost
    -- Use: Grants train control to the first requester
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
RegisterNetEvent('trains:requestHost')
AddEventHandler('trains:requestHost', function()
    if currentHost == -1 then
        currentHost = source
        TriggerClientEvent('trains:hostAssigned', source, true)
    else
        TriggerClientEvent('trains:hostAssigned', source, false)
    end
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Releases host when player leaves
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    if source == currentHost then
        currentHost = -1
    end
end)
