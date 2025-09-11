local displayDistance = 15.0
local displayKey = 20

local currentCharacters = {}
local isPlayerMenuActive = false

--[[
    -- Type: Event Handler
    -- Name: fsn_main:updateCharacters
    -- Use: Updates the local cache of active character data
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_main:updateCharacters', function(tbl)
    currentCharacters = tbl or {}
end)

--[[
    -- Type: Function
    -- Name: drawPlayerId
    -- Use: Renders a player server ID above their head
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]
local function drawPlayerId(coords, text, talking)
    local onScreen, sx, sy = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - coords)
    local scale = (1 / dist) * 2 * (1 / GetGameplayCamFov()) * 100

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(0)
    SetTextProportional(1)
    if talking then
        SetTextColour(0, 0, 255, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(sx, sy)
end

--[[
    -- Type: Function
    -- Name: displayPlayerMenu
    -- Use: Sends player data to the NUI scoreboard
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]
local function displayPlayerMenu()
    local players = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(playerId) then
            local serverId = GetPlayerServerId(playerId)
            for _, character in pairs(currentCharacters) do
                if character.ply_id == serverId then
                    players[#players + 1] = {
                        ply_id = character.ply_id,
                        ply_name = character.ply_name,
                        char_name = string.format('%s %s', character.char_fname, character.char_lname)
                    }
                    break
                end
            end
        end
    end

    SendNUIMessage({
        type = 'show',
        players = players
    })
    isPlayerMenuActive = true
end

--[[
    -- Type: Function
    -- Name: hidePlayerMenu
    -- Use: Hides the scoreboard NUI
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]
local function hidePlayerMenu()
    SendNUIMessage({ type = 'hide' })
    isPlayerMenuActive = false
end

--[[
    -- Type: Thread
    -- Name: scoreboardLoop
    -- Use: Handles scoreboard toggling and player ID rendering
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local keyHeld = IsControlPressed(0, displayKey)
        local myCoords = GetEntityCoords(PlayerPedId())

        if keyHeld then
            if not isPlayerMenuActive then
                displayPlayerMenu()
                TriggerEvent('chatMessage', '', {255, 255, 255}, '^1^*NOTICE |^0^r Use "/playerinfo ID" for reporting.')
            end

            for _, playerId in ipairs(GetActivePlayers()) do
                if NetworkIsPlayerActive(playerId) then
                    local ped = GetPlayerPed(playerId)
                    local coords = GetEntityCoords(ped)
                    local dist = #(myCoords - coords)
                    if dist < displayDistance then
                        drawPlayerId(coords + vec(0.0, 0.0, 1.0), tostring(GetPlayerServerId(playerId)), NetworkIsPlayerTalking(playerId))
                    end
                end
            end
        elseif isPlayerMenuActive then
            hidePlayerMenu()
        end
    end
end)
