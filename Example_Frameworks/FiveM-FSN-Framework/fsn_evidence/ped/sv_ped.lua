local pedStates = {}

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:ped:update
    -- Use: Receives ped state updates from client and broadcasts to others
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:ped:update', function(tbl)
    pedStates[source] = tbl or {}
    TriggerClientEvent('fsn_evidence:ped:update', -1, source, pedStates[source])
end)

