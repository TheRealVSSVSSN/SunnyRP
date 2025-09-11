--[[
    -- Type: Server Script
    -- Name: host_lock.lua
    -- Use: Coordinates session host locking between clients
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]

-- whitelist c2s events
RegisterNetEvent('hostingSession')
RegisterNetEvent('hostedSession')

--[[
    -- Type: Constant
    -- Name: HOST_TIMEOUT
    -- Use: Maximum time a host lock can be held (ms)
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local HOST_TIMEOUT <const> = 5000

--[[
    -- Type: Variable
    -- Name: currentHosting
    -- Use: Stores the source ID holding the host lock
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local currentHosting = nil

--[[
    -- Type: Variable
    -- Name: hostReleaseCallbacks
    -- Use: Queue of callbacks triggered when host lock is released
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local hostReleaseCallbacks = {}

--[[
    -- Type: Function
    -- Name: releaseHost
    -- Use: Frees the host lock and notifies queued callbacks
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function releaseHost()
    for _, cb in ipairs(hostReleaseCallbacks) do
        local ok, err = pcall(cb)
        if not ok then
            print('[sessionmanager] host release callback error:', err)
        end
    end

    hostReleaseCallbacks = {}
    currentHosting = nil
end

--[[
    -- Type: Event
    -- Name: hostingSession
    -- Use: Attempt to acquire host lock before creating a session
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
AddEventHandler('hostingSession', function()
    local src = source

    if currentHosting then
        TriggerClientEvent('sessionHostResult', src, 'wait')
        hostReleaseCallbacks[#hostReleaseCallbacks + 1] = function()
            TriggerClientEvent('sessionHostResult', src, 'free')
        end
        return
    end

    local hostId = GetHostId()
    if hostId and hostId ~= 0 and GetPlayerLastMsg(hostId) < 1000 then
        TriggerClientEvent('sessionHostResult', src, 'conflict')
        return
    end

    currentHosting = src
    TriggerClientEvent('sessionHostResult', src, 'go')

    Citizen.SetTimeout(HOST_TIMEOUT, function()
        if currentHosting == src then
            releaseHost()
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: hostedSession
    -- Use: Releases the host lock after a session starts
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
AddEventHandler('hostedSession', function()
    if currentHosting ~= source then
        print(('[sessionmanager] %s attempted to release host lock without ownership'):format(source))
        return
    end

    releaseHost()
end)

EnableEnhancedHostSupport(true)
