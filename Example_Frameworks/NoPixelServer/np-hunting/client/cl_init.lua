--[[
    -- Type: Function
    -- Name: initializeHuntingZones
    -- Use: Registers the hunting sales zone on resource start
    -- Created: 2024-06-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    exports["np-polyzone"]:AddCircleZone(
        "huntingsales",
        vector3(569.32, 2796.66, 42.02),
        2.0,
        {
            useZ = true,
        }
    )
end)
