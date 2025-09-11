--[[
    -- Type: Table
    -- Name: craftingStations
    -- Use: Defines all crafting locations and their requirements
    -- Created: 2024-10-29
    -- By: VSSVSSN
--]]

local craftingStations = {
    -- Weed
    {
        loc = vector3(2219.7759, 5577.4585, 52.8453),
        cost = 5,
        required = { item = 'none', itemtitle = 'none', amount = 0 },
        gives = { item = '2g_weed', itemtitle = '2G Weed', amount = 2 }
    },
    {
        loc = vector3(-76.8079, -1397.0087, 28.35999),
        state = 'Fuck me you stink\nof weed',
        cost = 80,
        required = { item = '2g_weed', itemtitle = '2G Weed', amount = 1 },
        gives = { item = 'joint', itemtitle = 'Joint', amount = 4 }
    },

    -- Meth
    {
        loc = vector3(3609.7397, 3744.5918, 28.3901),
        cost = 15,
        required = { item = 'none', itemtitle = 'none', amount = 0 },
        gives = { item = 'acetone', itemtitle = 'Acetone', amount = 2 }
    },
    {
        loc = vector3(-331.4419, -2445.2722, 6.34123),
        cost = 25,
        required = { item = 'acetone', itemtitle = 'Acetone', amount = 1 },
        gives = { item = 'phosphorus', itemtitle = 'Phosphorus', amount = 1 }
    },
    {
        loc = vector3(1392.0356, 3605.2119, 38.94193),
        cost = 60,
        required = { item = 'phosphorus', itemtitle = 'Phosphorus', amount = 1 },
        gives = { item = 'meth_rocks', itemtitle = 'Meth Rocks', amount = 4 }
    },

    -- Burgers
    {
        loc = vector3(974.915, -2120.97, 31.3902),
        cost = 0,
        required = { item = 'uncooked_meat', itemtitle = 'Raw Meat', amount = 3 },
        gives = { item = 'minced_meat', itemtitle = 'Minced Meat', amount = 1 }
    },
    {
        loc = vector3(-1856.4829, -1224.6036, 13.01722),
        cost = 100,
        required = { item = 'minced_meat', itemtitle = 'Minced Meat', amount = 1 },
        gives = { item = 'burger', itemtitle = 'Supreme Burger', amount = 1 }
    }
}

--[[
    -- Type: Function
    -- Name: handleCrafting
    -- Use: Validates requirements and awards crafted items
    -- Created: 2024-10-29
    -- By: VSSVSSN
--]]
local function handleCrafting(station)
    if exports.fsn_main:fsn_GetWallet() < station.cost then
        TriggerEvent('fsn_notify:displayNotification', ('You don\'t have $%s!!!'):format(station.cost), 'centerRight', 3500, 'error')
        return
    end

    if exports.fsn_inventory:fsn_GetItemAmount(station.required.item) < station.required.amount then
        TriggerEvent('fsn_notify:displayNotification', "You don't have any " .. station.required.itemtitle, 'centerRight', 3500, 'error')
        return
    end

    local waittime = math.random(4000, 10000)
    TriggerEvent('fsn_notify:displayNotification', ('Gathering [%sX] %s'):format(station.gives.amount, station.gives.itemtitle), 'centerLeft', waittime, 'info')
    Wait(waittime)

    if station.state then
        TriggerEvent('fsn_evidence:ped:addState', station.state, 'UPPER_BODY', 120)
    end

    if station.required.item ~= 'none' then
        TriggerEvent('fsn_inventory:item:take', station.required.item, station.required.amount)
    end

    TriggerEvent('fsn_notify:displayNotification', ('Gathered [%sX] %s'):format(station.gives.amount, station.gives.itemtitle), 'centerRight', 3500, 'success')

    if station.cost > 0 then
        TriggerEvent('fsn_bank:change:walletMinus', station.cost)
    end

    TriggerEvent('fsn_inventory:item:add', station.gives.item, station.gives.amount)
end

--[[
    -- Type: Thread
    -- Name: initCraftingStations
    -- Use: Renders crafting markers and handles interaction
    -- Created: 2024-10-29
    -- By: VSSVSSN
--]]
CreateThread(function()
    for _, v in ipairs(craftingStations) do
        if v.blip then
            local bleep = AddBlipForCoord(v.loc.x, v.loc.y, v.loc.z)
            SetBlipSprite(bleep, v.blip.id)
            SetBlipDisplay(bleep, 4)
            SetBlipScale(bleep, 1.0)
            SetBlipColour(bleep, 4)
            SetBlipAsShortRange(bleep, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.blip.title)
            EndTextCommandSetBlipName(bleep)
        end
    end

    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, v in ipairs(craftingStations) do
            local dist = #(playerCoords - v.loc)
            if dist < 10.0 then
                DrawMarker(1, v.loc.x, v.loc.y, v.loc.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 0.4, 0, 155, 255, 175, false, true, 2, false, nil, nil, false)
                if dist < 4.0 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString(('Press ~INPUT_PICKUP~ to get ~g~%s'):format(v.gives.itemtitle))
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(0, 38) then
                        handleCrafting(v)
                    end
                end
            end
        end
    end
end)

