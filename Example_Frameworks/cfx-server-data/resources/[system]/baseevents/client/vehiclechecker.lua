--[[
    -- Type: Thread
    -- Name: vehicleStateWatcher
    -- Use: Monitors vehicle entering and exiting events for the local player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    local isInVehicle = false
    local isEnteringVehicle = false
    local currentVehicle = 0
    local currentSeat = 0

    while true do
        local ped = PlayerPedId()

        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            local vehicle = GetVehiclePedIsTryingToEnter(ped)
            if DoesEntityExist(vehicle) and not isEnteringVehicle then
                local seat = GetSeatPedIsTryingToEnter(ped)
                local model = GetEntityModel(vehicle)
                local name = GetDisplayNameFromVehicleModel(model)
                local netId = VehToNet(vehicle)

                isEnteringVehicle = true
                TriggerServerEvent('baseevents:enteringVehicle', vehicle, seat, name, netId)
            elseif not DoesEntityExist(vehicle) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
                TriggerServerEvent('baseevents:enteringAborted')
                isEnteringVehicle = false
            elseif IsPedInAnyVehicle(ped, false) then
                isEnteringVehicle = false
                isInVehicle = true
                currentVehicle = GetVehiclePedIsUsing(ped)
                currentSeat = GetPedVehicleSeat(ped)
                local model = GetEntityModel(currentVehicle)
                local name = GetDisplayNameFromVehicleModel(model)
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, name, netId)
            end
        elseif isInVehicle then
            if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
                local model = GetEntityModel(currentVehicle)
                local name = GetDisplayNameFromVehicleModel(model)
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, name, netId)
                isInVehicle = false
                currentVehicle = 0
                currentSeat = 0
            end
        end
        Wait(50)
    end
end)

