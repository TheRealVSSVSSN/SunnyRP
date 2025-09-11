--[[
    -- Type: Server Script
    -- Name: server.lua
    -- Use: Manages evidence locker storage and retrieval
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]

local lockerItems = {}

--[[
    -- Type: Function
    -- Name: loadItems
    -- Use: Loads all evidence entries from MySQL into memory
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
local function loadItems()
    MySQL.Async.fetchAll('SELECT id, description FROM fsn_locker', {}, function(res)
        lockerItems = res or {}
    end)
end

MySQL.ready(function()
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS fsn_locker (
        id INT AUTO_INCREMENT,
        description VARCHAR(255) NOT NULL,
        PRIMARY KEY (id)
    )]], {}, function()
        loadItems()
    end)
end)

--[[
    -- Type: Event
    -- Name: fsn_storagelockers:deposit
    -- Use: Stores a piece of evidence text in the locker
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
RegisterNetEvent('fsn_storagelockers:deposit', function(text)
    local src = source
    if type(text) ~= 'string' or text == '' then return end
    MySQL.Async.execute('INSERT INTO fsn_locker (description) VALUES (@d)', {['@d'] = text}, function()
        loadItems()
        TriggerClientEvent('fsn_storagelockers:sendItems', src, lockerItems)
    end)
end)

--[[
    -- Type: Event
    -- Name: fsn_storagelockers:request
    -- Use: Sends current locker contents to requesting player
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
RegisterNetEvent('fsn_storagelockers:request', function()
    local src = source
    TriggerClientEvent('fsn_storagelockers:sendItems', src, lockerItems)
end)

