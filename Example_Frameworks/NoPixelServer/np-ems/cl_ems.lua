--[[
    -- Type: Client Script
    -- Name: cl_ems.lua
    -- Use: Handles EMS job workflow for patient pickup and hospital delivery
    -- Created: 2024-10-06
    -- By: VSSVSSN
--]]

local onJob = false
local isSignedIn = false
local myPay = 0
local lastPatient = 0

local jobs = {
    peds = {},
    blips = {},
    vehicle = 0,
    stage = 0,
    destination = 0,
    coords = {
        vector3(363.92, -586.94, 28.68),
        vector3(-453.97, -339.53, 34.36),
        vector3(1843.39, 3667.17, 33.70),
        vector3(-239.13, 6334.14, 32.35),
        vector3(297.44, -1441.96, 29.80),
        vector3(-677.92, 295.53, 82.10),
        vector3(1153.57, -1512.72, 34.69),
        vector3(-876.66, -295.43, 39.77)
    }
}

--[[
    -- Type: Function
    -- Name: loadModel
    -- Use: Requests and loads a model into memory
--]]
local function loadModel(model)
    local hash = type(model) == "number" and model or GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    return hash
end

--[[
    -- Type: Function
    -- Name: drawMissionText
    -- Use: Displays temporary mission text on screen
--]]
local function drawMissionText(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time or 5000, true)
end

--[[
    -- Type: Function
    -- Name: showLoadingPrompt
    -- Use: Shows a loading spinner with text for a given time
--]]
local function showLoadingPrompt(text, time, spinner)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandBusyString(spinner or 3)
        Citizen.Wait(time or 1000)
        RemoveLoadingPrompt()
    end)
end

--[[
    -- Type: Function
    -- Name: stopJob
    -- Use: Cleans up current mission and resets state
--]]
local function stopJob()
    if jobs.peds[1] and DoesEntityExist(jobs.peds[1]) then
        if jobs.blips[1] and DoesBlipExist(jobs.blips[1]) then
            RemoveBlip(jobs.blips[1])
        end
        ClearPedTasksImmediately(jobs.peds[1])
        SetEntityAsNoLongerNeeded(jobs.peds[1])
        DeletePed(jobs.peds[1])
        jobs.peds[1] = nil
    end
    if jobs.blips[1] and DoesBlipExist(jobs.blips[1]) then
        RemoveBlip(jobs.blips[1])
        jobs.blips[1] = nil
    end
    jobs.vehicle = 0
    jobs.stage = 0
    onJob = false
end

--[[
    -- Type: Function
    -- Name: beginTransport
    -- Use: Sets a hospital destination and guides player there
--]]
local function beginTransport()
    jobs.stage = 3
    jobs.destination = math.random(#jobs.coords)
    local dest = jobs.coords[jobs.destination]
    jobs.blips[1] = AddBlipForCoord(dest.x, dest.y, dest.z)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Hospital")
    EndTextCommandSetBlipName(jobs.blips[1])
    SetBlipRoute(jobs.blips[1], true)
    local playerPos = GetEntityCoords(PlayerPedId())
    myPay = CalculateTravelDistanceBetweenPoints(playerPos, dest.x, dest.y, dest.z)
    myPay = math.min(250, math.ceil(myPay * 0.25))
end

--[[
    -- Type: Function
    -- Name: spawnPatient
    -- Use: Finds a nearby random pedestrian to act as a patient
--]]
local function spawnPatient()
    local pos = GetEntityCoords(PlayerPedId())
    local randX = GetRandomIntInRange(35, 155)
    local randY = GetRandomIntInRange(35, 155)
    local randZ = GetRandomIntInRange(35, 55)
    local ped = GetRandomPedAtCoord(pos.x, pos.y, pos.z, randX + 0.001, randY + 0.001, randZ + 0.001, 6)
    if DoesEntityExist(ped) and GetPedType(ped) ~= 28 and ped ~= lastPatient then
        jobs.peds[1] = ped
        SetEntityHealth(ped, math.floor(GetEntityMaxHealth(ped) / 2))
        ClearPedTasksImmediately(ped)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BUM_STANDING", 0, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        jobs.blips[1] = AddBlipForEntity(ped)
        SetBlipAsFriendly(jobs.blips[1], true)
        SetBlipColour(jobs.blips[1], 2)
        drawMissionText("The ~g~patient~w~ is waiting for you. Drive nearby", 5000)
        jobs.stage = 1
    else
        jobs.stage = 0
    end
end

--[[
    -- Type: Function
    -- Name: startJob
    -- Use: Initializes EMS job when player enters ambulance
--]]
local function startJob()
    showLoadingPrompt("Loading EMS mission", 2000, 3)
    jobs.vehicle = GetVehiclePedIsUsing(PlayerPedId())
    jobs.stage = 0
    onJob = true
    drawMissionText("Drive around until you get a ~y~call~w~.", 10000)
end

-- Event Handlers

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)
    isSignedIn = job == "ems"
    if not isSignedIn then
        stopJob()
    end
end)

AddEventHandler('np-base:playerSessionStarted', function()
    loadModel('s_m_m_paramedic_01')
    loadModel('ambulance')
end)

RegisterNetEvent('nowIsEMS')
AddEventHandler('nowIsEMS', function(cb)
    cb(onJob)
end)

RegisterNetEvent('nowUnemployed')
AddEventHandler('nowUnemployed', function()
    stopJob()
end)

--[[
    -- Type: Function
    -- Name: jobTick
    -- Use: Main loop handling mission states
--]]
local function jobTick()
    if not DoesEntityExist(jobs.vehicle) or not IsVehicleDriveable(jobs.vehicle, false) then
        drawMissionText("The ambulance is ~r~destroyed~w~.", 5000)
        stopJob()
        return
    end

    if jobs.stage == 0 then
        if IsVehicleSeatFree(jobs.vehicle, -1) then
            stopJob()
            return
        end
        if math.random(0, 100) > 75 then
            spawnPatient()
        end
        Citizen.Wait(20000)
    elseif jobs.stage == 1 then
        if DoesEntityExist(jobs.peds[1]) then
            local playerPos = GetEntityCoords(PlayerPedId())
            local pedPos = GetEntityCoords(jobs.peds[1])
            if #(playerPos - pedPos) < 15.0 and IsPedSittingInVehicle(PlayerPedId(), jobs.vehicle) then
                TaskEnterVehicle(jobs.peds[1], jobs.vehicle, -1, 2, 2.0, 1)
                jobs.stage = 2
            end
        else
            jobs.stage = 0
        end
        Citizen.Wait(0)
    elseif jobs.stage == 2 then
        if IsPedSittingInVehicle(jobs.peds[1], jobs.vehicle) then
            beginTransport()
        else
            jobs.stage = 1
        end
        Citizen.Wait(0)
    elseif jobs.stage == 3 then
        local dest = jobs.coords[jobs.destination]
        DrawMarker(27, dest.x, dest.y, dest.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 2.0, 178, 236, 93, 155, false, false, 2, false, nil, nil, false)
        if #(GetEntityCoords(PlayerPedId()) - dest) < 5.0 then
            if jobs.blips[1] and DoesBlipExist(jobs.blips[1]) then
                RemoveBlip(jobs.blips[1])
                jobs.blips[1] = nil
            end
            TaskLeaveVehicle(jobs.peds[1], jobs.vehicle, 0)
            Citizen.Wait(1000)
            ClearPedTasksImmediately(jobs.peds[1])
            DeletePed(jobs.peds[1])
            jobs.peds[1] = nil
            TriggerServerEvent('mission:completed', myPay)
            local util = exports['np-base']:getModule('Util')
            util:MissionText('You gained ~g~$'..myPay..'~w~', 5000)
            drawMissionText('~g~You have delivered the patient!~w~', 5000)
            jobs.stage = 0
            Citizen.Wait(2000)
            drawMissionText('Drive around until you get another ~y~request~w~.', 10000)
        end
        Citizen.Wait(0)
    end
end

-- Main Loop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not onJob and isSignedIn and IsPedSittingInAnyVehicle(PlayerPedId()) then
            local veh = GetVehiclePedIsUsing(PlayerPedId())
            if GetEntityModel(veh) == GetHashKey('ambulance') then
                startJob()
            end
        elseif onJob then
            jobTick()
        end
    end
end)

