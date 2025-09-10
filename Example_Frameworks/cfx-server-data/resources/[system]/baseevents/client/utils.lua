--[[
    -- Type: Function
    -- Name: GetPedVehicleSeat
    -- Use: Returns the seat index occupied by the specified ped
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
            if GetPedInVehicleSeat(vehicle, i) == ped then
                return i
            end
        end
    end
    return -2
end

