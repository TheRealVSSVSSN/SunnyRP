local roles = {
    isCop = false,
    isDoc = false,
    isMedic = false,
    isTher = false,
    isMech = false,
    isPDM = false,
    isJudge = false
}

local hasSteamIdKeys = false
local cidDoctorsCopAccess = { 1 }

--[[
    -- Type: Function
    -- Name: DrawText3D
    -- Use: Renders 3D text at a world coordinate
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Event
    -- Name: np-jobmanager:playerBecameJob
    -- Use: Updates role flags when a player's job changes
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-jobmanager:playerBecameJob", function(job)
    roles.isCop = job == "police"
    roles.isMedic = job == "ems"
    roles.isDoc = job == "doctor"
    roles.isTher = job == "therapist"
    roles.isMech = job == "mechanic"
    roles.isPDM = job == "pdm"
    if roles.isMedic or roles.isDoc or roles.isTher then
        local cid = exports["isPed"]:isPed("cid")
        for _, id in ipairs(cidDoctorsCopAccess) do
            if cid == id then
                roles.isCop = true
                break
            end
        end
    end
end)

--[[
    -- Type: Events
    -- Name: isJudge / isJudgeOff
    -- Use: Toggles judge flag based on external events
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent("isJudge", function() roles.isJudge = true end)
RegisterNetEvent("isJudgeOff", function() roles.isJudge = false end)

--[[
    -- Type: Event
    -- Name: doors:HasKeys
    -- Use: Grants or revokes special key access based on server response
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent("doors:HasKeys", function(state)
    hasSteamIdKeys = state
end)

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Ensures an animation dictionary is loaded
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

--[[
    -- Type: Event
    -- Name: dooranim
    -- Use: Plays a keycard swipe animation
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('dooranim', function()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(850)
    ClearPedTasks(PlayerPedId())
end)

--[[
    -- Type: Function
    -- Name: addDoorsToSystem
    -- Use: Registers doors with the DoorSystem and sets initial lock states
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
local function addDoorsToSystem()
    for id, door in pairs(NPX.DoorCoords) do
        local model = type(door.doorType) == 'number' and door.doorType or joaat(door.doorType)
        if not IsDoorRegisteredWithSystem(id) then
            AddDoorToSystem(id, model, door.x, door.y, door.z, false, false, false)
        end
        DoorSystemSetDoorState(id, door.lock, false, true)
    end
end

--[[
    -- Type: Event
    -- Name: np-doors:sync
    -- Use: Receives the latest door table from the server
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-doors:sync', function(doorCoords)
    NPX.DoorCoords = doorCoords
    addDoorsToSystem()
end)

--[[
    -- Type: Event
    -- Name: NPX:Door:alterState
    -- Use: Updates a single door's state on the client
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('NPX:Door:alterState', function(id, state)
    if NPX.DoorCoords[id] then
        NPX.DoorCoords[id].lock = state
        DoorSystemSetDoorState(id, state, false, true)
    end
end)

--[[
    -- Type: Function
    -- Name: OpenCheck
    -- Use: Determines whether the player can interact with the specified door
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
local function OpenCheck(curClosestNum)
    local gangType = exports["isPed"]:isPed("gang")
    local job = exports["np-base"]:getModule("LocalPlayer"):getVar("job")

    if (roles.isCop or roles.isJudge or job == "district attorney" or hasSteamIdKeys) and (curClosestNum == 146 or curClosestNum == 147) then
        return false
    end

    if (roles.isCop or roles.isJudge or roles.isMech or hasSteamIdKeys) and (curClosestNum == 192 or curClosestNum == 193) then
        return true
    end

    if (roles.isCop or roles.isJudge or roles.isPDM or hasSteamIdKeys) and (curClosestNum == 270 or curClosestNum == 271) then
        return true
    end

    if (roles.isCop or roles.isJudge or hasSteamIdKeys) and (curClosestNum == 280 or curClosestNum == 281 or curClosestNum == 282 or curClosestNum == 283 or curClosestNum == 284 or curClosestNum == 285) then
        return true
    end

    if curClosestNum ~= 0 and (roles.isCop or roles.isJudge or job == "district attorney" or hasSteamIdKeys) then
        return true
    end

    if (curClosestNum == 146 or curClosestNum == 147 or curClosestNum == 157 or curClosestNum == 158) and gangType == 1 then
        return true
    end

    local cid = exports["isPed"]:isPed("cid")
    if (roles.isDoc or roles.isMedic or roles.isTher) and ((curClosestNum >= 251 and curClosestNum <= 264) or curClosestNum == 275 or curClosestNum == 276 or curClosestNum == 277) then
        return true
    end

    local foundValid = false
    for k, v in pairs(NPX.rankCheck) do
        local rank = exports["isPed"]:GroupRank(k)
        for o, p in pairs(v) do
            if rank >= o and not foundValid then
                if p.between then
                    for i = 1, #p.between do
                        if curClosestNum >= p.between[i][1] and curClosestNum <= p.between[i][2] then
                            foundValid = true
                        end
                    end
                end
                if p.single then
                    for i = 1, #p.single do
                        if curClosestNum == p.single[i] then
                            foundValid = true
                        end
                    end
                end
            end
        end
    end

    return foundValid
end

Controlkey = { ["generalUse"] = {38, "E"} }
RegisterNetEvent('event:control:update', function(tbl)
    Controlkey["generalUse"] = tbl["generalUse"]
end)

--[[
    -- Type: Thread
    -- Name: doorInteraction
    -- Use: Handles proximity checks and player interaction with doors
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local closestId, closestDoor, closestDist = nil, nil, 1.5
        for id, door in pairs(NPX.DoorCoords) do
            local dist = #(coords - vector3(door.x, door.y, door.z))
            if dist < closestDist then
                closestDist = dist
                closestId = id
                closestDoor = door
            end
        end
        if closestDoor then
            local prompt = closestDoor.lock == 1 and '[E] Unlock' or '[E] Lock'
            DrawText3D(closestDoor.x, closestDoor.y, closestDoor.z, prompt)
            if IsControlJustReleased(0, Controlkey["generalUse"][1]) then
                if OpenCheck(closestId) then
                    TriggerEvent('dooranim')
                    TriggerServerEvent('np-doors:alterlockstate', closestId)
                else
                    TriggerEvent('DoLongHudText', 'Locked', 2)
                end
            end
        else
            Wait(400)
        end
        Wait(0)
    end
end)

--[[
    -- Type: Thread
    -- Name: initialSync
    -- Use: Requests door states from the server when the client loads
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
CreateThread(function()
    Wait(1000)
    TriggerServerEvent('np-doors:requestlatest')
end)
