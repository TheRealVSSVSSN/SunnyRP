local menuOpen = false
local setDate = 0
local spawnAlreadyInit = false

--[[
    -- Type: Function
    -- Name: sendMessage
    -- Use: Sends data to the NUI frame
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
local function sendMessage(data)
    SendNUIMessage(data)
end

--[[
    -- Type: Function
    -- Name: openMenu
    -- Use: Displays the login interface and locks player controls
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
local function openMenu()
    if spawnAlreadyInit then return end

    menuOpen = true
    sendMessage({ open = true })
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    TriggerEvent("resetinhouse")
    TriggerEvent("loading:disableLoading")

    CreateThread(function()
        while menuOpen do
            Wait(0)
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
        end
    end)

    spawnAlreadyInit = true
end

--[[
    -- Type: Function
    -- Name: closeMenu
    -- Use: Hides the login interface and restores player controls
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
local function closeMenu()
    menuOpen = false
    EnableAllControlActions(0)
    TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end

--[[
    -- Type: Function
    -- Name: disconnect
    -- Use: Requests the server to drop the player
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
local function disconnect()
    TriggerServerEvent("np-login:disconnectPlayer")
end

--[[
    -- Type: Function
    -- Name: nuiCallBack
    -- Use: Handles callbacks from the NUI interface
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
local function nuiCallBack(data)
    Wait(60)
    local events = exports["np-base"]:getModule("Events")

    if data.close then closeMenu() end
    if data.disconnect then disconnect() end
    --if data.showcursor or data.showcursor == false then SetNuiFocus(true, data.showcursor) end
    if data.setcursorloc then SetCursorLocation(data.setcursorloc.x, data.setcursorloc.y) end
    
    if data.fetchdata then
        events:Trigger("np-base:loginPlayer", nil, function(payload)
            if type(payload) == "table" and payload.err then
                sendMessage({ err = payload })
                return
            end

            sendMessage({ playerdata = payload })
        end)
        if data.showcursor ~= nil then SetNuiFocus(true, data.showcursor) end
    end

    if data.newchar then
        if not data.chardata then return end

        events:Trigger("np-base:createCharacter", data.chardata, function(created)
            if not created then
                created = {
                    err = true,
                    msg = "There was an error while creating your character, value returned nil or false. Contact an administrator if this persists."
                }

                sendMessage({ err = created })
                return
            end

            if type(created) == "table" and created.err then
                sendMessage({ err = created })
                return
            end

            sendMessage({ createCharacter = created })
        end)
    end

    if data.fetchcharacters then
        events:Trigger("np-base:fetchPlayerCharacters", nil, function(chars)
            if chars.err then
                sendMessage({ err = chars })
                return
            end

            for k, v in ipairs(chars) do
                chars["char" .. k] = v
                chars[k] = nil
            end

            sendMessage({ playercharacters = chars })
        end)
    end

    if data.deletecharacter then
        events:Trigger("np-base:deleteCharacter", data.deletecharacter, function()
            sendMessage({ reload = true })
        end)
    end

    if data.selectcharacter then
        local charId = data.selectcharacter
        events:Trigger("np-base:selectCharacter", charId, function(response)
            if not response.loggedin or not response.chardata then
                sendMessage({ err = { err = true, msg = "There was a problem logging in as that character, if the problem persists, contact an administrator <br/> Cid: " .. tostring(charId) } })
                return
            end

            local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
            LocalPlayer:setCurrentCharacter(response.chardata)
            local cid = LocalPlayer:getCurrentCharacter().id
            TriggerEvent('updatecid', cid)

            sendMessage({ close = true })

            SetPlayerInvincible(PlayerPedId(), true)

            TriggerEvent("np-base:firstSpawn")
            closeMenu()
            Wait(5000)
            TriggerEvent("Relog")
            Wait(1000)
            SetPlayerInvincible(PlayerPedId(), false)
        end)
    end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

RegisterNetEvent("np-base:spawnInitialized")
AddEventHandler("np-base:spawnInitialized", function()
    -- Citizen.Wait(3000)
    openMenu()
end)

--[[
RegisterCommand("kapat", function()
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    local cid = LocalPlayer:getCurrentCharacter().id
    TriggerEvent('updatecid', cid)
    -- TriggerEvent("hotel:createroom")
    -- TriggerEvent("raid_clothes:defaultReset")
    -- DoScreenFadeIn(500)
end)

RegisterCommand("hotel", function()
    TriggerEvent("hotel:createroom")
end)
--]]
RegisterNetEvent("updateTimeReturn")
AddEventHandler("updateTimeReturn", function()
    setDate = "" .. 0 .. ""
    sendMessage({date = setDate})
end)
--[[
RegisterCommand("open", function()
    openMenu()
end)
--]]