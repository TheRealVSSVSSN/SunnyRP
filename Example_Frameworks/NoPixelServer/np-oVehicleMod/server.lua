local plateChanges = {}

--[[
    -- Type: Function
    -- Name: findPlate
    -- Use: Retrieves temporary plate mapping for fake plates
    -- Created: 2023-10-11
    -- By: VSSVSSN
--]]
local function findPlate(plate)
    for k, v in pairs(plateChanges) do
        if plate == v then
            return k
        end
    end
end

--[[
    -- Type: Function
    -- Name: resolvePlate
    -- Use: Returns the real plate if a fake one is provided
    -- Created: 2023-10-11
    -- By: VSSVSSN
--]]
local function resolvePlate(plate)
    return plateChanges[plate] or plate
end

RegisterNetEvent("vehicleMod:changePlate")
AddEventHandler("vehicleMod:changePlate", function(newPlate, isFake, oldPlate)
    if isFake then
        plateChanges[newPlate] = oldPlate
    else
        local tempPlate = findPlate(newPlate)
        if tempPlate then
            plateChanges[tempPlate] = nil
        end
    end
end)

RegisterNetEvent("vehicleMod:getHarness")
AddEventHandler("vehicleMod:getHarness", function(plate)
    local src = source
    plate = resolvePlate(plate)

    exports.ghmattimysql:execute(
        "SELECT harness FROM characters_cars WHERE license_plate = @plate",
        { ['plate'] = plate },
        function(result)
            if result and result[1] then
                TriggerClientEvent("vehicleMod:setHarness", src, result[1].harness, false)
            else
                TriggerClientEvent("vehicleMod:setHarness", src, false, false)
            end
        end
    )
end)

RegisterNetEvent("vehicleMod:applyHarness")
AddEventHandler("vehicleMod:applyHarness", function(plate, durability)
    local src = source
    plate = resolvePlate(plate)

    exports.ghmattimysql:execute(
        "UPDATE characters_cars SET harness = @durability WHERE license_plate = @plate",
        { ['plate'] = plate, ['durability'] = durability },
        function(result)
            if result and result.changedRows ~= 0 then
                TriggerClientEvent("vehicleMod:setHarness", src, durability, true)
            else
                TriggerClientEvent("vehicleMod:setHarness", src, false, true)
            end
        end
    )
end)

RegisterNetEvent("vehicleMod:updateHarness")
AddEventHandler("vehicleMod:updateHarness", function(plate, durability)
    plate = resolvePlate(plate)
    exports.ghmattimysql:execute(
        "UPDATE characters_cars SET harness = @durability WHERE license_plate = @plate",
        { ['plate'] = plate, ['durability'] = durability }
    )
end)

RegisterNetEvent("carhud:ejection:server")
AddEventHandler("carhud:ejection:server", function(player, value)
    TriggerClientEvent("carhud:ejection:server", player, value)
end)

RegisterNetEvent("NetworkNos")
AddEventHandler("NetworkNos", function(player)
    TriggerClientEvent("NetworkNos", player)
end)

