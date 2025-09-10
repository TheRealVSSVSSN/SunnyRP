--[[
    -- Type: Server Script
    -- Name: host_lock.lua
    -- Use: Manages host lock acquisition and release for non-OneSync servers
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local HOST_TIMEOUT = 5000

local currentHost = nil
local hostReleaseCallbacks = {}

--[[
    -- Type: Function
    -- Name: releaseHostLock
    -- Use: Frees the current host lock and notifies waiting callbacks
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function releaseHostLock()
    for _, cb in ipairs(hostReleaseCallbacks) do
        cb()
    end
    hostReleaseCallbacks = {}
    currentHost = nil
end

--[[
    -- Type: Event Handler
    -- Name: onHostingSession
    -- Use: Attempts to acquire the host lock for a requesting client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function onHostingSession()
    local src = source

    if currentHost then
        TriggerClientEvent('sessionHostResult', src, 'wait')
        table.insert(hostReleaseCallbacks, function()
            TriggerClientEvent('sessionHostResult', src, 'free')
        end)
        return
    end

    local hostId = GetHostId()
    if hostId and GetPlayerLastMsg(hostId) < 1000 then
        TriggerClientEvent('sessionHostResult', src, 'conflict')
        return
    end

    currentHost = src
    TriggerClientEvent('sessionHostResult', src, 'go')

    SetTimeout(HOST_TIMEOUT, function()
        if currentHost == src then
            releaseHostLock()
        end
    end)
end

--[[
    -- Type: Event Handler
    -- Name: onHostedSession
    -- Use: Releases the host lock after session is hosted
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function onHostedSession()
    local src = source
    if currentHost ~= src then
        DropPlayer(src, 'Invalid host release attempt')
        return
    end
    releaseHostLock()
end

--[[
    -- Type: Event Handler
    -- Name: onPlayerDropped
    -- Use: Ensures host lock is released if the hosting player disconnects
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function onPlayerDropped()
    if source == currentHost then
        releaseHostLock()
    end
end

RegisterNetEvent('hostingSession', onHostingSession)
RegisterNetEvent('hostedSession', onHostedSession)
AddEventHandler('playerDropped', onPlayerDropped)

EnableEnhancedHostSupport(true)
