local guiEnabled, hasNuiFocus = false, false

--[[
    -- Type: Function
    -- Name: setCustomNuiFocus
    -- Use: Handles NUI focus and voice settings
    -- Created: 2024-11-14
    -- By: VSSVSSN
--]]
local function setCustomNuiFocus(hasKeyboard, hasMouse)
    hasNuiFocus = hasKeyboard or hasMouse
    SetNuiFocus(hasKeyboard, hasMouse)
    SetNuiFocusKeepInput(hasNuiFocus)
    TriggerEvent("np:voice:focus:set", hasNuiFocus, hasKeyboard, hasMouse)
end

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Opens the specified MDT section
    -- Created: 2024-11-14
    -- By: VSSVSSN
--]]
local function openGui(section)
    guiEnabled = true
    setCustomNuiFocus(true, true)
    local message = {}

    if section == 'warrants' then
        message.openWarrants = true
    elseif section == 'doctors' then
        message.openDoctors = true
    elseif section == 'publicrecords' then
        message.openSection = 'publicrecords'
    end

    SendNUIMessage(message)
    TriggerEvent('animation:tablet', true)
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Closes MDT interface and resets focus
    -- Created: 2024-11-14
    -- By: VSSVSSN
--]]
local function closeGui()
    setCustomNuiFocus(false, false)
    guiEnabled = false
    TriggerEvent('animation:tablet', false)
    Wait(250)
    ClearPedTasks(PlayerPedId())
end

--[[ Event Registrations ]]--
RegisterNetEvent("phone:publicrecords")
AddEventHandler("phone:publicrecords", function()
    openGui('publicrecords')
end)

RegisterNetEvent('warrantsGui')
AddEventHandler('warrantsGui', function()
    openGui('warrants')
end)

RegisterNetEvent('doctorGui')
AddEventHandler('doctorGui', function()
    openGui('doctors')
end)

RegisterNetEvent('mdt:close')
AddEventHandler('mdt:close', function()
    closeGui()
    SendNUIMessage({ closeGUI = true })
end)

--[[ NUI Callback ]]--
RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)
