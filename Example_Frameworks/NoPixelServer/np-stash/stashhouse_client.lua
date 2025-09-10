local stashes = {}
local currentStash = nil
local isInStash = false
local guiOpen = false
local warehouse

--[[
    -- Type: Event
    -- Name: np-stash:setInitialState
    -- Use: Receives stash configuration from the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
RegisterNetEvent('np-stash:setInitialState', function(data)
    stashes = data or {}
end)

CreateThread(function()
    TriggerServerEvent('np-stash:fetchInitialState')
end)

--[[
    -- Type: Function
    -- Name: getNearestStash
    -- Use: Finds the closest stash to the player
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
local function getNearestStash()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local closest, closestDist
    for _, stash in pairs(stashes) do
        local dist = #(stash.StashEntry - pos)
        if not closestDist or dist < closestDist then
            closest = stash
            closestDist = dist
        end
    end
    return closest, closestDist or 0.0
end

RegisterCommand('getnearstash', function()
    local stash, dist = getNearestStash()
    if stash and dist <= stash.distance then
        TriggerEvent('OpenCodeEntryGUI', {stash.RequiredPin}, stash.StashEntry)
    end
end, false)

RegisterNetEvent('np-stash:getnearstash', function()
    local stash, dist = getNearestStash()
    if stash and dist <= stash.distance then
        secureWarehouseEnter(stash)
    end
end)

--[[
    -- Type: Function
    -- Name: openCodeGui
    -- Use: Displays the code entry UI
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
local function openCodeGui(requiredPin, coords)
    guiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ openPinPad = true, requiredPins = requiredPin, coords = coords })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Hides the code entry UI
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
local function closeGui()
    guiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ openPinPad = false })
end

AddEventHandler('OpenCodeEntryGUI', openCodeGui)

-- NUI callbacks
RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('failure', function(_, cb)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('complete', function(_, cb)
    closeGui()
    cb('ok')
    TriggerEvent('np-stash:getnearstash')
end)

RegisterCommand('fixblack', function()
    DoScreenFadeIn(1000)
end)

--[[
    -- Type: Function
    -- Name: secureWarehouseEnter
    -- Use: Teleports the player into the stash interior
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
function secureWarehouseEnter(stash)
    local model = joaat('stashhouse1_shell')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    warehouse = CreateObject(model, stash.StashEntry.x, stash.StashEntry.y, -72.61, false, false, false)
    FreezeEntityPosition(warehouse, true)

    currentStash = stash
    isInStash = true

    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsUsing(ped)
        DoScreenFadeOut(1000)
        Wait(1000)
        SetEntityHeading(ped, 88.27)
        SetEntityCoordsNoOffset(vehicle, stash.StashEntry.x + 18.0, stash.StashEntry.y - 0.5, -53.0, false, false, false)
        Wait(1000)
        DoScreenFadeIn(1000)
    else
        DoScreenFadeOut(1000)
        Wait(1000)
        SetEntityCoords(ped, stash.StashEntry.x + 20.0, stash.StashEntry.y - 0.5, -53.0, false, false, false)
        Wait(1000)
        DoScreenFadeIn(1000)
    end
end

CreateThread(function()
    while true do
        Wait(4)
        if isInStash and currentStash then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            local openPos = vector3(currentStash.StashEntry.x - 19.13, currentStash.StashEntry.y + 1.66, -53.0)
            if #(pos - openPos) < 5.0 then
                DrawText3Ds(openPos.x, openPos.y, openPos.z, '~g~E~w~ - open stash')
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('server-inventory-open', '1', 'StashHouse-' .. currentStash.ID)
                end
            end

            local exitPos = vector3(currentStash.StashEntry.x + 17.95, currentStash.StashEntry.y + 1.0, -53.0)
            if #(pos - exitPos) < 5.0 then
                DrawText3Ds(currentStash.StashEntry.x + 20.0, currentStash.StashEntry.y - 0.5, -53.0, '~g~E~w~ - leave stash')
                if IsControlJustReleased(0, 38) then
                    if IsPedInAnyVehicle(ped) then
                        local vehicle = GetVehiclePedIsUsing(ped)
                        DoScreenFadeOut(1000)
                        Wait(1000)
                        SetEntityCoordsNoOffset(vehicle, currentStash.StashEntry.x, currentStash.StashEntry.y, currentStash.StashEntry.z, false, false, false)
                        Wait(1000)
                        DoScreenFadeIn(1000)
                    else
                        DoScreenFadeOut(1000)
                        Wait(1000)
                        SetEntityCoords(ped, currentStash.StashEntry.x, currentStash.StashEntry.y, currentStash.StashEntry.z, false, false, false)
                        secureWarehouseLeave()
                        Wait(1000)
                        DoScreenFadeIn(1000)
                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

--[[
    -- Type: Function
    -- Name: secureWarehouseLeave
    -- Use: Cleans up after leaving the stash interior
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
function secureWarehouseLeave()
    isInStash = false
    if warehouse then
        DeleteObject(warehouse)
        FreezeEntityPosition(warehouse, false)
        warehouse = nil
    end
    currentStash = nil
end

--[[
    -- Type: Function
    -- Name: DrawText3Ds
    -- Use: Draws 3D text in the game world
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
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

RegisterCommand('stashadd', function(_, args)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('stashesaddtoconfig', coords, args[1], args[2], args[3])
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/stashadd', 'Create a stash', {
        { name = 'pin', help = 'Pin Code' },
        { name = 'id', help = 'Stash ID' },
        { name = 'distance', help = 'Distance to click open keypad' }
    })
end)

RegisterKeyMapping('getnearstash', 'Enter nearby stash', 'keyboard', 'e')

