--[[ 
    -- Type: Client Script
    -- Name: raid_carmenu
    -- Use: Vehicle interaction menu client
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]

local enabled = false
local vehicle = 0
local vehicleFuel = 0.0

--[[
    -- Type: Function
    -- Name: enableGUI
    -- Use: Toggle NUI focus and visibility
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
local function enableGUI(enable)
    enabled = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({ type = 'enablecarmenu', enable = enable })
end

--[[
    -- Type: Function
    -- Name: checkSeat
    -- Use: Determine seat status
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
local function checkSeat(ped, veh, seatIndex)
    local seatPed = GetPedInVehicleSeat(veh, seatIndex)
    if seatPed == ped then
        return seatIndex
    elseif seatPed ~= 0 then
        return false
    end
    return true
end

--[[
    -- Type: Function
    -- Name: refreshUI
    -- Use: Send vehicle state to NUI
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
local function refreshUI()
    local settings = {}
    local ped = PlayerPedId()
    vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 then
        settings.seat1 = checkSeat(ped, vehicle, -1)
        settings.seat2 = checkSeat(ped, vehicle, 0)
        settings.seat3 = checkSeat(ped, vehicle, 1)
        settings.seat4 = checkSeat(ped, vehicle, 2)
        settings.doorAccess = (settings.seat1 == -1)

        if GetVehicleDoorAngleRatio(vehicle, 0) ~= 0 then settings.door0 = true end
        if GetVehicleDoorAngleRatio(vehicle, 1) ~= 0 then settings.door1 = true end
        if GetVehicleDoorAngleRatio(vehicle, 2) ~= 0 then settings.door2 = true end
        if GetVehicleDoorAngleRatio(vehicle, 3) ~= 0 then settings.door3 = true end
        if GetVehicleDoorAngleRatio(vehicle, 4) ~= 0 then settings.hood = true end
        if GetVehicleDoorAngleRatio(vehicle, 5) ~= 0 then settings.trunk = true end

        if not IsVehicleWindowIntact(vehicle, 0) then settings.windowr1 = true end
        if not IsVehicleWindowIntact(vehicle, 1) then settings.windowl1 = true end
        if not IsVehicleWindowIntact(vehicle, 2) then settings.windowr2 = true end
        if not IsVehicleWindowIntact(vehicle, 3) then settings.windowl2 = true end

        settings.engine = GetIsVehicleEngineRunning(vehicle)

        SendNUIMessage({ type = 'refreshcarmenu', settings = settings })
    else
        SendNUIMessage({ type = 'resetcarmenu' })
    end
end

--[[
    -- Type: Net Event
    -- Name: veh:options
    -- Use: Show vehicle options menu
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('veh:options', function()
    enableGUI(true)
end)

--[[
    -- Type: Thread
    -- Name: FuelWatcher
    -- Use: Cache vehicle and fuel level
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then
            local tempFuel = GetVehicleFuelLevel(vehicle)
            if tempFuel > 0 then
                vehicleFuel = tempFuel
            end
        end
        Wait(2000)
    end
end)

--[[
    -- Type: Thread
    -- Name: UIUpdater
    -- Use: Update UI when menu enabled
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        if vehicle ~= 0 and enabled then
            refreshUI()
            Wait(0)
        else
            Wait(100)
        end
    end
end)

--[[
    -- Type: NUI Callback
    -- Name: openDoor
    -- Use: Toggle door state
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('openDoor', function(data, cb)
    local doorIndex = tonumber(data.doorIndex)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh ~= 0 then
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus == 1 or lockStatus == 0 then
            if GetVehicleDoorAngleRatio(veh, doorIndex) == 0 then
                SetVehicleDoorOpen(veh, doorIndex, false, false)
            else
                SetVehicleDoorShut(veh, doorIndex, false)
            end
        end
    end
    cb('ok')
end)

--[[
    -- Type: NUI Callback
    -- Name: switchSeat
    -- Use: Move player to selected seat
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('switchSeat', function(data, cb)
    local seatIndex = tonumber(data.seatIndex)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        SetPedIntoVehicle(ped, veh, seatIndex)
    end
    cb('ok')
end)

--[[
    -- Type: NUI Callback
    -- Name: togglewindow
    -- Use: Toggle window up/down
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('togglewindow', function(data, cb)
    local windowIndex = tonumber(data.windowIndex)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        if not IsVehicleWindowIntact(veh, windowIndex) then
            RollUpWindow(veh, windowIndex)
            if not IsVehicleWindowIntact(veh, windowIndex) then
                RollDownWindow(veh, windowIndex)
            end
        else
            RollDownWindow(veh, windowIndex)
        end
    end
    cb('ok')
end)

--[[
    -- Type: NUI Callback
    -- Name: toggleengine
    -- Use: Toggle vehicle engine state
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('toggleengine', function(_, cb)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local engine = not GetIsVehicleEngineRunning(veh)
        if not IsPedInAnyHeli(ped) then
            SetVehicleEngineOn(veh, engine, false, true)
            SetVehicleJetEngineOn(veh, engine)
        else
            if engine then
                SetVehicleFuelLevel(veh, vehicleFuel)
            else
                SetVehicleFuelLevel(veh, 0.0)
            end
        end
    end
    cb('ok')
end)

--[[
    -- Type: NUI Callback
    -- Name: escape
    -- Use: Close car menu
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('escape', function(_, cb)
    enableGUI(false)
    cb('ok')
end)

--[[
    -- Type: Seat Shuffle
    -- Name: disableSeatShuffle
    -- Use: Prevent auto seat swapping
    -- Created: 2024-05-10
    -- By: VSSVSSN
--]]
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

CreateThread(function()
    while true do
        Wait(100)
        local ped = PlayerPedId()
        if disableShuffle and IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, 0) == ped and GetIsTaskActive(ped, 165) then
                SetPedIntoVehicle(ped, veh, 0)
            end
        end
    end
end)
