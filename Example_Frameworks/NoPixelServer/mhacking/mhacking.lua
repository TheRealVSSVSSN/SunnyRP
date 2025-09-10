--[[
    -- Type: Script
    -- Name: mhacking.lua
    -- Use: Handles the client-side logic for the hacking minigame
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local mhackingCallback = nil
local showHelp = false
local helpTimer = 0
local helpCycle = 4000

CreateThread(function()
    while true do
        local waitMs = 1000
        if showHelp then
            waitMs = 0
            local gameTimer = GetGameTimer()
            if helpTimer > gameTimer then
                showHelpText("Navigate with ~y~W,A,S,D~s~ and confirm with ~y~SPACE~s~ for the left code block.")
            elseif helpTimer > gameTimer - helpCycle then
                showHelpText("Use the ~y~Arrow Keys~s~ and ~y~ENTER~s~ for the right code block")
            else
                helpTimer = gameTimer + helpCycle
            end
        end
        Wait(waitMs)
    end
end)

--[[
    -- Type: Function
    -- Name: showHelpText
    -- Use: Displays instructional text to the player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function showHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

--[[
    -- Type: Event
    -- Name: mhacking:show
    -- Use: Displays the hacking interface
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('mhacking:show', function()
    SendNUIMessage({ show = true })
    SetNuiFocus(true, true)
end)

--[[
    -- Type: Event
    -- Name: mhacking:hide
    -- Use: Hides the hacking interface and clears state
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('mhacking:hide', function()
    SendNUIMessage({ show = false })
    SetNuiFocus(false, false)
    showHelp = false
    mhackingCallback = nil
end)

--[[
    -- Type: Event
    -- Name: mhacking:start
    -- Use: Starts the hacking minigame with the given parameters
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('mhacking:start', function(solutionLength, duration, locationID, callback)
    mhackingCallback = callback
    SendNUIMessage({
        s = solutionLength,
        d = duration,
        start = true,
        locationID = locationID
    })
    helpTimer = GetGameTimer() + helpCycle
    showHelp = true
end)

--[[
    -- Type: NUI Callback
    -- Name: callback
    -- Use: Receives results from the NUI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('callback', function(data, cb)
    if mhackingCallback then
        mhackingCallback(data.success, data.locationID, data.timeremaining)
    end
    cb('ok')
end)

--[[
    -- Type: Event
    -- Name: hacking:attemptHack
    -- Use: Initiates a hack attempt on nearby device
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('hacking:attemptHack', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local objFound = GetClosestObjectOfType(coords, 5.0, 1801703294, false, false, false)
    if objFound ~= 0 then
        TriggerEvent('mhacking:show')
        TriggerEvent('mhacking:start', 5, 45, 0, hackCallback)
    else
        TriggerEvent('DoShortHudText', 'No devices.', 2)
    end
end)

local typeSent = 'crack'

--[[
    -- Type: Event
    -- Name: hacking:attemptHackCrypto
    -- Use: Starts hack for crypto items
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('hacking:attemptHackCrypto', function(typeSentNow)
    typeSent = typeSentNow
    TriggerEvent('mhacking:show')
    TriggerEvent('mhacking:start', 5, 45, 0, hackCallbackCrypto)
end)

--[[
    -- Type: Function
    -- Name: hackCallbackCrypto
    -- Use: Handles crypto hack result
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function hackCallbackCrypto(success, loc, time)
    if success then
        TriggerEvent('stocks:buyitem', typeSent)
    end
    TriggerEvent('mhacking:hide')
end

--[[
    -- Type: Function
    -- Name: hackCallback
    -- Use: Handles generic hack result
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function hackCallback(success, loc, timeremaining)
    TriggerEvent('mhacking:hide')
end


