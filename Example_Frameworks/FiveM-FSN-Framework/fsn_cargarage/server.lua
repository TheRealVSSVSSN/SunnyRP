--[[
    -- Type: Resource Server
    -- Name: fsn_cargarage/server.lua
    -- Use: Handles server-side garage logic and database interaction
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]

local db = exports['ghmattimysql']

local vehicleTypes = {cars='c', aircrafts='a', boats='b'}

--[[
    -- Type: Event
    -- Name: fsn_cargarage:updateVehicle
    -- Use: Persists vehicle modifications to the database
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_cargarage:updateVehicle', function(tbl)
    local details = json.encode(tbl)
    print(('updating Vehicle(%s) to Details(%s)'):format(tbl.plate, details))
    db:execute('UPDATE fsn_vehicles SET veh_details = @details WHERE veh_plate = @plate', {
        ['@plate'] = tbl.plate,
        ['@details'] = details
    })
end)

--[[
    -- Type: Event
    -- Name: fsn_cargarage:reset
    -- Use: Resets vehicle status for a character on login
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_cargarage:reset', function(charid)
    db:execute('UPDATE fsn_vehicles SET veh_status = 0 WHERE veh_status = 1 AND char_id = @charid', {
        ['@charid'] = charid
    })
end)

--[[
    -- Type: Event
    -- Name: fsn_cargarage:requestVehicles
    -- Use: Sends vehicles for a garage type to the client
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_cargarage:requestVehicles', function(vehType, charid, garage)
    local src = source
    local dbType = vehicleTypes[vehType]
    if not dbType then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'Something is wrong with this garage!', 'centerLeft', 3000, 'error')
        return
    end
    db:execute('SELECT * FROM fsn_vehicles WHERE char_id = @char AND veh_type = @type', {
        ['@char'] = charid,
        ['@type'] = dbType
    }, function(vehicles)
        local list = {}
        for _, v in ipairs(vehicles) do
            if v.veh_garage == garage or v.veh_garage == '0' then
                list[#list+1] = v
            end
        end
        TriggerClientEvent('fsn_cargarage:receiveVehicles', src, vehType, list)
    end)
end)

--[[
    -- Type: Event
    -- Name: fsn_cargarage:impound
    -- Use: Sets vehicle status to impounded
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_cargarage:impound', function(plate)
    db:execute('UPDATE fsn_vehicles SET veh_status = 2 WHERE veh_plate = @plate', { ['@plate'] = plate })
end)

--[[
    -- Type: Event
    -- Name: fsn_cargarage:vehicle:toggleStatus
    -- Use: Updates vehicle status and garage
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_cargarage:vehicle:toggleStatus', function(plate, status, garage)
    local src = source
    TriggerClientEvent('fsn_cargarage:vehicleStatus', src, plate, status, garage)
    db:execute('UPDATE fsn_vehicles SET veh_status = @status, veh_garage = @garage WHERE veh_plate = @plate', {
        ['@plate'] = plate,
        ['@status'] = status,
        ['@garage'] = garage
    })
end)

--[[
    -- Type: Event
    -- Name: fsn_garages:vehicle:update
    -- Use: Convenience wrapper for updating vehicle details
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_garages:vehicle:update', function(details)
    TriggerEvent('fsn_cargarage:updateVehicle', details)
end)
