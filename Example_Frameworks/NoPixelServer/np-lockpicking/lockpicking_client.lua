--[[
    -- Type: Script
    -- Name: lockpicking_client
    -- Use: Handles client-side lockpicking minigame logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local gui = false
local currentlyInGame = false
local passed = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Displays NUI for lockpicking
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function openGui()
    gui = true
    SetNuiFocus(true, true)
    SendNUIMessage({ openPhone = true })
end

--[[
    -- Type: Function
    -- Name: playGame
    -- Use: Sends configuration to UI to start the minigame
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function playGame(pickhealth, pickdamage, pickPadding, distance)
    SendNUIMessage({
        openSection = "playgame",
        health = pickhealth,
        damage = pickdamage,
        padding = pickPadding,
        solveDist = distance
    })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Hides the lockpicking UI and clears focus
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeGui()
    currentlyInGame = false
    gui = false
    SetNuiFocus(false, false)
    SendNUIMessage({ openPhone = false })
end

--[[
    -- Type: Function
    -- Name: lockpick
    -- Use: Launches the lockpicking minigame; returns 100 on success, 0 on failure
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function lockpick(pickhealth, pickdamage, pickPadding, distance)
    passed = false
    openGui()
    playGame(pickhealth, pickdamage, pickPadding, distance)
    currentlyInGame = true

    while currentlyInGame do
        Citizen.Wait(400)
        if exports["isPed"]:isPed("dead") then
            closeGui()
        end
    end

    return passed and 100 or 0
end

RegisterNUICallback("close", function(_, cb)
    passed = false
    closeGui()
    cb("ok")
end)

RegisterNUICallback("failure", function(_, cb)
    passed = false
    TriggerEvent("evidence:bleeding")
    closeGui()
    cb("ok")
end)

RegisterNUICallback("complete", function(_, cb)
    passed = true
    closeGui()
    cb("ok")
end)

