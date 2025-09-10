--==--==--==--
-- Config
--==--==--==--
local noclipActive = false

local config = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        openKey = 170, -- [[F3]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },

    speeds = {
        -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
        { label = "Very slow", speed = 0},
        { label = "Slow", speed = 0.5},
        { label = "Normal", speed = 2},
        { label = "Fast", speed = 4},
        { label = "Very Fast", speed = 6},
        { label = "Extra Fast", speed = 10},
        { label = "Extra Fast v2.0", speed = 20},
        { label = "Max Speed", speed = 25}
        -- { label = "The Flash", speed = 50},
        -- { label = "God Speed", speed = 50000},
    },

    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3, -- [[How much you rotate. ]]
    },

    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}

--==--==--==--
-- End Of Config
--==--==--==--

local index = 1 -- [[Used to determine the index of the speeds table.]]
local currentSpeed = config.speeds[index].speed
local buttons
local noclipEntity

--[[ 
    -- Type: Function
    -- Name: toggleNoclip
    -- Use: Toggles noclip mode and handles entity state
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
local function toggleNoclip()
    noclipActive = not noclipActive
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        noclipEntity = GetVehiclePedIsIn(ped, false)
    else
        noclipEntity = ped
    end
    SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
    FreezeEntityPosition(noclipEntity, noclipActive)
    SetEntityInvincible(noclipEntity, noclipActive)
    SetVehicleRadioEnabled(noclipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
end

--[[ 
    -- Type: Function
    -- Name: handleMovement
    -- Use: Processes player movement while noclip is active
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
local function handleMovement()
    local yoff, zoff = 0.0, 0.0

    if IsControlPressed(0, config.controls.goForward) then
        yoff = config.offsets.y
    elseif IsControlPressed(0, config.controls.goBackward) then
        yoff = -config.offsets.y
    end

    if IsControlPressed(0, config.controls.goUp) then
        zoff = config.offsets.z
    elseif IsControlPressed(0, config.controls.goDown) then
        zoff = -config.offsets.z
    end

    if IsControlPressed(0, config.controls.turnLeft) then
        SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) + config.offsets.h)
    elseif IsControlPressed(0, config.controls.turnRight) then
        SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) - config.offsets.h)
    end

    local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
    local heading = GetEntityHeading(noclipEntity)
    SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
    SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
    SetEntityHeading(noclipEntity, heading)
    SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, false, false, false)
end

CreateThread(function()
    buttons = setupScaleform("instructional_buttons", config, index)

    while true do
        Wait(0)

        if IsControlJustPressed(1, config.controls.openKey) then
            toggleNoclip()
        end

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                index = index < #config.speeds and index + 1 or 1
                currentSpeed = config.speeds[index].speed
                buttons = setupScaleform("instructional_buttons", config, index)
            end

            handleMovement()
        end
    end
end)

--==--==--==--
-- End Of Script
--==--==--==--

--[[ 
    -- Type: Event
    -- Name: np-admin:noclipsway
    -- Use: Enables noclip via external trigger
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-admin:noclipsway', function()
    if not noclipActive then
        toggleNoclip()
    end
end)

--[[ 
    -- Type: Event
    -- Name: np-admin:nofc
    -- Use: Disables noclip via external trigger
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-admin:nofc', function()
    if noclipActive then
        toggleNoclip()
    end
end)

