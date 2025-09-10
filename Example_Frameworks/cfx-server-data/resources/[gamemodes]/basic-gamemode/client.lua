--[[
    -- Type: Local Function
    -- Name: initializeSpawn
    -- Use: Enables automatic player spawning using spawnmanager and forces initial respawn.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function initializeSpawn()
    local spawnManager = exports.spawnmanager

    if not spawnManager or not spawnManager.forceRespawn then
        print('^1[basic-gamemode] spawnmanager export unavailable.^0')
        return
    end

    spawnManager:setAutoSpawn(true)
    spawnManager:forceRespawn()
end

--[[
    -- Type: Event Handler
    -- Name: onClientMapStart
    -- Use: Trigger spawn initialization when the map is loaded.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('onClientMapStart', function()
    CreateThread(initializeSpawn)
end)

--[[
    -- Type: Event Handler
    -- Name: onClientResourceStart
    -- Use: Ensures spawn initialization when resource starts or restarts.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(initializeSpawn)
    end
end)

--[[
    -- Type: Event Handler
    -- Name: onResourceStop
    -- Use: Disables auto spawn when the resource is stopped.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local spawnManager = exports.spawnmanager
        if spawnManager then
            spawnManager:setAutoSpawn(false)
        end
    end
end)
