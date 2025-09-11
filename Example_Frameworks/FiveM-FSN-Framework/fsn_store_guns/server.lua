local storeIds = {
    'gunstore_1', 'gunstore_2', 'gunstore_3', 'gunstore_4', 'gunstore_5',
    'gunstore_6', 'gunstore_7', 'gunstore_8', 'gunstore_9', 'gunstore_10', 'gunstore_11'
}

local defaultStock = {
    WEAPON_ASSAULTRIFLE = {amt = 999, price = 10000},
    WEAPON_COMBATPISTOL = {amt = 999, price = 500},
    WEAPON_SMG = {amt = 999, price = 500},
    ammo_pistol = {amt = 999, price = 600},
    ammo_pistol_large = {amt = 999, price = 800},
    ammo_smg = {amt = 999, price = 600},
    ammo_smg_large = {amt = 999, price = 800},
    armor = {amt = 999, price = 1000}
}

local weaponTemplate = {
    index = 'WEAPON_ASSAULTRIFLE',
    name = 'ASSAULT RIFLE',
    amt = 1,
    data = {weight = 5},
    customData = {weapon = 'true', ammo = 200, ammotype = 'rifle_ammo', quality = 'perfect'}
}

local items = {
    WEAPON_ASSAULTRIFLE = weaponTemplate,
    WEAPON_COMBATPISTOL = {
        index = 'WEAPON_COMBATPISTOL',
        name = 'Combat Pistol',
        data = {weight = 9},
        customData = {weapon = 'true', ammo = 200, ammotype = 'ammo_pistol', quality = 'normal', Serial = ''}
    },
    WEAPON_SMG = {
        index = 'WEAPON_SMG',
        name = 'SMG',
        data = {weight = 9},
        customData = {weapon = 'true', ammo = 200, ammotype = 'ammo_smg', quality = 'normal', Serial = ''}
    },
    ammo_pistol = {index = 'ammo_pistol', name = 'Pistol Ammo', data = {weight = 5.5}},
    ammo_pistol_large = {index = 'ammo_pistol_large', name = 'Large Pistol Ammo', data = {weight = 8.5}},
    ammo_smg = {index = 'ammo_smg', name = 'SMG Ammo', data = {weight = 5.5}},
    ammo_smg_large = {index = 'ammo_smg_large', name = 'Large SMG Ammo', data = {weight = 8.5}},
    ammo_shotgun = {index = 'ammo_shotgun', name = 'Shotgun Ammo', data = {weight = 6.5}},
    ammo_shotgun_large = {index = 'ammo_shotgun_large', name = 'Large Shotgun Ammo', data = {weight = 9.5}},
    ammo_rifle = {index = 'ammo_rifle', name = 'Rifle Ammo', data = {weight = 6.5}},
    ammo_rifle_large = {index = 'ammo_rifle_large', name = 'Large Rifle Ammo', data = {weight = 9.5}},
    ammo_sniper = {index = 'ammo_sniper', name = 'Sniper Ammo', data = {weight = 6.5}},
    ammo_sniper_large = {index = 'ammo_sniper_large', name = 'Large Sniper Ammo', data = {weight = 9.5}},
    armor = {index = 'armor', name = 'Kevlar', data = {weight = 13.5}}
}

--[[
    -- Type: Function
    -- Name: deepCopy
    -- Use: Creates a deep copy of a table
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function deepCopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == 'table' then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local stores = {}
for _, id in ipairs(storeIds) do
    stores[id] = {busy = false, stock = deepCopy(defaultStock)}
end

--[[
    -- Type: Event
    -- Name: fsn_store_guns:request
    -- Use: Sends store inventory to requesting player
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store_guns:request')
AddEventHandler('fsn_store_guns:request', function(store_id)
    local src = source
    local s = stores[store_id]
    if not s then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'ERROR: This store does not seem to exist', 'centerRight', 8000, 'error')
        return
    end

    if s.busy then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'This store is in use by another player: '..s.busy, 'centerRight', 8000, 'error')
        return
    end

    s.busy = src
    local inv = {}
    for k, v in pairs(s.stock) do
        local template = items[k]
        if template then
            local item = deepCopy(template)
            item.data = item.data or {}
            item.data.price = v.price
            item.amt = v.amt
            inv[#inv + 1] = item
        else
            print('ERROR (fsn_store_guns) :: Item '..k..' is not defined in server.lua')
        end
    end

    TriggerClientEvent('fsn_inventory:store_gun:recieve', src, store_id, inv)
end)

--[[
    -- Type: Event
    -- Name: fsn_store_guns:boughtOne
    -- Use: Updates store stock after purchase
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store_guns:boughtOne')
AddEventHandler('fsn_store_guns:boughtOne', function(store_id, item)
    local src = source
    local s = stores[store_id]
    if not s then
        TriggerClientEvent('fsn_notify:displayNotification', src, 'ERROR: This store does not seem to exist', 'centerRight', 8000, 'error')
        return
    end

    if s.stock[item] and s.stock[item].amt > 0 then
        s.stock[item].amt = s.stock[item].amt - 1
        TriggerEvent('fsn_main:logging:addLog', src, 'weapons', '[GUNSTORE] Player('..src..') purchased '..item..' from '..store_id)
    else
        TriggerClientEvent('fsn_notify:displayNotification', src, 'ERROR: This store does not have that item - please speak to a developer', 'centerRight', 8000, 'error')
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_store_guns:closedStore
    -- Use: Resets busy status when a player leaves the store
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_store_guns:closedStore')
AddEventHandler('fsn_store_guns:closedStore', function(store_id)
    local s = stores[store_id]
    if s then
        s.busy = false
    else
        TriggerClientEvent('fsn_notify:displayNotification', source, 'ERROR: This store does not seem to exist', 'centerRight', 8000, 'error')
    end
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Frees any store busy flags when a player disconnects
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

