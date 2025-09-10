--[[
    -- Type: Client Script
    -- Name: weashop.lua
    -- Use: Handles gang weapon shop interaction and UI
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

local state = {
    open = false,
    level = 'category', -- 'category' or 'item'
    category = 1,
    index = 1
}

local blip = nil
local showing = false

--[[
    -- Type: Function
    -- Name: drawText
    -- Use: Renders 2D text on screen
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function drawText(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

--[[
    -- Type: Function
    -- Name: openMenu
    -- Use: Opens the weapon shop menu
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function openMenu()
    state.open = true
    state.level = 'category'
    state.category = 1
    state.index = 1
end

--[[
    -- Type: Function
    -- Name: closeMenu
    -- Use: Closes the weapon shop menu
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function closeMenu()
    state.open = false
end

--[[
    -- Type: Function
    -- Name: purchaseCurrentItem
    -- Use: Triggers server event to purchase the selected weapon
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function purchaseCurrentItem()
    local category = Config.Categories[state.category]
    local item = category.items[state.index]
    if item then
        TriggerServerEvent('np-gangweapons:purchaseWeapon', item.weapon)
    end
end

--[[
    -- Type: Function
    -- Name: handleInput
    -- Use: Handles menu navigation input
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function handleInput()
    if IsControlJustPressed(0, 188) then -- up
        state.index = state.index - 1
    elseif IsControlJustPressed(0, 187) then -- down
        state.index = state.index + 1
    elseif IsControlJustPressed(0, 38) then -- select
        if state.level == 'category' then
            state.level = 'item'
            state.category = state.index
            state.index = 1
        else
            purchaseCurrentItem()
        end
    elseif IsControlJustPressed(0, 202) then -- back
        if state.level == 'item' then
            state.level = 'category'
            state.index = state.category
        else
            closeMenu()
        end
    end

    local max = state.level == 'category' and #Config.Categories or #Config.Categories[state.category].items
    if state.index < 1 then state.index = max end
    if state.index > max then state.index = 1 end
end

--[[
    -- Type: Function
    -- Name: renderMenu
    -- Use: Draws the current menu to screen
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function renderMenu()
    local items, title
    if state.level == 'category' then
        items = Config.Categories
        title = 'Weapon Categories'
    else
        items = Config.Categories[state.category].items
        title = Config.Categories[state.category].label
    end

    drawText(title, 0.5, 0.35, 0.6)

    for i, item in ipairs(items) do
        local y = 0.40 + (i * 0.03)
        local label = state.level == 'category' and item.label or string.format('%s - $%s', item.label, item.price)
        if i == state.index then
            drawText('> '..label..' <', 0.5, y, 0.45)
        else
            drawText(label, 0.5, y, 0.4)
        end
    end
end

--[[
    -- Type: Function
    -- Name: ShowWeashopBlips
    -- Use: Exported function to toggle weapon shop blip and interaction
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
function ShowWeashopBlips(toggle)
    showing = toggle
    if toggle then
        if not blip then
            blip = AddBlipForCoord(Config.Shop.location.x, Config.Shop.location.y, Config.Shop.location.z)
            SetBlipSprite(blip, 110)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 2)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Gang Weapons')
            EndTextCommandSetBlipName(blip)
        end
    elseif blip then
        RemoveBlip(blip)
        blip = nil
    end
end

--[[
    -- Type: Function
    -- Name: drawMarkerAndHandleShop
    -- Use: Draws marker and handles interaction with shop
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function drawMarkerAndHandleShop()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.Shop.location)

    if dist <= Config.Shop.drawDistance then
        DrawMarker(1, Config.Shop.location.x, Config.Shop.location.y, Config.Shop.location.z-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0, 155, 255, 100, false, true, 2, false, nil, nil, false)
        if not state.open then
            drawText('Press ~g~E~s~ to open weapon shop', 0.5, 0.8, 0.45)
            if IsControlJustPressed(0, 38) then
                openMenu()
            end
        end
    else
        if state.open then
            closeMenu()
        end
    end
end

--[[
    -- Type: Function
    -- Name: notify
    -- Use: Displays a notification to the player
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function notify(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

--[[
    -- Type: Function
    -- Name: mainLoop
    -- Use: Main render and input loop
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        if showing then
            drawMarkerAndHandleShop()
        end

        if state.open then
            handleInput()
            renderMenu()
        end
    end
end)

--[[
    -- Type: Event
    -- Name: np-gangweapons:purchaseResult
    -- Use: Handles server purchase response
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-gangweapons:purchaseResult', function(success, data)
    if success then
        local ped = PlayerPedId()
        GiveWeaponToPed(ped, GetHashKey(data), 250, false, true)
        notify('Weapon purchased: '..data)
    else
        notify(data)
    end
end)

