--[[
    -- Type: Client Script
    -- Name: shops client
    -- Use: Handles interaction with world shop markers and vending machines
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]

local cellCoords = {
    { x = 1703.728, y = 2461.132, z = 45.73 },
    { x = 1707.229, y = 2455.741, z = 45.73677 },
    { x = 1707.593, y = 2450.49, z = 45.73676 },
    { x = 1709.362, y = 2445.035, z = 45.73 },
    { x = 1709.71,  y = 2438.39,  z = 45.73 },
    { x = 1681.219, y = 2463.895, z = 45.73 },
    { x = 1681.86,  y = 2458.883, z = 45.73 },
    { x = 1680.351, y = 2453.24,  z = 45.73 },
    { x = 1678.481, y = 2446.916, z = 45.73 },
    { x = 1677.733, y = 2439.937, z = 45.82 },
    { x = 1676.946, y = 2440.96,  z = 50.13 },
    { x = 1679.394, y = 2447.457, z = 50.13 },
    { x = 1679.578, y = 2453.013, z = 50.13 },
    { x = 1680.673, y = 2458.57,  z = 50.13 },
    { x = 1681.501, y = 2463.648, z = 50.13 },
    { x = 1709.334, y = 2439.365, z = 50.13 },
    { x = 1707.822, y = 2444.357, z = 50.43 },
    { x = 1706.469, y = 2449.592, z = 50.43 },
    { x = 1707.109, y = 2456.153, z = 50.42 },
    { x = 1705.615, y = 2462.362, z = 50.42 }
}

local methLocation = { x = 1694.259, y = 2439.205, z = 45.74 }

local toolShops = {
    { x = 44.838947296143,  y = -1748.5364990234, z = 29.549386978149 },
    { x = 2749.2309570313,  y = 3472.3308105469, z = 55.679393768311 }
}

local twentyFourSeven = {
    { x = 1961.1140136719, y = 3741.4494628906, z = 32.34375 },
    { x = 1392.4129638672, y = 3604.47265625,  z = 34.980926513672 },
    { x = 546.98962402344,  y = 2670.3176269531, z = 42.156539916992 },
    { x = 2556.2534179688, y = 382.876953125,  z = 108.62294769287 },
    { x = -1821.9542236328, y = 792.40191650391, z = 138.13920593262 },
    { x = -1223.6690673828, y = -906.67517089844, z = 12.326356887817 },
    { x = -708.19256591797, y = -914.65264892578, z = 19.215591430664 },
    { x = 26.419162750244,  y = -1347.5804443359, z = 29.497024536133 },
    { x = 460.642,          y = -985.127,        z = 30.6896 },
    { x = -45.4649,         y = -1754.41,       z = 29.421 },
    { x = 24.5889,          y = -1342.32,       z = 29.497 },
    { x = -707.394,         y = -910.114,       z = 19.2156 },
    { x = 1162.87,          y = -319.218,       z = 69.2051 },
    { x = 373.872,          y = 331.028,        z = 103.566 },
    { x = 2552.47,          y = 381.031,        z = 108.623 },
    { x = -1823.67,         y = 796.291,        z = 138.126 },
    { x = 2673.91,          y = 3281.77,        z = 55.2411 },
    { x = 1957.64,          y = 3744.29,        z = 32.3438 },
    { x = 1701.97,          y = 4921.81,        z = 42.0637 },
    { x = 1730.06,          y = 6419.63,        z = 35.0372 },
    { x = 1841.32,          y = 2591.35,        z = 46.02 },
    { x = -436.94,          y = 6007.02,        z = 31.72 },
    { x = 1108.33,          y = 208.40,         z = -49.44 }
}

local weashopLocations = {
    { entering = { 811.973572, -2155.33862, 28.8189938 } },
    { entering = { 1692.54, 3758.13, 34.71 } },
    { entering = { 252.915, -48.186, 69.941 } },
    { entering = { 844.352, -1033.517, 28.094 } },
    { entering = { -331.487, 6082.348, 31.354 } },
    { entering = { -664.268, -935.479, 21.729 } },
    { entering = { -1305.427, -392.428, 36.595 } },
    { entering = { -1119.1, 2696.92, 18.56 } },
    { entering = { 2569.978, 294.472, 108.634 } },
    { entering = { -3172.584, 1085.858, 20.738 } },
    { entering = { 20.0430, -1106.469, 29.697 } }
}

local weashopBlips = {}

--[[
    -- Type: Event
    -- Name: shop:createMeth
    -- Use: Picks a random meth location
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent("shop:createMeth")
AddEventHandler("shop:createMeth", function()
    methLocation = cellCoords[math.random(#cellCoords)]
end)

--[[
    -- Type: Event
    -- Name: shop:isNearPed
    -- Use: Checks if player is near a shop ped for exploit logging
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent("shop:isNearPed")
AddEventHandler("shop:isNearPed", function()
    local pedPos = GetEntityCoords(PlayerPedId())
    for _, v in ipairs(twentyFourSeven) do
        if #(pedPos - vector3(v.x, v.y, v.z)) < 10.0 then
            TriggerServerEvent("exploiter", "User sold to a shop keeper at store.")
            break
        end
    end
end)

--[[
    -- Type: Function
    -- Name: displayHelp
    -- Use: Shows contextual help text on screen
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local function displayHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function openInventory(id, shopType)
    TriggerEvent("server-inventory-open", id, shopType)
    Wait(1000)
end

-- create blips for shops
local function createBlips()
    local blip = AddBlipForCoord(-1218.6767578125, -1516.858764648, 4.3803339004517)
    SetBlipSprite(blip, 427)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Surf and Dive Shop")
    EndTextCommandSetBlipName(blip)

    for _, pos in pairs(weashopLocations) do
        local blip = AddBlipForCoord(pos.entering[1], pos.entering[2], pos.entering[3])
        SetBlipSprite(blip, 110)
        SetBlipScale(blip, 0.85)
        SetBlipColour(blip, 17)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Ammunation")
        EndTextCommandSetBlipName(blip)
        weashopBlips[#weashopBlips+1] = vector3(pos.entering[1], pos.entering[2], pos.entering[3])
    end

    for _, v in ipairs(twentyFourSeven) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 52)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Shop")
        EndTextCommandSetBlipName(blip)
    end

    for _, v in ipairs(toolShops) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 52)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tool Shop")
        EndTextCommandSetBlipName(blip)
    end
end

-- special shop definitions
local specialShops = {
    {
        coords = vector3(206.03, -994.85, -98.78),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ to open the ~g~craft bench.",
        condition = function() return exports["isPed"]:GroupRank("parts_shop") > 3 end,
        action = function() openInventory("16", "Craft") end
    },
    {
        coords = vector3(1108.45, -2007.2, 30.95),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ to open the ~g~smelter.",
        action = function()
            local finished = exports["np-taskbar"]:taskBar(60000, "Readying Smelter")
            if finished == 100 and #(GetEntityCoords(PlayerPedId()) - vector3(1108.45, -2007.2, 30.95)) < 2.0 then
                openInventory("714", "Craft")
            end
        end
    },
    {
        coords = vector3(306.49, -601.31, 43.29),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ to open the ~g~shop.",
        condition = function()
            local job = exports["isPed"]:isPed("myjob")
            return job == "ems" or job == "doctor"
        end,
        action = function() openInventory("47", "Shop") end
    },
    {
        coords = vector3(105.2, 3600.14, 40.73),
        radius = 3.0,
        text = "Press ~INPUT_CONTEXT~ to ~g~Craft.",
        condition = function() return exports["isPed"]:GroupRank("lost_mc") >= 3 end,
        action = function() openInventory("9", "Craft") end
    },
    {
        coords = vector3(885.61, -3199.84, -98.19),
        radius = 3.0,
        text = "Press ~INPUT_CONTEXT~ to ~g~CRAFT.",
        action = function() openInventory("31", "Craft") end
    },
    {
        coords = vector3(1783.16, 2557.02, 45.68),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ to look at food",
        action = function() openInventory("22", "Shop") end
    },
    {
        coords = vector3(-1528.8, 846.02, 181.6),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ to look at food",
        action = function() openInventory("22", "Shop") end
    },
    {
        coords = vector3(1663.36, 2512.99, 46.87),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ what dis?",
        action = function()
            local finished = exports["np-taskbar"]:taskBar(60000, "Searching...")
            if finished == 100 then
                openInventory("26", "Shop")
            end
        end
    },
    {
        coords = vector3(1778.47, 2557.58, 45.68),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ what dis?",
        action = function()
            local finished = exports["np-taskbar"]:taskBar(60000, "Making a god slushy...")
            if finished == 100 then
                openInventory("998", "Shop")
            end
        end
    },
    {
        coords = vector3(1777.58, 2565.15, 45.68),
        radius = 2.0,
        text = "Press ~INPUT_CONTEXT~ what dis?",
        action = function()
            local finished = exports["np-taskbar"]:taskBar(60000, "Searching...")
            if finished == 100 then
                openInventory("921", "Craft")
            end
        end
    },
    {
        coords = vector3(-632.64, 235.25, 81.89),
        radius = 5.0,
        text = "Press ~INPUT_CONTEXT~ to purchase Hipster",
        action = function() openInventory("12", "Shop") end
    }
}

local function handleInteraction(coords, radius, text, action, condition)
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(pos - coords)
    if dist < radius then
        DrawMarker(27, coords.x, coords.y, coords.z - 1.0, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.5,0,25,165,165,0,0,0,0)
        if dist < 2.0 then
            if not condition or condition() then
                displayHelp(text)
                if IsControlJustPressed(1, 38) then
                    action()
                end
            end
        end
        return true
    end
    return false
end

-- handle vending machine completion
RegisterNetEvent("shop:useVM:finish")
AddEventHandler("shop:useVM:finish", function()
    TriggerEvent("DoShortHudText", "Dispensed", 8)
end)

CreateThread(function()
    createBlips()
    while true do
        local wait = 1000
        local pos = GetEntityCoords(PlayerPedId())

        -- weapon shops
        for _, coords in ipairs(weashopBlips) do
            local dist = #(pos - coords)
            if dist < 2.5 then
                wait = 1
                DrawMarker(27, coords.x, coords.y, coords.z, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.5,0,155,255,50,0,0,0,0)
                if not IsPedInAnyVehicle(PlayerPedId(), true) and dist < 1.0 then
                    displayHelp("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
                    if IsControlJustPressed(1, 38) then
                        openInventory("5", "Shop")
                    end
                end
            end
        end

        -- 24/7 shops
        for _, v in ipairs(twentyFourSeven) do
            local coords = vector3(v.x, v.y, v.z)
            local dist = #(pos - coords)
            if dist < 20.0 then
                wait = 1
                DrawMarker(27, coords.x, coords.y, coords.z - 1.0, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.5,0,25,165,165,0,0,0,0)
                if dist < 3.0 then
                    displayHelp("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
                    if IsControlJustPressed(1, 38) then
                        openInventory("2", "Shop")
                    end
                end
            end
        end

        -- tool shops
        for _, v in ipairs(toolShops) do
            local coords = vector3(v.x, v.y, v.z)
            local dist = #(pos - coords)
            if dist < 20.0 then
                wait = 1
                DrawMarker(27, coords.x, coords.y, coords.z - 1.0, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.5,0,25,165,165,0,0,0,0)
                if dist < 3.0 then
                    displayHelp("Press ~INPUT_CONTEXT~ to open the ~g~tool shop.")
                    if IsControlJustPressed(1, 38) then
                        openInventory("4", "Shop")
                    end
                end
            end
        end

        -- special shops
        for _, shop in ipairs(specialShops) do
            if handleInteraction(shop.coords, shop.radius, shop.text, shop.action, shop.condition) then
                wait = 1
            end
        end

        -- meth shop dynamic
        if handleInteraction(vector3(methLocation.x, methLocation.y, methLocation.z), 5.0, "Press ~INPUT_CONTEXT~ what dis?", function()
            local finished = exports["np-taskbar"]:taskBar(60000, "Searching...")
            if finished == 100 and #(GetEntityCoords(PlayerPedId()) - vector3(methLocation.x, methLocation.y, methLocation.z)) < 2.0 then
                openInventory("25", "Shop")
            end
        end) then
            wait = 1
        end

        Wait(wait)
    end
end)
