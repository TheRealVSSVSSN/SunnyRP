--[[ 
    -- Type: Table
    -- Name: jobs
    -- Use: Stores scheduled callbacks with hour and minute
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local jobs = {}

--[[ 
    -- Type: Variable
    -- Name: lastTick
    -- Use: Tracks the last processed Unix minute
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local lastTick = os.time() - (os.time() % 60)

--[[ 
    -- Type: Function
    -- Name: runAt
    -- Use: Registers a callback to run at a specific hour and minute
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function runAt(h, m, cb)
    jobs[#jobs + 1] = { h = h, m = m, cb = cb }
end

--[[ 
    -- Type: Function
    -- Name: triggerJobs
    -- Use: Executes jobs matching provided time parameters
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function triggerJobs(d, h, m)
    for i = 1, #jobs do
        local job = jobs[i]
        if job.h == h and job.m == m then
            job.cb(d, h, m)
        end
    end
end

--[[ 
    -- Type: Function
    -- Name: tick
    -- Use: Internal loop that checks the time and runs pending jobs
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function tick()
    CreateThread(function()
        while true do
            local now = os.time()
            while now - lastTick >= 60 do
                lastTick = lastTick + 60
                local t = os.date('*t', lastTick)
                triggerJobs(t.wday, t.hour, t.min)
            end
            local waitSeconds = 60 - tonumber(os.date('%S', now))
            Wait(waitSeconds * 1000)
        end
    end)
end

tick()

--[[ 
    -- Type: Event
    -- Name: cron:runAt
    -- Use: Registers a scheduled callback from other resources
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('cron:runAt', function(h, m, cb)
    runAt(h, m, cb)
end)

exports('RunAt', runAt)
