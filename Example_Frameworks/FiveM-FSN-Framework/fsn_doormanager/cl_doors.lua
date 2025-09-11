local doors = {}
local hasKeys = false

RegisterNetEvent('fsn_doormanager:syncDoors', function(tbl)
    doors = tbl or {}
end)

RegisterNetEvent('fsn_police:init', function(policeLevel)
    hasKeys = policeLevel > 0
    TriggerServerEvent('fsn_doormanager:requestDoors')
end)

RegisterNetEvent('fsn_police:update', function(tbl)
    hasKeys = false
    local myId = GetPlayerServerId(PlayerId())
    for _, id in pairs(tbl) do
        if id == myId then
            hasKeys = true
            break
        end
    end
end)

TriggerServerEvent('fsn_doormanager:requestDoors')

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Loads an animation dictionary
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local locking = false
local lockingId = 0
local lockingStart = 0

--[[
    -- Type: Function
    -- Name: toggleLock
    -- Use: Handles the lock/unlock animation and trigger
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function toggleLock(id)
    locking = true
    lockingId = id
    lockingStart = GetGameTimer()
    loadAnimDict('gestures@f@standing@casual')
    TaskPlayAnim(PlayerPedId(), 'gestures@f@standing@casual', 'gesture_hand_down', 8.0, 1.0, 3, 2, 0, false, false, false)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, 'door-lock', 0.1)
end

--[[
    -- Type: Function
    -- Name: isLookingAt
    -- Use: Checks if the player is facing a door
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isLookingAt(id)
    local door = doors[id]
    if not door or door.lookingat == false then return true end
    local ped = PlayerPedId()
    local forwardPos = GetEntityCoords(ped) + GetEntityForwardVector(ped)
    return #(vector3(door.disp.x, door.disp.y, door.disp.z) - forwardPos) < 1.0
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        if locking then
            local d = doors[lockingId]
            if d then
                Util.DrawText3D(d.disp.x, d.disp.y, d.disp.z, 'Toggling..', {255, 255, 255, 200}, 0.2)
            end
            if lockingStart + 800 < GetGameTimer() then
                TriggerServerEvent('fsn_doormanager:toggleDoor', lockingId)
                locking = false
                lockingId = 0
                lockingStart = 0
            end
        else
            for id, door in pairs(doors) do
                local doorPos = vector3(door.disp.x, door.disp.y, door.disp.z)
                local dist = #(pCoords - doorPos)
                if dist < 20 then
                    local entities = {}
                    for idx, ent in ipairs(door.ents) do
                        entities[idx] = GetClosestObjectOfType(ent.x, ent.y, ent.z, 1.0, ent.mdl, false, false, false)
                    end
                    local missingEntity = false
                    for _, ent in pairs(entities) do
                        if not ent then
                            missingEntity = true
                            break
                        end
                    end
                    if missingEntity then
                        Util.DrawText3D(doorPos.x, doorPos.y, doorPos.z, ('ERR: Missing door (%s)'):format(id), {255, 0, 0, 255}, 0.2)
                    else
                        for _, ent in pairs(entities) do
                            FreezeEntityPosition(ent, door.locked)
                        end
                        if dist < door.lockdist then
                            if hasKeys and isLookingAt(id) then
                                local text = door.locked and '[E] ~g~UNLOCK' or '[E] ~r~LOCK'
                                Util.DrawText3D(doorPos.x, doorPos.y, doorPos.z, text, {255, 255, 255, 200}, 0.2)
                                if IsControlJustPressed(0, 38) then
                                    toggleLock(id)
                                end
                            elseif dist < 2 then
                                local status = door.locked and '~r~LOCKED' or '~g~UNLOCKED'
                                Util.DrawText3D(doorPos.x, doorPos.y, doorPos.z, status, {255, 255, 255, 200}, 0.2)
                            end
                        end
                    end
                end
            end
        end
    end
end)

--[[
    -- Type: Function
    -- Name: IsDoorLocked
    -- Use: Export to check door lock state
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function IsDoorLocked(id)
    if doors[id] then
        return doors[id].locked
    end
    return true
end

