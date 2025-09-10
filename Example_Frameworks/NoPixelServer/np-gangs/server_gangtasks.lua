--[[
    -- Type: Server Script
    -- Name: server_gangtasks
    -- Use: Provides command hooks for gang activities
    -- Created: 2024-08-18
    -- By: VSSVSSN
--]]

RegisterCommand('corner', function(source)
    if source > 0 then
        TriggerClientEvent('drugs:corner', source)
    end
end, false)