--[[
    -- Type: Script
    -- Name: koil-debug
    -- Use: Provides on-demand debugging utilities for nearby entities
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local debugEnabled = false
local freezeEntities = false
local lowGravity = false

--[[
    -- Type: Event
    -- Name: hud:enabledebug
    -- Use: Toggles entity debugging information on the client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('hud:enabledebug', function()
    debugEnabled = not debugEnabled
    print(debugEnabled and 'Debug: Enabled' or 'Debug: Disabled')
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

--[[
    -- Type: Function
    -- Name: enumerateEntities
    -- Use: Iterates native entity collections using coroutines
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function enumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function EnumerateVehicles()
    return enumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function EnumerateObjects()
    return enumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function EnumeratePeds()
    return enumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

--[[
    -- Type: Function
    -- Name: drawText
    -- Use: Draws text on-screen at a fixed position
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drawText(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

--[[
    -- Type: Function
    -- Name: drawText3D
    -- Use: Renders 3D text at the given world coordinates
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then
        return
    end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: canEntityBeUsed
    -- Use: Validates an entity for debug rendering
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function canEntityBeUsed(entity)
    if not entity or entity == PlayerPedId() then
        return false
    end

    return DoesEntityExist(entity)
end

--[[
    -- Type: Function
    -- Name: getClosestVehicle
    -- Use: Locates and annotates the nearest vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closest, closestDist

    for veh in EnumerateVehicles() do
        local pos = GetEntityCoords(veh)
        local dist = #(playerCoords - pos)

        if canEntityBeUsed(veh) and dist < 30.0 and (not closestDist or dist < closestDist) then
            closest, closestDist = veh, dist

            local label = ('Veh: %s Model: %s'):format(veh, GetEntityModel(veh))
            if IsEntityTouchingEntity(playerPed, veh) then
                label = label .. ' IN CONTACT'
            end

            drawText3D(pos.x, pos.y, pos.z + 1.0, label)
            FreezeEntityPosition(veh, freezeEntities)

            if lowGravity then
                SetEntityCoords(veh, pos.x, pos.y, pos.z + 5.0, false, false, false, true)
            end
        end
    end

    return closest
end

--[[
    -- Type: Function
    -- Name: getClosestObject
    -- Use: Locates and annotates the nearest object
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getClosestObject()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closest, closestDist

    for obj in EnumerateObjects() do
        local pos = GetEntityCoords(obj)
        local dist = #(playerCoords - pos)

        if dist < 10.0 and (not closestDist or dist < closestDist) then
            closest, closestDist = obj, dist

            local label = ('Obj: %s Model: %s'):format(obj, GetEntityModel(obj))
            if IsEntityTouchingEntity(playerPed, obj) then
                label = label .. ' IN CONTACT'
            end

            drawText3D(pos.x, pos.y, pos.z + 1.0, label)
            FreezeEntityPosition(obj, freezeEntities)

            if lowGravity then
                SetEntityCoords(obj, pos.x, pos.y, pos.z + 0.1, false, false, false, true)
            end
        end
    end

    return closest
end

--[[
    -- Type: Function
    -- Name: getClosestPed
    -- Use: Locates and annotates the nearest ped
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getClosestPed()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closest, closestDist

    for ped in EnumeratePeds() do
        local pos = GetEntityCoords(ped)
        local dist = #(playerCoords - pos)

        if canEntityBeUsed(ped) and dist < 30.0 and (not closestDist or dist < closestDist) then
            closest, closestDist = ped, dist

            local label = ('Ped: %s Model: %s Relationship HASH: %s'):format(
                ped,
                GetEntityModel(ped),
                GetPedRelationshipGroupHash(ped)
            )
            if IsEntityTouchingEntity(playerPed, ped) then
                label = label .. ' IN CONTACT'
            end

            drawText3D(pos.x, pos.y, pos.z, label)
            FreezeEntityPosition(ped, freezeEntities)

            if lowGravity then
                SetPedToRagdoll(ped, 511, 511, 0, false, false, false)
                SetEntityCoords(ped, pos.x, pos.y, pos.z + 0.1, false, false, false, true)
            end
        end
    end

    return closest
end

--[[
    -- Type: Thread
    -- Name: debugLoop
    -- Use: Renders debug information while enabled
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        if debugEnabled then
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)

            local forPos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -1.0, 0.0)
            local leftPos = GetOffsetFromEntityInWorldCoords(playerPed, 1.0, 0.0, 0.0)
            local rightPos = GetOffsetFromEntityInWorldCoords(playerPed, -1.0, 0.0, 0.0)

            local forPos2 = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -2.0, 0.0)
            local leftPos2 = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.0)
            local rightPos2 = GetOffsetFromEntityInWorldCoords(playerPed, -2.0, 0.0, 0.0)

            local x, y, z = table.unpack(pos)
            local streetHash = GetStreetNameAtCoord(x, y, z)
            local streetName = GetStreetNameFromHashKey(streetHash)

            drawText(0.8, 0.50, 0.4, 0.4, 0.30, 'Heading: ' .. GetEntityHeading(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.52, 0.4, 0.4, 0.30, 'Coords: ' .. pos, 55, 155, 55, 255)
            drawText(0.8, 0.54, 0.4, 0.4, 0.30, 'Attached Ent: ' .. GetEntityAttachedTo(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.56, 0.4, 0.4, 0.30, 'Health: ' .. GetEntityHealth(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.58, 0.4, 0.4, 0.30, 'H a G: ' .. GetEntityHeightAboveGround(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.60, 0.4, 0.4, 0.30, 'Model: ' .. GetEntityModel(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.62, 0.4, 0.4, 0.30, 'Speed: ' .. GetEntitySpeed(playerPed), 55, 155, 55, 255)
            drawText(0.8, 0.64, 0.4, 0.4, 0.30, 'Frame Time: ' .. GetFrameTime(), 55, 155, 55, 255)
            drawText(0.8, 0.66, 0.4, 0.4, 0.30, 'Street: ' .. streetName, 55, 155, 55, 255)

            DrawLine(pos.x, pos.y, pos.z, forPos.x, forPos.y, forPos.z, 255, 0, 0, 115)
            DrawLine(pos.x, pos.y, pos.z, backPos.x, backPos.y, backPos.z, 255, 0, 0, 115)

            DrawLine(pos.x, pos.y, pos.z, leftPos.x, leftPos.y, leftPos.z, 255, 255, 0, 115)
            DrawLine(pos.x, pos.y, pos.z, rightPos.x, rightPos.y, rightPos.z, 255, 255, 0, 115)

            DrawLine(forPos.x, forPos.y, forPos.z, forPos2.x, forPos2.y, forPos2.z, 255, 0, 255, 115)
            DrawLine(backPos.x, backPos.y, backPos.z, backPos2.x, backPos2.y, backPos2.z, 255, 0, 255, 115)

            DrawLine(leftPos.x, leftPos.y, leftPos.z, leftPos2.x, leftPos2.y, leftPos2.z, 255, 255, 255, 115)
            DrawLine(rightPos.x, rightPos.y, rightPos.z, rightPos2.x, rightPos2.y, rightPos2.z, 255, 255, 255, 115)

            getClosestPed()
            getClosestVehicle()
            getClosestObject()

            if IsControlJustReleased(0, 38) then
                freezeEntities = not freezeEntities
                TriggerEvent('DoShortHudText', freezeEntities and 'Freeze Enabled' or 'Freeze Disabled', 3)
            end

            if IsControlJustReleased(0, 47) then
                lowGravity = not lowGravity
                TriggerEvent('DoShortHudText', lowGravity and 'Low Grav Enabled' or 'Low Grav Disabled', 3)
            end

            Wait(0)
        else
            Wait(1000)
        end
    end
end)

