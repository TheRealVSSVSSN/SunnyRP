--[[
    fsn_store - server
    Manages store inventories and transactions
]]

local stores = {
    ['liquorace'] = {
        busy = false,
        stock = {
            beef_jerky        = {amt=999,price=4},
            cupcake           = {amt = 999, price = 1},
            microwave_burrito = {amt = 999, price = 8},
            panini            = {amt = 999, price = 6},
            pepsi             = {amt = 999, price = 5},
            phone             = {amt = 999, price = 250},
            bandage           = {amt = 1500, price = 250},
            binoculars        = {amt = 999, price = 250},
        }
    },

    ['ltdgas'] = {
        busy = false,
        stock = {
            beef_jerky        = {amt=999,price=4},
            cupcake           = {amt = 999, price = 1},
            microwave_burrito = {amt = 999, price = 8},
            panini            = {amt = 999, price = 6},
            pepsi             = {amt = 999, price = 5},
            phone             = {amt = 999, price = 250},
            bandage           = {amt = 1500, price = 250},
            binoculars        = {amt = 999, price = 250},
        }
    },

    ['robsliquor'] = {
        busy = false,
        stock = {
            beef_jerky        = {amt=999,price=4},
            cupcake           = {amt = 999, price = 1},
            microwave_burrito = {amt = 999, price = 8},
            panini            = {amt = 999, price = 6},
            pepsi             = {amt = 999, price = 5},
            phone             = {amt = 999, price = 250},
            bandage           = {amt = 1500, price = 250},
            binoculars        = {amt = 999, price = 250},
        }
    },

    ['twentyfourseven'] = {
        busy = false,
        stock = {
            beef_jerky        = {amt=999,price=4},
            cupcake           = {amt = 999, price = 1},
            microwave_burrito = {amt = 999, price = 8},
            panini            = {amt = 999, price = 6},
            pepsi             = {amt = 999, price = 5},
            phone             = {amt = 999, price = 250},
            bandage           = {amt = 1500, price = 250},
            binoculars        = {amt = 999, price = 250},
        }
    },

    ['pillbox'] = {
        busy = false,
        stock = {
            beef_jerky        = {amt=999,price=4},
            cupcake           = {amt = 999, price = 1},
            microwave_burrito = {amt = 999, price = 8},
            panini            = {amt = 999, price = 6},
            pepsi             = {amt = 999, price = 5},
            phone             = {amt = 999, price = 250},
            bandage           = {amt = 1500, price = 250},
            binoculars        = {amt = 999, price = 250},
        }
    },

    ['ply_owner'] = {
        busy = false,
        stock = {
            weapon_assaultrifle = {amt = 999, price = 10000},
            weapon_combatpistol = {amt = 999, price = 500},
            weapon_smg          = {amt = 999, price = 500},
            weapon_fireextinguisher = {amt = 999, price = 500},
            ammo_pistol         = {amt = 999, price = 600},
            ammo_pistol_large   = {amt = 999, price = 800},
            ammo_smg            = {amt = 999, price = 600},
            ammo_smg_large      = {amt = 999, price = 800},
            armor               = {amt = 999, price = 1000},
        }
    }
}

local items = {}

--[[
    -- Type: Function
    -- Name: deepCopy
    -- Use: Creates a deep copy of a table
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function deepCopy(tbl)
    if type(tbl) ~= 'table' then return tbl end
    local result = {}
    for k, v in pairs(tbl) do
        result[k] = deepCopy(v)
    end
    return result
end

--[[
    -- Type: Event
    -- Name: fsn_store:request
    -- Use: Sends store inventory to the requesting player
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store:request', function(storeId, gunstore)
    local src = source
    local s = stores[storeId]
    if not s then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'ERROR: This store does not seem to exist', 'centerRight', 8000, 'error')
        return
    end
    if s.busy then
        TriggerClientEvent('fsn_notify:displayNotification', src, ('This store is in use by another player: %s'):format(s.busy), 'centerRight', 8000, 'error')
        return
    end
    s.busy = src
    local inv = {}
    for itemName, data in pairs(s.stock) do
        local item = items[itemName]
        if item then
            local itemCopy = deepCopy(item)
            itemCopy.amt = data.amt
            itemCopy.data = itemCopy.data or {}
            itemCopy.data.price = data.price
            table.insert(inv, itemCopy)
        else
            print(('[fsn_store] ERROR: Item %s is not defined in server.lua'):format(itemName))
        end
    end
    TriggerClientEvent('fsn_inventory:store:recieve', src, storeId, inv, gunstore)
end)

--[[
    -- Type: Event
    -- Name: fsn_store:boughtOne
    -- Use: Handles stock reduction when an item is purchased
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store:boughtOne', function(storeId, itemName)
    local src = source
    local s = stores[storeId]
    if not s or not s.stock[itemName] then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'ERROR: This store does not have that item - please speak to a developer', 'centerRight', 8000, 'error')
        return
    end
    local entry = s.stock[itemName]
    if entry.amt > 0 then
        entry.amt = entry.amt - 1
    end
    TriggerEvent('fsn_main:logging:addLog', src, 'weapons', ('[GUNSTORE] Player(%s) purchased %s from %s'):format(src, itemName, storeId))
end)

--[[
    -- Type: Event
    -- Name: fsn_store:closedStore
    -- Use: Releases store lock when menu closes
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store:closedStore', function(storeId)
    local s = stores[storeId]
    if s then
        s.busy = false
    else
        TriggerClientEvent('fsn_notify:displayNotification', source, 'ERROR: This store does not seem to exist', 'centerRight', 8000, 'error')
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_store:recieveItemsForStore
    -- Use: Receives preset item definitions for store stock
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store:recieveItemsForStore', function(presetItems)
    items = presetItems
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Releases store locks when a player leaves
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    for _, s in pairs(stores) do
        if s.busy == source then
            s.busy = false
        end
    end
end)

--[[
    -- Type: Event
    -- Name: onResourceStart
    -- Use: Requests item data on resource start
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    print(('^6%s has started. Receiving presetItems for stock^0'):format(resourceName))
    TriggerEvent('fsn_inventory:sendItemsToStore')
end)

