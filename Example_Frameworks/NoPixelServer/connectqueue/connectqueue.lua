Queue = {
    Ready = false,
    Exports = nil,
    ReadyCbs = {},
    CurResource = GetCurrentResourceName()
}

if Queue.CurResource == 'connectqueue' then
    return
end

--[[
    -- Type: Function
    -- Name: OnReady
    -- Use: Executes callback once queue exports are loaded
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.OnReady(cb)
    if not cb then return end
    if Queue.IsReady() then
        cb()
        return
    end
    table.insert(Queue.ReadyCbs, cb)
end

--[[
    -- Type: Function
    -- Name: OnJoin
    -- Use: Registers callback for player join events
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.OnJoin(cb)
    if not cb then return end
    Queue.Exports:OnJoin(cb, Queue.CurResource)
end

--[[
    -- Type: Function
    -- Name: AddPriority
    -- Use: Grants priority to a specific identifier
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.AddPriority(id, power, temp)
    if not Queue.IsReady() then return end
    Queue.Exports:AddPriority(id, power, temp)
end

--[[
    -- Type: Function
    -- Name: RemovePriority
    -- Use: Revokes priority from an identifier
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.RemovePriority(id)
    if not Queue.IsReady() then return end
    Queue.Exports:RemovePriority(id)
end

--[[
    -- Type: Function
    -- Name: IsReady
    -- Use: Checks if queue exports are available
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.IsReady()
    return Queue.Ready
end

--[[
    -- Type: Function
    -- Name: LoadExports
    -- Use: Retrieves queue exports and marks module ready
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.LoadExports()
    Queue.Exports = exports.connectqueue:GetQueueExports()
    Queue.Ready = true
    Queue.ReadyCallbacks()
end

--[[
    -- Type: Function
    -- Name: ReadyCallbacks
    -- Use: Executes queued callbacks once exports are ready
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Queue.ReadyCallbacks()
    if not Queue.IsReady() then return end
    for _, cb in ipairs(Queue.ReadyCbs) do
        cb()
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == 'connectqueue' then
        while GetResourceState(resource) ~= 'started' do
            Wait(0)
        end
        Wait(1)
        Queue.LoadExports()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == 'connectqueue' then
        Queue.Ready = false
        Queue.Exports = nil
    end
end)

CreateThread(function()
    Wait(0)
    Queue.LoadExports()
end)