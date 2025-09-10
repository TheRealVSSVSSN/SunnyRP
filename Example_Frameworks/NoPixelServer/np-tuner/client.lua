--[[
    -- Type: Client
    -- Name: np-tuner
    -- Use: Manages vehicle handling tuning and NUI interaction
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local guiEnabled = false
local vehicleDefaultTable = {}
local vehicleTable = {}

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Enables NUI focus and opens tuner interface
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function openGui(boost, fuel, gears, braking, drive)
    SetPlayerControl(PlayerId(), false, 0)
    guiEnabled = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        openSection = 'openNotepad',
        boost = boost,
        fuel = fuel,
        gears = gears,
        braking = braking,
        drive = drive
    })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Disables NUI focus and hides tuner interface
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeGui()
    guiEnabled = false
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    SetNuiFocus(false, false)
    SendNUIMessage({ openSection = 'close' })
    SetPlayerControl(PlayerId(), true, 0)
end

RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)

--[[
    -- Type: Function
    -- Name: doBoostFuel
    -- Use: Adjusts boost and traction handling values
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function doBoostFuel(boost, fuel, veh)
    if boost == 0 then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', vehicleDefaultTable[veh].fInitialDriveForce)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', vehicleDefaultTable[veh].fLowSpeedTractionLossMult)
    else
        local defaultBoost = vehicleDefaultTable[veh].fInitialDriveForce
        local defaultTLoss = vehicleDefaultTable[veh].fLowSpeedTractionLossMult
        local newBoost = defaultBoost + defaultBoost * (boost / 200.0)
        local newTLoss = defaultTLoss + defaultTLoss * (boost / 20.0)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', newBoost)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', newTLoss)
    end

    if fuel == 0 and boost == 0 then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia', vehicleDefaultTable[veh].fDriveInertia)
    else
        local defaultBoost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
        local defaultDriveInertia = vehicleDefaultTable[veh].fDriveInertia
        local newBoost = defaultBoost + defaultBoost * (fuel / 200.0)
        local newDriveInertia = defaultDriveInertia - defaultDriveInertia * (fuel / 30.0)
        if newDriveInertia < 0.5 then newDriveInertia = 0.5 end
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', newBoost)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia', newDriveInertia)
    end
end

--[[
    -- Type: Function
    -- Name: doGears
    -- Use: Adjusts clutch shift speed and drag coefficient
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function doGears(amount, veh)
    if amount == 0 then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', vehicleDefaultTable[veh].fClutchChangeRateScaleUpShift)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', vehicleDefaultTable[veh].fClutchChangeRateScaleDownShift)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', vehicleDefaultTable[veh].fInitialDragCoeff)
    else
        local newUp = vehicleDefaultTable[veh].fClutchChangeRateScaleUpShift + amount
        local newDown = vehicleDefaultTable[veh].fClutchChangeRateScaleDownShift + amount
        local newDrag = vehicleDefaultTable[veh].fInitialDragCoeff + (amount / 50.0)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', newUp)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', newDown)
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', newDrag)
    end
end

--[[
    -- Type: Function
    -- Name: doBraking
    -- Use: Adjusts braking bias
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function doBraking(amount, veh)
    if amount == 5 then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront', vehicleDefaultTable[veh].fBrakeBiasFront)
    else
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront', amount / 10.0)
    end
end

--[[
    -- Type: Function
    -- Name: doDrive
    -- Use: Adjusts drive bias
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function doDrive(amount, veh)
    if amount == 5 then
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront', vehicleDefaultTable[veh].fDriveBiasFront)
    else
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront', amount / 10.0)
    end
end

--[[
    -- Type: Function
    -- Name: modify
    -- Use: Applies handling modifications and syncs with server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function modify(boost, fuel, gears, braking, drive, veh, plate)
    doBoostFuel(boost, fuel, veh)
    doGears(gears, veh)
    doBraking(braking, veh)
    doDrive(drive, veh)
    TriggerServerEvent('tuner:modify', vehicleTable[veh], vehicleDefaultTable[veh], plate)
end

RegisterNetEvent('tuner:setNew', function(defaultTable, newTable)
    vehicleDefaultTable = defaultTable
    vehicleTable = newTable
end)

RegisterNetEvent('tuner:setDriver', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then return end
    if vehicleTable[veh] then
        Wait(1000)
        local values = vehicleTable[veh]
        modify(values[1], values[2], values[3], values[4], values[5], veh, GetVehicleNumberPlateText(veh))
    end
end)

RegisterNetEvent('tuner:open', function()
    Wait(1000)
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then return end
    if GetEntitySpeed(veh) >= 0.1 then return end

    if not vehicleTable[veh] then
        vehicleDefaultTable[veh] = {
            fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'),
            fClutchChangeRateScaleUpShift = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift'),
            fClutchChangeRateScaleDownShift = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift'),
            fBrakeBiasFront = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront'),
            fDriveBiasFront = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront'),
            fMass = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fMass'),
            fInitialDragCoeff = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff'),
            fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce'),
            fLowSpeedTractionLossMult = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult'),
            fDriveInertia = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia')
        }
        vehicleTable[veh] = {0, 0, 0, 5, 5}
    end

    local data = vehicleTable[veh]
    openGui(data[1], data[2], data[3], data[4], data[5])
end)

RegisterNUICallback('tuneSystem', function(data, cb)
    closeGui()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then
        cb('fail')
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    vehicleTable[veh][1] = data.boost
    vehicleTable[veh][2] = data.fuel
    vehicleTable[veh][3] = data.gears
    vehicleTable[veh][4] = data.braking
    vehicleTable[veh][5] = data.drive
    modify(data.boost, data.fuel, data.gears, data.braking, data.drive, veh, plate)
    cb('ok')
end)
