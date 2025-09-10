--[[
    -- Type: Server Script
    -- Name: Restart Scheduler
    -- Use: Handles automated restart warnings and exposes tax retrieval
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local restartHours = {0, 6, 12, 18}
local warning15 = "The server will restart in 15 minutes!"
local warning10 = "The server will restart in 10 minutes!"
local warning5  = "The server will restart in 5 minutes!"
local finalWarning = "The server will begin its restart process now!"

--[[
    -- Type: Function
    -- Name: buildSchedule
    -- Use: Generates a lookup table of times mapped to warning messages
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function buildSchedule()
    local schedule = {}
    for _, hour in ipairs(restartHours) do
        local prevHour = (hour + 23) % 24

        schedule[("%02d:%02d:%02d"):format(prevHour, 45, 0)] = warning15
        schedule[("%02d:%02d:%02d"):format(prevHour, 50, 0)] = warning10
        schedule[("%02d:%02d:%02d"):format(prevHour, 55, 0)] = warning5

        for sec = 10, 50, 10 do
            schedule[("%02d:%02d:%02d"):format(prevHour, 59, sec)] = finalWarning
        end

        schedule[("%02d:%02d:%02d"):format(hour, 0, 0)] = finalWarning
    end
    return schedule
end

local restartSchedule = buildSchedule()

--[[
    -- Type: Function
    -- Name: startRestartLoop
    -- Use: Checks the current time each second and broadcasts restart messages
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function startRestartLoop()
    CreateThread(function()
        while true do
            local timeStr = os.date("%H:%M:%S")
            local msg = restartSchedule[timeStr]
            if msg then
                TriggerClientEvent('chat:addMessage', -1, {
                    color = {255, 0, 0},
                    multiline = false,
                    args = {'SYSTEM', msg}
                })
            end
            Wait(1000)
        end
    end)
end

startRestartLoop()

local lastTaxes = nil

--[[
    -- Type: Function
    -- Name: getTax
    -- Use: Retrieves current tax data from the voting system
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function getTax()
    lastTaxes = exports['np-votesystem']:getTaxes()
    return lastTaxes
end

