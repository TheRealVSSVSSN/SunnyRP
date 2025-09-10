-- Menu state
local showMenu = false

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local MAX_MENU_ITEMS = 7

--[[
    -- Type: Function
    -- Name: buildSubMenus
    -- Use: Generates nested radial menu pages when submenu count exceeds MAX_MENU_ITEMS
    -- Created: 2024-06-14
    -- By: VSSVSSN
--]]
local function buildSubMenus(menuConfig)
    local elements, target = {}, nil
    target = elements

    for i, subId in ipairs(menuConfig.subMenus) do
        local subMenu = newSubMenus[subId]
        subMenu.id = subId
        subMenu.enableMenu = nil
        target[#target + 1] = subMenu

        if i % MAX_MENU_ITEMS == 0 and i < #menuConfig.subMenus then
            local nextContainer = {}
            target[MAX_MENU_ITEMS + 1] = {
                id = "_more",
                title = "More",
                icon = "#more",
                items = nextContainer
            }
            target = nextContainer
        end
    end

    return elements
end

-- Main thread
CreateThread(function()
    local keyBind = "F1"
    while true do
        Wait(0)
        if IsControlJustPressed(0, keybindControls[keyBind]) and GetLastInputMethod(2) then
            showMenu = not showMenu

            if showMenu then
                local enabledMenus = {}
                for _, menuConfig in ipairs(rootMenuConfig) do
                    if menuConfig:enableMenu() then
                        local hasSubMenus = menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0
                        local dataElements = hasSubMenus and buildSubMenus(menuConfig) or nil

                        enabledMenus[#enabledMenus + 1] = {
                            id = menuConfig.id,
                            title = menuConfig.displayName,
                            functionName = menuConfig.functionName,
                            icon = menuConfig.icon,
                            items = dataElements
                        }
                    end
                end

                SendNUIMessage({
                    state = "show",
                    resourceName = GetCurrentResourceName(),
                    data = enabledMenus,
                    menuKeyBind = keyBind
                })

                SetCursorLocation(0.5, 0.5)
                SetCustomNuiFocus(true, true)
                PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            else
                SetCustomNuiFocus(false, false)
                SendNUIMessage({ state = 'destroy' })
            end
        end

        if showMenu then
            DisableControlAction(0, keybindControls[keyBind], true)
        end
    end
end)
-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetCustomNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('triggerAction', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetCustomNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Run command
    --ExecuteCommand(data.action)
    TriggerEvent(data.action, data.parameters)

    -- Send ACK to callback function
    cb('ok')
end)

RegisterNetEvent("menu:menuexit")
AddEventHandler("menu:menuexit", function()
    showMenu = false
    SetCustomNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
end)
--[[
    -- Type: Function
    -- Name: SetCustomNuiFocus
    -- Use: Handles focus for NUI and keeps input when necessary
    -- Created: 2024-06-14
    -- By: VSSVSSN
--]]
local hasNuiFocus = false
function SetCustomNuiFocus(hasKeyboard, hasMouse)
    hasNuiFocus = hasKeyboard or hasMouse

    SetNuiFocus(hasKeyboard, hasMouse)
    SetNuiFocusKeepInput(hasNuiFocus)

    TriggerEvent("np:voice:focus:set", hasNuiFocus, hasKeyboard, hasMouse)
end
