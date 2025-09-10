-- done ((sway))

--[[
    -- Type: Event
    -- Name: taximeter:freeze
    -- Use: Broadcasts frozen state of a meter to all players
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterServerEvent('taximeter:freeze')
AddEventHandler('taximeter:freeze', function(plate, isFrozen)
    TriggerClientEvent('taximeter:FreezePlate', -1, plate, isFrozen)
end)

--[[
    -- Type: Event
    -- Name: taxi:updatemeters
    -- Use: Synchronizes meter values across clients
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterServerEvent('taxi:updatemeters')
AddEventHandler('taxi:updatemeters', function(plate, total, perminute, basefare)
    TriggerClientEvent('taximeter:updateFare', -1, plate, total, perminute, basefare)
end)

--[[
    -- Type: Event
    -- Name: taxi:RequestFare
    -- Use: Requests the driver to transmit current fare to passengers
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterServerEvent('taxi:RequestFare')
AddEventHandler('taxi:RequestFare', function(plate)
    TriggerClientEvent('taximeter:RequestedFare', -1, plate)
end)
