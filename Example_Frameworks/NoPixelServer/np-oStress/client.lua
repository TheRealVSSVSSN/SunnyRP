--[[
    -- Type: Variable
    -- Name: stressLevel
    -- Use: Tracks the player's current stress level
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local stressLevel = 0

--[[
    -- Type: Variable
    -- Name: blockShake
    -- Use: Blocks camera shake when true
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local blockShake = false

--[[
    -- Type: Variable
    -- Name: devMode
    -- Use: Enables developer mode camera shake block
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local devMode = false

--[[
    -- Type: Function
    -- Name: isShakeBlocked
    -- Use: Determines if camera shake should be blocked
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local function isShakeBlocked()
    return blockShake or devMode
end

--[[
    -- Type: Event
    -- Name: client:updateStress
    -- Use: Updates the stress level from the server
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress", function(newStress)
    stressLevel = tonumber(newStress) or 0
end)

--[[
    -- Type: Event
    -- Name: client:blockShake
    -- Use: Toggles manual camera shake blocking
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent("client:blockShake")
AddEventHandler("client:blockShake", function(isBlocked)
    blockShake = isBlocked and true or false
end)

--[[
    -- Type: Event
    -- Name: np-admin:currentDevmode
    -- Use: Toggles developer mode camera shake blocking
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(enabled)
    devMode = enabled and true or false
end)

--[[
    -- Type: Function
    -- Name: handleStressShake
    -- Use: Applies camera shake based on current stress level
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local function handleStressShake()
    local levels = {
        {threshold = 7500, intensity = 0.1},
        {threshold = 4500, intensity = 0.07},
        {threshold = 2000, intensity = 0.02}
    }

    for _, data in ipairs(levels) do
        if stressLevel > data.threshold then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', data.intensity)
            break
        end
    end
end

--[[
    -- Type: Thread
    -- Name: StressCameraThread
    -- Use: Periodically applies camera shake based on stress
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        if not isShakeBlocked() then
            handleStressShake()
        end
        Wait(2000)
    end
end)


