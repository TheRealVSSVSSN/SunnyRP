--[[
    -- Type: Function
    -- Name: GetVehicleInDirection
    -- Use: Raycasts between two coordinates to locate a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

function GetVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local vehicle = 0

    for _ = 0, 100 do
        local ray = StartShapeTestCapsule(
            coordFrom.x, coordFrom.y, coordFrom.z + offset,
            coordTo.x, coordTo.y, coordTo.z + offset,
            0.4, 10, PlayerPedId(), 7
        )
        local _, _, _, _, entityHit = GetShapeTestResult(ray)
        vehicle = entityHit
        if vehicle ~= 0 then break end
        offset = offset - 1
    end

    if vehicle ~= 0 then
        local distance = #(coordFrom - GetEntityCoords(vehicle))
        if distance > 25.0 then vehicle = 0 end
    end

    return vehicle
end
