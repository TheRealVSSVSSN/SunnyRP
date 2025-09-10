--[[
    -- Type: Event
    -- Name: np:peds:rogue
    -- Use: Broadcasts rogue ped deletions to all clients
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('np:peds:rogue', function(toDelete)
    if type(toDelete) ~= 'table' then return end
    TriggerClientEvent('np:peds:rogue:delete', -1, toDelete)
end)
