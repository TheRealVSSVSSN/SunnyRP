--[[
    -- Type: Client Script
    -- Name: client.lua
    -- Use: Handles NUI interactions for the Gurgle app
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local guiEnabled = false
local hasOpened = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Opens the Gurgle interface and focuses NUI
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function openGui()
    SetPlayerControl(PlayerId(), false, 0)
    guiEnabled = true
    SetNuiFocus(true, true)
    SendNUIMessage({ openSection = 'openGurgle' })
    TriggerEvent('notepad')
    if not hasOpened then
        hasOpened = true
    end
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Closes the Gurgle interface and releases NUI focus
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function closeGui()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    SetNuiFocus(false, false)
    SendNUIMessage({ openSection = 'closeGurgle' })
    guiEnabled = false
    SetPlayerControl(PlayerId(), true, 0)
end

RegisterNUICallback('btnSubmit', function(data, cb)
    TriggerServerEvent('website:new', data.websiteName, data.websiteKeywords, data.websiteDescription)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    closeGui()
    TriggerEvent('enableGurgleText')
    cb('ok')
end)

RegisterNetEvent('Gurgle:close', closeGui)
RegisterNetEvent('Gurgle:open', openGui)

