local MySQL = exports['ghmattimysql']

--[[
    -- Type: Event
    -- Name: veh.examine
    -- Use: Sends vehicle degradation and damage info to the requester
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.examine', function(plate)
    local src = source
    MySQL:execute('SELECT degredation, engine_damage, body_damage FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            TriggerClientEvent('towgarage:triggermenu', src, result[1].degredation, result[1].engine_damage, result[1].body_damage)
        else
            TriggerClientEvent('DoLongHudText', src, 'This vehicle is not listed', 2)
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: veh.callDegredation
    -- Use: Retrieves degradation data for a vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.callDegredation', function(plate, status)
    local src = source
    MySQL:execute('SELECT degredation FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            if status then
                TriggerClientEvent('towgarage:triggermenu', src, result[1].degredation)
            else
                TriggerClientEvent('veh.getSQL', src, result[1].degredation)
            end
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: veh.updateVehicleHealth
    -- Use: Updates engine, body and fuel values for a vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.updateVehicleHealth', function(data)
    local info = data[1]
    MySQL:execute('UPDATE characters_cars SET engine_damage = @engine, body_damage = @body, fuel = @fuel WHERE license_plate = @plate', {
        ['@engine'] = info[2],
        ['@body'] = info[3],
        ['@fuel'] = info[4],
        ['@plate'] = info[1]
    })
end)

--[[
    -- Type: Event
    -- Name: veh.updateVehicleDegredationServer
    -- Use: Persists degradation values for a vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.updateVehicleDegredationServer', function(plate, br, ax, rad, cl, tra, elec, fi, ft)
    if not plate then return end
    local deg = table.concat({br, ax, rad, cl, tra, elec, fi, ft}, ',')
    MySQL:execute('UPDATE characters_cars SET degredation = @deg WHERE license_plate = @plate', {
        ['@deg'] = deg,
        ['@plate'] = plate
    })
end)

--[[
    -- Type: Event
    -- Name: veh.getVehicles
    -- Use: Sends stored vehicle health data to the client
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.getVehicles', function(plate, veh)
    local src = source
    MySQL:execute('SELECT engine_damage, body_damage, fuel FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            TriggerClientEvent('veh.setVehicleHealth', src, result[1].engine_damage, result[1].body_damage, result[1].fuel, veh)
        end
    end)
end)
