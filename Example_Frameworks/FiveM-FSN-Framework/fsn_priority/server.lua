--[[
    -- Type: Server Script
    -- Name: Priority Loader
    -- Use: Loads priority entries from database and registers them with connectqueue
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local mysqlReady = false
MySQL.ready(function()
    mysqlReady = true
end)

local queueReady = false
Queue.OnReady(function()
    queueReady = true
end)

--[[
    -- Type: Function
    -- Name: loadPriority
    -- Use: Fetches priority users from database and adds them to queue
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadPriority()
    MySQL.Async.fetchAll('SELECT steamid, priority, name FROM fsn_users WHERE priority <> 0', {}, function(res)
        for _, usr in ipairs(res) do
            Queue.AddPriority(usr.steamid, tonumber(usr.priority))
            print(string.format('[fsn_priority] Added priority %d for %s (%s)', usr.priority, usr.name, usr.steamid))
        end
    end)
end

CreateThread(function()
    repeat
        Wait(500)
    until mysqlReady and queueReady

    loadPriority()
end)

--[[
    -- Type: Command
    -- Name: reloadpriority
    -- Use: Reloads priority levels from database
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('reloadpriority', function(src)
    if src == 0 then
        loadPriority()
        print('[fsn_priority] Priority list reloaded by console')
    end
end, true)

