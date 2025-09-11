-- luacheck: globals Util vector3 AddBlipForCoord SetBlipHighDetail SetBlipSprite
-- luacheck: globals SetBlipDisplay SetBlipScale SetBlipColour
-- luacheck: globals SetBlipAsShortRange BeginTextCommandSetBlipName
-- luacheck: globals AddTextComponentString
-- luacheck: globals EndTextCommandSetBlipName
-- luacheck: globals exports ClearPedTasksImmediately TaskStartScenarioInPlace Wait CreateThread
-- luacheck: globals PlayerPedId GetEntityCoords
-- luacheck: globals IsControlJustPressed IsDisabledControlJustPressed TriggerEvent RegisterNetEvent AddEventHandler
--[[
    -- Type: Module
    -- Name: Fishing Activity
    -- Use: Allows players to fish at designated locations
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local fishStartKey = Util.GetKeyNumber("E")
local fishEndKey   = Util.GetKeyNumber("DELETE")

local DRAW_TEXT_DIST = 2.0
local CHECK_DIST     = 15.0
local FISHING_SPOTS  = {
    vector3(-3426.1, 973.7, 8.35),
    vector3(-1512.0, 1500.0, 111.0) -- sample second spot
}

local fishing = false
local currentRod = nil

local Blips = {
    FishingPier = {
        Zone    = 'Fishing Pier',
        Sprite  = 68,
        Scale   = 0.8,
        Display = 4,
        Color   = 3,
        Pos     = { x = -3426.1, y = 973.7, z = 8.35 }
    }
}

--[[
    -- Type: Function
    -- Name: createBlips
    -- Use: Generates map blips for fishing spots
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function createBlips()
    for _, val in pairs(Blips) do
        local blip = AddBlipForCoord(val.Pos.x, val.Pos.y, val.Pos.z)
        SetBlipHighDetail(blip, true)
        SetBlipSprite(blip, val.Sprite)
        SetBlipDisplay(blip, val.Display)
        SetBlipScale(blip, val.Scale)
        SetBlipColour(blip, val.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(val.Zone)
        EndTextCommandSetBlipName(blip)
    end
end

--[[
    -- Type: Function
    -- Name: getNearestSpot
    -- Use: Returns the closest fishing spot to the player
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function getNearestSpot(playerPos)
    local nearestDist, nearestPos
    for _, v in ipairs(FISHING_SPOTS) do
        local curDist = Util.GetVecDist(playerPos, v)
        if not nearestDist or curDist < nearestDist then
            nearestDist = curDist
            nearestPos  = v
        end
    end
    return nearestDist, nearestPos
end

--[[
    -- Type: Function
    -- Name: cancelFishing
    -- Use: Ends the fishing session immediately
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function cancelFishing(ped)
    exports['mythic_notify']:DoCustomHudText('inform', 'You stopped fishing.', 3000)
    fishing = false
    if currentRod then
        ClearPedTasksImmediately(ped)
        currentRod = nil
    end
end

--[[
    -- Type: Function
    -- Name: startFishing
    -- Use: Plays the fishing scenario and grants a reward
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function startFishing(ped)
    exports['mythic_notify']:DoCustomHudText('inform', 'Casting your line...', 1000)
    TaskStartScenarioInPlace(ped, 'world_human_stand_fishing', 0, true)
    currentRod = ped
    Wait(math.random(10000, 15000))
    exports['mythic_notify']:DoCustomHudText('inform', 'You caught a fish!', 3000)
    ClearPedTasksImmediately(ped)
    currentRod = nil
end

CreateThread(function()
    createBlips()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        local dist, nearestPos = getNearestSpot(playerPos)
        if dist < CHECK_DIST then
            sleep = 0
            if not fishing and dist < DRAW_TEXT_DIST then
                Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~g~[ E ] ~s~ to fish')
                if IsControlJustPressed(0, fishStartKey) or IsDisabledControlJustPressed(0, fishStartKey) then
                    fishing = true
                    startFishing(ped)
                    fishing = false
                end
            elseif fishing and dist < DRAW_TEXT_DIST then
                Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~r~[ DELETE ] ~s~ to stop fishing')
                if IsControlJustPressed(0, fishEndKey) or IsDisabledControlJustPressed(0, fishEndKey) then
                    cancelFishing(ped)
                end
            end
        end
        Wait(sleep)
    end
end)
