--[[
    -- Type: Module
    -- Name: np-interior client
    -- Use: Handles basic interior entry and exit logic
    -- Created: 2024-06-15
    -- By: VSSVSSN
--]]

local Interiors = {
    {
        id = 'motel',
        entry = { coords = vector3(312.86, -218.73, 54.22), heading = 249.0 },
        inside = { coords = vector3(151.17, -1007.34, -98.999), heading = 0.0 }
    }
}

local WAIT_TIME <const> = 500

--[[
    -- Type: Function
    -- Name: teleportPlayer
    -- Use: Moves the player to specified coordinates with a fade effect
    -- Created: 2024-06-15
    -- By: VSSVSSN
--]]
local function teleportPlayer(coords, heading)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    SetEntityHeading(PlayerPedId(), heading)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Citizen.Wait(10)
    end

    DoScreenFadeIn(500)
end

--[[
    -- Type: Function
    -- Name: drawPrompt
    -- Use: Draws a marker and help text at given coordinates
    -- Created: 2024-06-15
    -- By: VSSVSSN
--]]
local function drawPrompt(coords, text)
    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        1.0, 1.0, 1.0, 0, 150, 255, 100, false, false, 2, false, nil, nil, false)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, 500)
end

--[[
    -- Type: Thread
    -- Name: interiorHandler
    -- Use: Monitors player position for interior entry/exit
    -- Created: 2024-06-15
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    while true do
        local sleep = WAIT_TIME
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, interior in ipairs(Interiors) do
            if #(pos - interior.entry.coords) < 1.5 then
                drawPrompt(interior.entry.coords, '~INPUT_CONTEXT~ Enter')
                if IsControlJustReleased(0, 38) then
                    teleportPlayer(interior.inside.coords, interior.inside.heading)
                    TriggerServerEvent('np-interior:entered', interior.id)
                end
                sleep = 0
            elseif #(pos - interior.inside.coords) < 1.5 then
                drawPrompt(interior.inside.coords, '~INPUT_CONTEXT~ Exit')
                if IsControlJustReleased(0, 38) then
                    teleportPlayer(interior.entry.coords, interior.entry.heading)
                end
                sleep = 0
            end
        end

        Citizen.Wait(sleep)
    end
end)

