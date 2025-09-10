--[[
    -- Type: Table
    -- Name: SPAWN_LOCATIONS
    -- Use: Defines ped spawn locations inside the strip club
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local SPAWN_LOCATIONS = {
    vector4(129.5597, -1284.0890, 29.2738, 330.0113),
    vector4(110.08145, -1288.53723, 28.8587, 294.5889),
    vector4(118.07535, -1285.35449, 28.27165, 41.3578),
    vector4(118.07535, -1285.35449, 28.27165, 41.3578)
}

--[[
    -- Type: Table
    -- Name: PED_MODELS
    -- Use: Available stripper ped models
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local PED_MODELS = {
    695248020,
    1544875514,
    1846523796,
    1381498905
}

local FRONT_DOOR = vector3(130.26553, -1301.17908, 29.23275)
local BACK_DOOR = vector3(92.16235, -1282.21716, 29.24653)

local StressRelief = false

--[[
    -- Type: Event
    -- Name: stripclub:stressLoss
    -- Use: Controls stress relief when entering/exiting the strip club
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('stripclub:stressLoss')
AddEventHandler('stripclub:stressLoss', function(switchOn)
    local distance = #(FRONT_DOOR - GetEntityCoords(PlayerPedId()))
    if distance < 50.0 then
        if switchOn then
            TriggerServerEvent('server:pass', 'strip_club')
        else
            StressRelief = false
        end
    end
end)

--[[
    -- Type: Event
    -- Name: dostripstress
    -- Use: Activates stress relief after server validation
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('dostripstress')
AddEventHandler('dostripstress', function()
    StressRelief = true
    print('strip club stress relief enabled')
end)

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Requests and loads an animation dictionary
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end
end

--[[
    -- Type: Function
    -- Name: getRandomPedModel
    -- Use: Returns a random stripper ped model hash
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local function getRandomPedModel()
    return PED_MODELS[math.random(#PED_MODELS)]
end

--[[
    -- Type: Function
    -- Name: isStripperModel
    -- Use: Checks if a model hash belongs to a stripper ped
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local function isStripperModel(model)
    for _, hash in ipairs(PED_MODELS) do
        if model == hash then
            return true
        end
    end
    return false
end

--[[
    -- Type: Function
    -- Name: findNPC
    -- Use: Checks if a stripper ped already exists near coordinates
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local function findNPC(x, y, z)
    local handle, ped = FindFirstPed()
    local success, found = true, false
    repeat
        local pos = GetEntityCoords(ped)
        if #(vector3(x, y, z) - pos) < 20.0 and isStripperModel(GetEntityModel(ped)) then
            if IsEntityDead(ped) then
                DeleteEntity(ped)
            else
                found = true
            end
        end
        success, ped = FindNextPed(handle)
    until not success or found
    EndFindPed(handle)
    return found
end

--[[
    -- Type: Function
    -- Name: spawnPeds
    -- Use: Spawns ambient stripper peds if none are nearby
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
local function spawnPeds(skipBar)
    for index, loc in ipairs(SPAWN_LOCATIONS) do
        if not (skipBar and index == 1) then
            local model = getRandomPedModel()
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end
            if not exports['isPed']:IsPedNearCoords(loc.x, loc.y, loc.z) then
                local ped = CreatePed(5, model, loc.x, loc.y, loc.z, loc.w, true, true)
                DecorSetBool(ped, 'ScriptedPed', true)
                SetPedDropsWeaponsWhenDead(ped, false)
                if index == 1 then
                    TaskStartScenarioAtPosition(ped, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', loc.x, loc.y, loc.z, loc.w, 0, true, false)
                    FreezeEntityPosition(ped, true)
                else
                    TaskWanderInArea(ped, loc.x, loc.y, loc.z, 4.0, 2.0, 2.0)
                end
                SetPedComponentVariation(ped, 3, 1, 1, 1)
                SetPedAlertness(ped, 0)
                SetPedCombatAbility(ped, 0)
                SetPedCombatRange(ped, 0)
                SetPedTargetLossResponse(ped, 1)
                SetPedSeeingRange(ped, 0.0)
                SetPedHearingRange(ped, 0.0)
                local netId = NetworkGetNetworkIdFromEntity(ped)
                SetNetworkIdCanMigrate(netId, true)
            end
        end
    end
end

--[[
    -- Type: Function
    -- Name: privdance
    -- Use: Performs the private dance animation sequence
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
function privdance(ped)
    ClearPedSecondaryTask(ped)
    SetEntityCollision(ped, false, false)

    loadAnimDict('mini@strip_club@private_dance@part1')
    loadAnimDict('mini@strip_club@private_dance@part2')
    loadAnimDict('mini@strip_club@private_dance@part3')

    TaskPlayAnim(ped, 'mini@strip_club@private_dance@part1', 'priv_dance_p1', 1.0, -1.0, -1, 0, 1.0, false, false, false)
    Wait(GetAnimDuration('mini@strip_club@private_dance@part1', 'priv_dance_p1'))
    TaskPlayAnim(ped, 'mini@strip_club@private_dance@part2', 'priv_dance_p2', 1.0, -1.0, -1, 0, 1.0, false, false, false)
    Wait(GetAnimDuration('mini@strip_club@private_dance@part2', 'priv_dance_p2'))
    TaskPlayAnim(ped, 'mini@strip_club@private_dance@part3', 'priv_dance_p3', 1.0, -1.0, -1, 0, 1.0, false, false, false)
    Wait(GetAnimDuration('mini@strip_club@private_dance@part3', 'priv_dance_p3'))

    SetEntityCollision(ped, true, true)
end

--[[
    -- Type: Thread
    -- Name: mainLoop
    -- Use: Handles ped spawning and stress relief logic
    -- Created: 2024-04-17
    -- By: VSSVSSN
--]]
CreateThread(function()
    DecorRegister('ScriptedPed', 2)
    while true do
        local sleep = 1000
        local playerPos = GetEntityCoords(PlayerPedId())
        local frontDist = #(FRONT_DOOR - playerPos)
        local backDist = #(BACK_DOOR - playerPos)

        if StressRelief and math.random(1000) > 998 then
            TriggerEvent('client:newStress', false, math.random(200, 1250))
        end

        if frontDist < 50.0 then
            sleep = 1
            if not findNPC(110.87651, -1302.28210, 29.26948) then
                if frontDist < 3.0 or backDist < 3.0 then
                    spawnPeds(backDist < 3.0)
                end
            end
        else
            StressRelief = false
        end

        Wait(sleep)
    end
end)

