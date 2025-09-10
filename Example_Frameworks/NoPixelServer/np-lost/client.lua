
--[[
    -- Type: Thread
    -- Name: loadClubhouse
    -- Use: Ensures biker clubhouse interior loads with default configuration
    -- Created: 2023-09-10
    -- By: VSSVSSN
]]
CreateThread(function()
    while not BikerClubhouse1 or not BikerClubhouse1.LoadDefault do
        Wait(0)
    end
    BikerClubhouse1.LoadDefault()
end)

