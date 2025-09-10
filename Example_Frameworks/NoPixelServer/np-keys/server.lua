--[[
    -- Type: Server
    -- Name: np-keys server
    -- Use: Handles key transfer between players
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

--[[
    -- Type: Event
    -- Name: keys:send
    -- Use: Sends a key to another player by triggering a client event
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:send')
AddEventHandler('keys:send', function(targetId, plate)
    local src = source
    if type(targetId) ~= 'number' or type(plate) ~= 'string' then return end
    TriggerClientEvent('keys:received', targetId, plate)
end)
