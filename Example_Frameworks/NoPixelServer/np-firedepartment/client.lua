--[[
    -- Type: Client Script
    -- Name: np-firedepartment/client.lua
    -- Use: Controls fire department saw interactions and effects
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local holdingSaw = false
local usingSaw = false
local sawModel = "prop_tool_consaw"
local animDict = "weapons@heavy@minigun"
local animName = "idle_2_aim_right_med"
local particleDict = "des_fib_floor"
local particleName = "ent_ray_fbi5a_ramp_metal_imp"
local actionTime = 10
local saw_net = nil

local particles_started = false
local particled_entity_id = nil

local doors = {
    {bone = "door_pside_f", label = "Front Right Door", index = 1},
    {bone = "door_dside_f", label = "Front Left Door", index = 0},
    {bone = "door_pside_r", label = "Back Right Door", index = 3},
    {bone = "door_dside_r", label = "Back Left Door", index = 2}
}

--[[
    -- Type: Function
    -- Name: GetClosestDoorIndex
    -- Use: Returns the index of the closest vehicle door to the player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function GetClosestDoorIndex(vehicle)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    local closestIndex, closestDist
    local doorCount = GetNumberOfVehicleDoors(vehicle)
    local distCheck = doorCount > 4 and 2.0 or 2.7

    for i, door in ipairs(doors) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, door.bone)
        if boneIndex ~= -1 then
            local doorPos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local dist = #(doorPos - pedPos)
            if dist < distCheck and (not closestDist or dist < closestDist) then
                closestIndex = i
                closestDist = dist
            end
        end
    end

    return closestIndex
end

---------------------------------------------------------------------------
-- Toggling Saw --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:ToggleSaw")
AddEventHandler("Saw:ToggleSaw", function()
    local ped = PlayerPedId()
    if not holdingSaw then
        RequestModel(GetHashKey(sawModel))
        while not HasModelLoaded(GetHashKey(sawModel)) do
            Wait(100)
        end

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        local sawspawned = CreateObject(GetHashKey(sawModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, true)
        Wait(1000)
        local netId = ObjToNet(sawspawned)
        SetNetworkIdExistsOnAllMachines(netId, true)
        NetworkSetNetworkIdDynamic(netId, true)
        SetNetworkIdCanMigrate(netId, false)
        AttachEntityToEntity(sawspawned, ped, GetPedBoneIndex(ped, 28422), 0.095, 0.0, 0.0, 270.0, 170.0, 0.0, true, true, false, true, 0, true)
        TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, 50, 0, false, false, false)
        saw_net = netId
        holdingSaw = true
    else
        ClearPedSecondaryTask(ped)
        DetachEntity(NetToObj(saw_net), true, true)
        DeleteEntity(NetToObj(saw_net))
        saw_net = nil
        holdingSaw = false
        usingSaw = false
    end
end)

---------------------------------------------------------------------------
-- Start Particles --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:StartParticles")
AddEventHandler("Saw:StartParticles", function(sawid)
    local entity = NetToObj(sawid)

    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(100)
    end

    UseParticleFxAssetNextCall(particleDict)
    StartParticleFxNonLoopedOnEntity(particleName, entity, -0.715, 0.005, 0.0, 0.0, 25.0, 25.0, 0.75, 0.0, 0.0, 0.0)
end)

---------------------------------------------------------------------------
-- Stop Particles --
---------------------------------------------------------------------------
RegisterNetEvent("Saw:StopParticles")
AddEventHandler("Saw:StopParticles", function(sawid)
    local entity = NetToObj(sawid)
    RemoveParticleFxFromEntity(entity)
end)

---------------------------------------------------------------------------
-- Get Vehicle Closest Door --
---------------------------------------------------------------------------
CreateThread(function()
    while true do
        if holdingSaw then
            local vehicle = GetVehicleInFront()
            if vehicle ~= 0 then
                local closest = GetClosestDoorIndex(vehicle)
                if closest and not IsVehicleDoorDamaged(vehicle, doors[closest].index) then
                    local drawCoord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doors[closest].bone))
                    DrawText3D(drawCoord.x, drawCoord.y, drawCoord.z, "Press E to cut " .. doors[closest].label)
                    if IsControlJustPressed(0, 38) and not usingSaw then
                        Timer(vehicle, closest)
                    end
                end
            end
        end
        Wait(0)
    end
end)

local stuckInCar = false

RegisterNetEvent("firedepartment:forceStop")
AddEventHandler("firedepartment:forceStop", function()
    holdingSaw = false
    usingSaw = false
    local ped = PlayerPedId()
    ClearPedSecondaryTask(ped)
    if saw_net ~= nil then
        DetachEntity(NetToObj(saw_net), true, true)
        DeleteEntity(NetToObj(saw_net))
        saw_net = nil
    end
end)

RegisterNetEvent("firedepartment:stuckincar")
AddEventHandler("firedepartment:stuckincar", function(isStuck)
    stuckInCar = isStuck
    TriggerEvent("DoLongHudText","You have had a bad accident, the door's are broken and your legs appear to be stuck.",1)
    TriggerEvent("breaklegs")
    TriggerEvent("stuckincar", true)
end)

CreateThread(function()
    while true do
        Wait(50)

        local ped = PlayerPedId()
        if stuckInCar then
            Wait(900)
        else
            if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                Wait(100)
                if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                    local veh = GetVehiclePedIsIn(ped, false)
                    TaskLeaveVehicle(ped, veh, 256)
                end
            end
        end
    end
end)

local lastCar = nil

CreateThread(function()
    while true do
        Wait(1)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if not IsPedInVehicle(ped, vehicle, false) and stuckInCar then
            stuckInCar = false
            TriggerEvent("stuckincar", false)
        end

        if stuckInCar and IsPedInVehicle(ped, vehicle, false) then
            local closest = GetClosestDoorIndex(vehicle)
            if closest then
                if not IsVehicleDoorDamaged(vehicle, doors[closest].index) then
                    lastCar = vehicle
                    SetVehicleDoorsLocked(vehicle, 4)
                else
                    SetVehicleDoorsLocked(vehicle, 0)
                    if lastCar then SetVehicleDoorsLocked(lastCar, 0) end
                end
            end
        else
            Wait(300)
        end
    end
end)


CreateThread(function()
    while true do
        if usingSaw then
            TriggerServerEvent("Saw:SyncStartParticles", saw_net)
        end
        Wait(100)
    end
end)

RegisterNetEvent("firedepartment:removeDoor")
AddEventHandler("firedepartment:removeDoor", function(vehNetId, index)
    while not NetworkDoesEntityExistWithNetworkId(vehNetId) do
        Wait(500)
    end
    local currentVeh = NetworkGetEntityFromNetworkId(vehNetId)
    SetVehicleDoorBroken(currentVeh, index, false)
end)

--[[
    -- Type: Function
    -- Name: Timer
    -- Use: Handles the timed cutting action for vehicle doors
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Timer(vehicle, index)
    CreateThread(function()
        Notification("~r~You are cutting off the door. Please wait...")
        usingSaw = true
        local time = actionTime
        while time > 0 do
            if not holdingSaw or GetVehicleInFront() ~= vehicle then
                usingSaw = false
                TriggerServerEvent("Saw:SyncStopParticles", saw_net)
                Notification("~r~Cutting has been canceled.")
                return
            end
            Wait(1000)
            time = time - 1
        end
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        SetVehicleDoorBroken(vehicle, doors[index].index, false)
        TriggerServerEvent("Saw:SyncDoorFall", netId, doors[index].index)
        TriggerServerEvent("Saw:SyncStopParticles", saw_net)
        Notification("~g~The vehicles door has been cut off.")
        usingSaw = false
    end)
end

--[[
    -- Type: Function
    -- Name: GetVehicleInFront
    -- Use: Returns the vehicle directly in front of the player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function GetVehicleInFront()
    local ped = PlayerPedId()
    local plyCoords = GetEntityCoords(ped)
    local plyOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.0)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 0.3, 10, ped, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

--[[
    -- Type: Function
    -- Name: DrawText3D
    -- Use: Renders 3D text at the specified world coordinates
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: Notification
    -- Use: Displays a simple notification on the player's screen
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Notification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, true)
end

