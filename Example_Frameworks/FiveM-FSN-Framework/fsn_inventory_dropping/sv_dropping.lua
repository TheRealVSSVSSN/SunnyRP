--[[
    -- Type: Variable
    -- Name: lock
    -- Use: Prevents simultaneous access to the dropped item table
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local lock = false

--[[
    -- Type: Variable
    -- Name: droppedItems
    -- Use: Holds all dropped item data
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local droppedItems = {}

--[[
    -- Type: Function
    -- Name: acquireLock
    -- Use: Waits for table access with a five minute timeout
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local function acquireLock()
    local start = os.time()
    while lock do
        Wait(0)
        if os.time() - start >= 300 then
            return false
        end
    end
    lock = true
    return true
end

--[[
    -- Type: Function
    -- Name: releaseLock
    -- Use: Releases the table access lock
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local function releaseLock()
    lock = false
end

--[[
    -- Type: Event
    -- Name: fsn_inventory:drops:request
    -- Use: Sends all dropped items to the requesting client
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_inventory:drops:request', function()
    TriggerClientEvent('fsn_inventory:drops:send', source, droppedItems)
end)

--[[
    -- Type: Event
    -- Name: fsn_inventory:drops:collect
    -- Use: Handles a player picking up a dropped item
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_inventory:drops:collect', function(id)
    local src = source
    if not acquireLock() then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Inventory action timed out (5 minutes). Contact a member of staff!' })
        return
    end

    local drop = droppedItems[id]
    if drop then
        TriggerClientEvent('fsn_inventory:items:add', src, drop.item)
        droppedItems[id] = nil
        TriggerClientEvent('fsn_inventory:drops:send', -1, droppedItems)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'This item looks to be missing, did someone else pick it up?' })
    end

    releaseLock()
end)

--[[
    -- Type: Event
    -- Name: fsn_inventory:drops:drop
    -- Use: Registers a new item drop and notifies all clients
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_inventory:drops:drop', function(coords, item)
    local src = source
    if not acquireLock() then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Inventory action timed out (5 minutes). Contact a member of staff!' })
        return
    end

    droppedItems[#droppedItems + 1] = { loc = coords, item = item }
    TriggerClientEvent('fsn_inventory:drops:send', -1, droppedItems)

    releaseLock()
end)
