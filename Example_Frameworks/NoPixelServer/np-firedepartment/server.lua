--[[
    -- Type: Server Script
    -- Name: np-firedepartment/server.lua
    -- Use: Handles door removal and particle sync events for the fire department saw
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

RegisterNetEvent('Saw:SyncDoorFall')
AddEventHandler('Saw:SyncDoorFall', function(netId, doorIndex)
    TriggerClientEvent('firedepartment:removeDoor', -1, netId, doorIndex)
end)

RegisterNetEvent('Saw:StartParticles')
AddEventHandler('Saw:StartParticles', function(sawId)
    TriggerClientEvent('Saw:StartParticles', -1, sawId)
end)

RegisterNetEvent('Saw:SyncStopParticles')
AddEventHandler('Saw:SyncStopParticles', function(sawId)
    TriggerClientEvent('Saw:StopParticles', -1, sawId)
end)
