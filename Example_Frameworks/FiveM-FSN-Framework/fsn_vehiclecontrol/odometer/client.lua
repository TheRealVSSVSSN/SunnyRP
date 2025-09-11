CreateThread(function()
    local bufferD = 0
    local isInDriverSeat = false
    while true do Wait(1)
        local currentPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
            isInDriverSeat = true
        else
            isInDriverSeat = false
        end
        if isInDriverSeat then
            if GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false)) then
                if Speed > 0.5 then --Speed is from carhud.lua
                    local timeA = GetGameTimer()
                    Wait(1000)
                    local timeB = GetGameTimer()
                    local timeAB = timeB - timeA
                    local distanceTraveled = ((Speed * 0.000278) * timeAB) / 1000
                    if distanceTraveled < 1 then
                        bufferD = bufferD + distanceTraveled
                        if bufferD >= 1 then
                            print('Updating mileage with current plate:', currentPlate)
                            TriggerServerEvent('fsn_odometer:addMileage', currentPlate, bufferD)
                            bufferD = 0
                        end
                    end
                end
            end
        elseif (bufferD >= 0.01) then
            local leftPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
            print('driver left seat - adding mileage to the vehicle', leftPlate)
            TriggerServerEvent('fsn_odometer:addMileage', leftPlate, bufferD)
            bufferD = 0
        end
    end
end)

