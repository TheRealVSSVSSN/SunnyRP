--[[
    -- Type: Module
    -- Name: Taximeter Client
    -- Use: Controls the taximeter UI and fare logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local meter = {
    gui = false,
    total = 0,
    perMinute = 0,
    baseFare = 0,
    frozen = false,
    passenger = false,
    lastUpdate = 0
}

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Displays the taximeter UI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function openGui()
    if meter.gui then return end
    meter.gui = true
    SendNUIMessage({ openSection = "openTaxiMeter" })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Hides the taximeter UI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeGui()
    if not meter.gui then return end
    meter.gui = false
    SendNUIMessage({ openSection = "closeTaxiMeter" })
end

--[[
    -- Type: Function
    -- Name: isTaxiDriver
    -- Use: Checks if the player is driving a taxi
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isTaxiDriver()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 and GetEntityModel(vehicle) == GetHashKey("taxi") then
        return GetPedInVehicleSeat(vehicle, -1) == ped, vehicle
    end
    return false, 0
end

--[[
    -- Type: Function
    -- Name: updateUi
    -- Use: Sends updated meter values to the NUI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function updateUi()
    SendNUIMessage({ openSection = "updateTotal", sentnumber = string.format("$%d.00", meter.total) })
    SendNUIMessage({ openSection = "updatePerMinute", sentnumber = string.format("$%d.00", meter.perMinute) })
    SendNUIMessage({ openSection = "updateBaseFare", sentnumber = string.format("$%d.00", meter.baseFare) })
end

--[[
    -- Type: Function
    -- Name: updateDriverMeter
    -- Use: Synchronizes meter values with the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function updateDriverMeter()
    local isDriver, vehicle = isTaxiDriver()
    if not isDriver then return end
    local plate = GetVehicleNumberPlateText(vehicle)
    updateUi()
    TriggerServerEvent("taxi:updatemeters", plate, meter.total, meter.perMinute, meter.baseFare)
    meter.lastUpdate = 0
end

--[[
    -- Type: Function
    -- Name: setRate
    -- Use: Applies a rate change and restarts the meter
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function setRate(key, value)
    local isDriver = isTaxiDriver()
    if not isDriver then return end
    value = math.ceil(tonumber(value) or 0)
    value = math.max(0, math.min(value, 100))
    meter[key] = value
    meter.total = meter.baseFare
    TriggerEvent("taximeter:restartmeter")
end

-- Main loop controlling fare updates
CreateThread(function()
    while true do
        if meter.gui then
            Wait(6000)
            meter.lastUpdate = meter.lastUpdate + 1
            if not meter.frozen then
                meter.total = meter.total + math.ceil(meter.perMinute / 10)
            end
            updateUi()
            if not meter.passenger and meter.lastUpdate >= 5 then
                updateDriverMeter()
            end
        else
            Wait(1000)
        end
    end
end)

-- Event handlers
RegisterNetEvent("taximeter:PerMinute", function(value)
    setRate("perMinute", value)
end)

RegisterNetEvent("taximeter:BaseFare", function(value)
    setRate("baseFare", value)
end)

RegisterNetEvent("taximeter:freeze", function()
    local isDriver, vehicle = isTaxiDriver()
    if isDriver then
        meter.frozen = not meter.frozen
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("taximeter:freeze", plate, meter.frozen)
        if meter.frozen then
            TriggerEvent("DoLongHudText", "Fare has been frozen.", 2)
        else
            TriggerEvent("DoLongHudText", "Fare has resumed.", 1)
        end
    end
end)

RegisterNetEvent("taximeter:RequestedFare", function(plate)
    local isDriver, vehicle = isTaxiDriver()
    if isDriver and GetVehicleNumberPlateText(vehicle) == plate then
        updateDriverMeter()
    end
end)

RegisterNetEvent("taximeter:updateFare", function(plate, total, perMinute, baseFare)
    local isDriver, vehicle = isTaxiDriver()
    if not isDriver and vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) == plate then
        meter.passenger = true
        meter.total = total
        meter.perMinute = perMinute
        meter.baseFare = baseFare
        openGui()
        updateUi()
    end
end)

RegisterNetEvent("taximeter:ExitedTaxi", function()
    if meter.gui then
        closeGui()
    end
    meter.passenger = false
end)

RegisterNetEvent("taximeter:EnteredTaxi", function()
    local isDriver, vehicle = isTaxiDriver()
    if vehicle == 0 then return end
    local plate = GetVehicleNumberPlateText(vehicle)
    if isDriver then
        openGui()
        TriggerServerEvent("taxi:updatemeters", plate, meter.total, meter.perMinute, meter.baseFare)
    else
        TriggerServerEvent("taxi:RequestFare", plate)
    end
end)

RegisterNetEvent("taximeter:restartmeter", function()
    local isDriver = isTaxiDriver()
    if isDriver then
        meter.total = meter.baseFare
        updateDriverMeter()
    end
end)

RegisterNetEvent("taximeter:FreezePlate", function(platesent, result)
    local isDriver, vehicle = isTaxiDriver()
    if not isDriver and vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) == platesent then
        meter.frozen = result
    end
end)

RegisterNetEvent("taximeter:close", function()
    closeGui()
end)

RegisterNetEvent("taximeter:start", function()
    openGui()
end)

