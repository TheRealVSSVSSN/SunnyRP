--[[
    -- Type: Server Script
    -- Name: heli_server.lua
    -- Use: Relays helicopter spotlight states to all clients
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]

RegisterNetEvent('heli:spotlight_update', function(playerId, state)
    TriggerClientEvent('heli:spotlight_update', -1, playerId, state)
end)

