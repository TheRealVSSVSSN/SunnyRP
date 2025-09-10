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
    -- Name: Yoga Activity
    -- Use: Allows players to perform yoga to reduce stress
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local yogaStartKey = Util.GetKeyNumber("E")
local yogaEndKey   = Util.GetKeyNumber("DELETE")

local DRAW_TEXT_DIST = 2.0
local CHECK_DIST     = 10.0
local YOGA_LOCATION  = vector3(-1217.31, -1543.11, 4.72)
local YOGA_SPOTS     = {
    vector3(-1217.31, -1543.11, 4.72),
    vector3(-1223.25, -1546.05, 4.72),
    vector3(-1228.80, -1549.44, 4.72)
}

local doingYoga = false

local Blips = {
    YogaBliss = {
        Zone    = 'Yoga Bliss',
        Sprite  = 480,
        Scale   = 1.0,
        Display = 4,
        Color   = 7,
        Pos     = { x = -1224.85, y = -1547.37, z = 4.62 }
    }
}

--[[
    -- Type: Function
    -- Name: createBlips
    -- Use: Generates map blips for yoga locations
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
    -- Use: Returns the closest yoga spot to the player
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function getNearestSpot(playerPos)
    local nearestDist, nearestPos
    for _, v in ipairs(YOGA_SPOTS) do
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
    -- Name: cancelYoga
    -- Use: Ends the yoga session immediately
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function cancelYoga(ped)
    exports['mythic_notify']:DoCustomHudText('inform', 'You ended yoga early and need 15s rest.', 3000)
    doingYoga = false
    ClearPedTasksImmediately(ped)
end

--[[
    -- Type: Function
    -- Name: startYoga
    -- Use: Plays the yoga scenario and handles stress relief
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function startYoga(ped)
    exports['mythic_notify']:DoCustomHudText('inform', 'Preparing the exercise...', 1000)
    Wait(1000)
    TaskStartScenarioInPlace(ped, 'world_human_yoga', 0, true)
    Wait(15000)
    TriggerEvent('fsn_yoga:checkStress')
    ClearPedTasksImmediately(ped)
end

CreateThread(function()
    createBlips()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        local dist = Util.GetVecDist(playerPos, YOGA_LOCATION)
        if dist < CHECK_DIST then
            sleep = 0
            local nearestDist, nearestPos = getNearestSpot(playerPos)
            if not doingYoga and nearestDist < DRAW_TEXT_DIST then
                Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~g~[ E ] ~s~ to begin yoga')
                if IsControlJustPressed(0, yogaStartKey) or IsDisabledControlJustPressed(0, yogaStartKey) then
                    doingYoga = true
                    startYoga(ped)
                end
            elseif doingYoga and nearestDist < DRAW_TEXT_DIST then
                Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~r~[ DELETE ] ~s~ to cancel yoga')
                if IsControlJustPressed(0, yogaEndKey) or IsDisabledControlJustPressed(0, yogaEndKey) then
                    cancelYoga(ped)
                end
            end
        end
        Wait(sleep)
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_yoga:checkStress
    -- Use: Removes stress after a completed yoga session
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_yoga:checkStress')
AddEventHandler('fsn_yoga:checkStress', function()
    if doingYoga then
        TriggerEvent('fsn_needs:stress:remove', 10)
        doingYoga = false
    else
        doingYoga = false
    end
end)
