--[[
    -- Type: Thread
    -- Name: MapZoomSetup
    -- Use: Applies custom minimap zoom levels.
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)  -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)  -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
end)

--[[
    -- Type: Function
    -- Name: applyRadarZoom
    -- Use: Keeps radar zoom consistent based on player state.
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local ZOOM_PED = 1100
local ZOOM_VEHICLE = 1100
local function applyRadarZoom()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        SetRadarZoom(ZOOM_VEHICLE)
    else
        SetRadarZoom(ZOOM_PED)
    end
end

--[[
    -- Type: Thread
    -- Name: RadarZoomLoop
    -- Use: Periodically updates radar zoom.
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        applyRadarZoom()
        Wait(500)
    end
end)
