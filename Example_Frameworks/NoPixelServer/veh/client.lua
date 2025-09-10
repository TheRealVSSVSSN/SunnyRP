local trackedVehicles = {}
local changingVar = ""

DecorRegister("PlayerVehicle", 2)

--[[
    -- Type: Function
    -- Name: setPlayerOwnedVehicle
    -- Use: Flags the current vehicle as owned by the player
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function setPlayerOwnedVehicle()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        DecorSetBool(veh, "PlayerVehicle", true)
    end
end

RegisterNetEvent('veh.PlayerOwned', function()
    setPlayerOwnedVehicle()
end)

--[[
    -- Type: Function
    -- Name: checkPlayerOwnedVehicle
    -- Use: Determines if a vehicle has been flagged as player owned
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function checkPlayerOwnedVehicle(veh)
    return DecorExistOn(veh, "PlayerVehicle") and DecorGetBool(veh, "PlayerVehicle")
end

exports('checkPlayerOwnedVehicle', checkPlayerOwnedVehicle)
exports('setPlayerOwnedVehicle', setPlayerOwnedVehicle)

--[[
    -- Type: Function
    -- Name: fuelInjector
    -- Use: Temporarily disables the engine to simulate injector issues
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function fuelInjector(vehicle, waitTime)
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, true)
    Wait(waitTime)
    SetVehicleEngineOn(vehicle, true, false, true)
    SetVehicleUndriveable(vehicle, false)
end

--[[
    -- Type: Event
    -- Name: veh.updateVehicleDegredation
    -- Use: Sends updated degradation values for all tracked vehicles to the server
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.updateVehicleDegredation', function(br, ax, rad, cl, tra, elec, fi, ft)
    for veh, data in pairs(trackedVehicles) do
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            TriggerServerEvent('veh.updateVehicleDegredationServer', data.plate, br, ax, rad, cl, tra, elec, fi, ft)
        else
            trackedVehicles[veh] = nil
        end
    end
end)

--[[
    -- Type: Event
    -- Name: veh.randomDegredation
    -- Use: Applies random degradation to various vehicle parts
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.randomDegredation', function(upperLimit, vehicle, spinAmount)
    local degHealth = getDegredationArray()
    local plate = GetVehicleNumberPlateText(vehicle)

    if not checkPlayerOwnedVehicle(vehicle) then return end

    local parts = {'breaks','axle','radiator','clutch','transmission','electronics','fuel_injector','fuel_tank'}
    for _ = 1, spinAmount do
        local part = parts[math.random(1, #parts)]
        degHealth[part] = math.max(0, degHealth[part] - math.random(0, upperLimit))
    end

    TriggerServerEvent('veh.updateVehicleDegredationServer', plate, degHealth.breaks, degHealth.axle, degHealth.radiator,
        degHealth.clutch, degHealth.transmission, degHealth.electronics, degHealth.fuel_injector, degHealth.fuel_tank)
    TriggerServerEvent('veh.callDegredation', plate)
end)

RegisterNetEvent('veh.updateVehicleBounce', function(br, ax, rad, cl, tra, elec, fi, ft, plate)
    if br == 0 then br = nil end
    TriggerServerEvent('veh.updateVehicleDegredationServer', plate, br, ax, rad, cl, tra, elec, fi, ft)
end)

RegisterNetEvent('veh.getSQL', function(degradation)
    changingVar = degradation
end)

--[[
    -- Type: Function
    -- Name: split
    -- Use: Splits a string by a delimiter
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch('(.-)' .. delimiter) do
        table.insert(result, match)
    end
    return result
end

--[[
    -- Type: Function
    -- Name: getDegredationArray
    -- Use: Converts the server provided degradation string into a table
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
function getDegredationArray()
    local temp = split(changingVar, ',')
    return {
        breaks = tonumber(temp[1]) or 0,
        axle = tonumber(temp[2]) or 0,
        radiator = tonumber(temp[3]) or 0,
        clutch = tonumber(temp[4]) or 0,
        transmission = tonumber(temp[5]) or 0,
        electronics = tonumber(temp[6]) or 0,
        fuel_injector = tonumber(temp[7]) or 0,
        fuel_tank = tonumber(temp[8]) or 0
    }
end

--[[
    -- Type: Event
    -- Name: veh.getVehicleDegredation
    -- Use: Applies degradation effects to the current vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.getVehicleDegredation', function(currentVehicle, tick)
    local degHealth = getDegredationArray()
    if not IsPedInVehicle(PlayerPedId(), currentVehicle, false) then return end
    if not checkPlayerOwnedVehicle(currentVehicle) then return end

    local class = GetVehicleClass(currentVehicle)
    if class ~= 13 and class ~= 21 and class ~= 16 and class ~= 15 and class ~= 14 then
        if degHealth.fuel_injector <= 45 and tick >= 15 then
            if degHealth.fuel_injector <= 45 and degHealth.fuel_injector >= 25 then
                if math.random(100) > 99 then fuelInjector(currentVehicle, 50) end
            elseif degHealth.fuel_injector <= 24 and degHealth.fuel_injector >= 15 then
                if math.random(100) > 98 then fuelInjector(currentVehicle, 400) end
            elseif degHealth.fuel_injector <= 14 and degHealth.fuel_injector >= 9 then
                if math.random(100) > 97 then fuelInjector(currentVehicle, 600) end
            elseif degHealth.fuel_injector <= 8 then
                if math.random(100) > 90 then fuelInjector(currentVehicle, 1000) end
            end
        end

        if degHealth.radiator <= 35 and tick >= 15 then
            local engineHealth = GetVehicleEngineHealth(currentVehicle)
            local loss = 0
            if degHealth.radiator <= 35 and degHealth.radiator >= 20 then
                loss = 10
            elseif degHealth.radiator <= 19 and degHealth.radiator >= 10 then
                loss = 20
            elseif degHealth.radiator <= 9 then
                loss = 30
            end
            if loss > 0 and engineHealth >= 200 then
                SetVehicleEngineHealth(currentVehicle, engineHealth - loss)
            end
        end

        if degHealth.axle <= 35 and tick >= 15 then
            if degHealth.axle <= 35 and degHealth.axle >= 20 and math.random(100) > 90 then
                for i = 0, 360 do
                    SetVehicleSteeringScale(currentVehicle, i)
                end
            elseif degHealth.axle <= 19 and degHealth.axle >= 10 and math.random(100) > 80 then
                for i = 0, 360 do
                    SetVehicleSteeringScale(currentVehicle, i)
                end
            elseif degHealth.axle <= 9 and math.random(100) > 70 then
                for i = 0, 360 do
                    SetVehicleSteeringScale(currentVehicle, i)
                end
            end
        end
    end
end)

--[[
    -- Type: Function
    -- Name: trackVehicleHealth
    -- Use: Sends current health and fuel of tracked vehicles to the server
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
function trackVehicleHealth()
    local temp = {}
    for veh, data in pairs(trackedVehicles) do
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local engine = math.ceil(GetVehicleEngineHealth(veh))
            local body = math.ceil(GetVehicleBodyHealth(veh))
            local fuel = DecorGetInt(veh, 'CurrentFuel') or 0
            temp[#temp + 1] = {data.plate, engine, body, fuel}
        else
            trackedVehicles[veh] = nil
        end
    end
    if #temp > 0 then
        TriggerServerEvent('veh.updateVehicleHealth', temp)
    end
end

exports('trackVehicleHealth', trackVehicleHealth)

--[[
    -- Type: Event
    -- Name: veh.setVehicleHealth
    -- Use: Applies saved health values to a vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.setVehicleHealth', function(eh, bh, fuel, veh)
    CreateThread(function()
        local count = 0
        while count < 25 do
            Wait(0)
            SetVehicleEngineHealth(veh, eh + 0.0)
            SetVehicleBodyHealth(veh, bh + 0.0)
            DecorSetInt(veh, 'CurrentFuel', fuel)
            count = count + 1
        end
    end)
end)

--[[
    -- Type: Thread
    -- Name: VehicleMonitor
    -- Use: Tracks the player vehicle and updates degradation/health
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
CreateThread(function()
    Wait(1000)
    local tick, rTick = 0, 0
    local lastVehicle = 0
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            tick = tick + 1
            rTick = rTick + 1
            if checkPlayerOwnedVehicle(veh) then
                local plate = GetVehicleNumberPlateText(veh)
                trackedVehicles[veh] = trackedVehicles[veh] or {plate = plate}
            end
            if tick >= 15 then
                TriggerEvent('veh.getVehicleDegredation', veh, tick)
                TriggerEvent('veh.updateVehicleDegredation', 0,0,0,0,0,0,0,0)
                trackVehicleHealth()
                tick = 0
            end
            if rTick >= 60 then
                TriggerEvent('veh.randomDegredation', 1, veh, 3)
                rTick = 0
            end
            lastVehicle = veh
        else
            if lastVehicle ~= 0 then
                TriggerEvent('veh.getVehicleDegredation', lastVehicle, 15)
                TriggerEvent('veh.updateVehicleDegredation', 0,0,0,0,0,0,0,0)
                tick = 0
                rTick = 0
                lastVehicle = 0
            end
        end
    end
end)

--[[
    -- Type: Event
    -- Name: veh.isPlayers
    -- Use: Callback to check if a vehicle belongs to the player
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.isPlayers', function(veh, cb)
    cb(checkPlayerOwnedVehicle(veh))
end)

--[[
    -- Type: Event
    -- Name: veh.getDegredation
    -- Use: Retrieves the current degradation table for a vehicle
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh.getDegredation', function(veh, cb)
    local plate = GetVehicleNumberPlateText(veh)
    if checkPlayerOwnedVehicle(veh) then
        TriggerServerEvent('veh.callDegredation', plate)
    end
    Wait(100)
    cb(getDegredationArray())
end)
