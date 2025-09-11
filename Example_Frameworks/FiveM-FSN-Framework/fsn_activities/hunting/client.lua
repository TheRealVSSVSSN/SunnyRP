-- luacheck: globals Util vector3 AddBlipForCoord SetBlipHighDetail SetBlipSprite
-- luacheck: globals SetBlipDisplay SetBlipScale SetBlipColour
-- luacheck: globals SetBlipAsShortRange BeginTextCommandSetBlipName
-- luacheck: globals AddTextComponentString
-- luacheck: globals EndTextCommandSetBlipName
-- luacheck: globals exports ClearPedTasksImmediately TaskStartScenarioInPlace Wait CreateThread
-- luacheck: globals PlayerPedId GetEntityCoords
-- luacheck: globals IsControlJustPressed IsDisabledControlJustPressed TriggerEvent RegisterNetEvent AddEventHandler
-- luacheck: globals GetHashKey RequestModel HasModelLoaded GetOffsetFromEntityInWorldCoords
-- luacheck: globals CreatePed TaskWanderStandard SetEntityAsMissionEntity DoesEntityExist DeleteEntity IsEntityDead
--[[
    -- Type: Module
    -- Name: Hunting Activity
    -- Use: Spawns a target animal for players to hunt
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local huntStartKey = Util.GetKeyNumber("E")
local huntEndKey   = Util.GetKeyNumber("DELETE")

local DRAW_TEXT_DIST = 3.0
local CHECK_DIST     = 30.0
local HUNT_LOCATION  = vector3(-1123.5, 4875.7, 218.0)

local hunting = false
local targetAnimal

local Blips = {
    HuntingGround = {
        Zone    = 'Hunting Grounds',
        Sprite  = 141,
        Scale   = 0.8,
        Display = 4,
        Color   = 1,
        Pos     = { x = HUNT_LOCATION.x, y = HUNT_LOCATION.y, z = HUNT_LOCATION.z }
    }
}

--[[
    -- Type: Function
    -- Name: createBlips
    -- Use: Generates map blip for hunting area
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
    -- Name: spawnAnimal
    -- Use: Spawns the deer target for hunting
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function spawnAnimal(ped)
    local model = GetHashKey('a_c_deer')
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local spawnPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 30.0, 0.0)
    targetAnimal = CreatePed(28, model, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
    TaskWanderStandard(targetAnimal, 10.0, 10)
    SetEntityAsMissionEntity(targetAnimal, true, true)
end

--[[
    -- Type: Function
    -- Name: cancelHunt
    -- Use: Cancels the hunt and cleans up
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function cancelHunt()
    exports['mythic_notify']:DoCustomHudText('inform', 'Hunt canceled.', 3000)
    hunting = false
    if DoesEntityExist(targetAnimal) then
        DeleteEntity(targetAnimal)
    end
end

--[[
    -- Type: Function
    -- Name: startHunt
    -- Use: Initiates the hunting session
    -- Created: 2024-06-03
    -- By: VSSVSSN
--]]
local function startHunt(ped)
    exports['mythic_notify']:DoCustomHudText('inform', 'Hunt started. Track and kill the animal.', 3000)
    spawnAnimal(ped)
    hunting = true
end

CreateThread(function()
    createBlips()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        local dist = Util.GetVecDist(playerPos, HUNT_LOCATION)
        if dist < CHECK_DIST then
            sleep = 0
            if not hunting and dist < DRAW_TEXT_DIST then
                Util.DrawText3D(HUNT_LOCATION.x, HUNT_LOCATION.y, HUNT_LOCATION.z, 'Press ~g~[ E ] ~s~ to hunt')
                if IsControlJustPressed(0, huntStartKey) or IsDisabledControlJustPressed(0, huntStartKey) then
                    startHunt(ped)
                end
            elseif hunting then
                if DoesEntityExist(targetAnimal) then
                    if IsEntityDead(targetAnimal) then
                        exports['mythic_notify']:DoCustomHudText('success', 'Animal down! You collected meat.', 3000)
                        DeleteEntity(targetAnimal)
                        hunting = false
                    end
                end
                if IsControlJustPressed(0, huntEndKey) or IsDisabledControlJustPressed(0, huntEndKey) then
                    cancelHunt()
                end
            end
        end
        Wait(sleep)
    end
end)
