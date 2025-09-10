--[[
    -- Type: Server
    -- Name: np-tuner
    -- Use: Syncs vehicle tuning data between players and server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

RegisterNetEvent('tuner:modify', function(vehicleTable, vehicleDefaultTable)
    TriggerClientEvent('tuner:setNew', source, vehicleDefaultTable, vehicleTable)
end)
