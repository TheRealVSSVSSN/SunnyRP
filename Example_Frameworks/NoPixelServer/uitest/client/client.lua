--[[
    -- Type: Client Script
    -- Name: uitest
    -- Use: Manages in-game NUI menu interactions
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]

local guiEnabled = false
local runningFunction = false

local function closeGui()
    SetNuiFocus(false, false)
    guiEnabled = false
    SendNUIMessage({ type = "enableui", enable = false })
    SendNUIMessage({ type = "endOfCurrentMenu", isEnd = false })
end

local function openGui()
    TriggerEvent("stripclub:stressLoss", false)
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "enableui", enable = true })
    guiEnabled = true
end

local function feedGui(name, functionName, buttonType)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "addButton",
        name = name,
        functionname = functionName,
        buttonType = buttonType
    })
end

local function feedGui3(name, functionName)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "addButton3",
        name = name,
        functionname = functionName
    })
end

RegisterNetEvent('sendToGui')
AddEventHandler('sendToGui', function(name, func, buttonType)
    if guiEnabled then
        feedGui(name, func, buttonType)
    else
        openGui()
        Citizen.Wait(70)
        feedGui(name, func, buttonType)
    end
end)

RegisterNUICallback('runfunction', function(data, cb)
    if runningFunction then
        cb('ok')
        return
    end
    runningFunction = true
    if data.functionset == "openSubMenu" then
        TriggerEvent(data.functionset, data.name)
    elseif data.buttonType == "shop" or data.buttonType == "tool" or data.buttonType == "hair" or data.buttonType == "hair2" or data.buttonType == "hairnextprev" then
        TriggerEvent(data.functionset)
        if data.buttonType == "shop" then Citizen.Wait(300) end
    else
        closeGui()
        TriggerEvent(data.functionset)
    end
    Citizen.Wait(750)
    runningFunction = false
    cb('ok')
end)

RegisterNUICallback('escape', function(_, cb)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('left', function(_, cb)
    TriggerEvent("prevBlemishes")
    cb('ok')
end)

RegisterNUICallback('right', function(_, cb)
    TriggerEvent("nextBlemishes")
    cb('ok')
end)

RegisterNUICallback('up', function(_, cb)
    TriggerEvent("dC21")
    cb('ok')
end)

RegisterNUICallback('down', function(_, cb)
    TriggerEvent("dC22")
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 106, true)

            if IsDisabledControlJustReleased(0, 142) then
                SendNUIMessage({ type = "click" })
            end

            if IsControlJustReleased(0, 18) or IsDisabledControlJustReleased(0, 18) then
                SendNUIMessage({ type = "enter" })
            end

            if IsControlJustReleased(0, 172) or IsDisabledControlJustReleased(0, 172) then
                SendNUIMessage({ type = "up" })
            end

            if IsControlJustReleased(0, 173) or IsDisabledControlJustReleased(0, 173) then
                SendNUIMessage({ type = "down" })
            end
        end
        Citizen.Wait(0)
    end
end)

-- Expose functions for compatibility with existing calls
function CloseGui()
    closeGui()
end

function EnableGui()
    openGui()
end

function FeedGui(name, functionName, buttonType)
    feedGui(name, functionName, buttonType)
end

function FeedGui3(name, functionName)
    feedGui3(name, functionName)
end
