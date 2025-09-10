--[[
    -- Type: Variable
    -- Name: hasShutdown
    -- Use: Prevents multiple shutdown calls
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local hasShutdown = false

--[[
    -- Type: Event
    -- Name: loading:disableLoading
    -- Use: Shuts down the loading screen NUI when loading is complete
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('loading:disableLoading', function()
    if not hasShutdown then
        ShutdownLoadingScreenNui()
        hasShutdown = true
    end
end)

--[[
    -- Type: Thread
    -- Name: SetNuiFocus
    -- Use: Releases NUI focus so gameplay input works
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    SetNuiFocus(false, false)
end)
