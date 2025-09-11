--[[
    -- Type: Module
    -- Name: fsn_errorcontrol client
    -- Use: Intercepts errors and forwards them to server logging
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local oldError = error
local oldTrace = Citizen.Trace

-- keywords used to detect error-like messages in trace output
local errorWords = {
    'failure', 'error', 'not', 'failed', 'not safe', 'invalid',
    'cannot', '.lua', 'server', 'client', 'attempt',
    'traceback', 'stack', 'function'
}

--[[
    -- Type: Function
    -- Name: sendError
    -- Use: Logs the message locally and relays it to the server
--]]
local function sendError(msg)
    local resource = GetCurrentResourceName()
    print((':: fsn_errorcontrol :: (%s)'):format(resource))
    print(msg)
    print(':: end ::')

    TriggerServerEvent('fsn_main:logging:addLog', GetPlayerServerId(PlayerId()), 'scripterror', msg)
end

--[[
    -- Type: Function
    -- Name: error
    -- Use: Overrides the global error function to log before propagating
--]]
function error(...)
    local msg = table.concat({...}, ' ')
    sendError(msg)
    oldError(msg)
end

--[[
    -- Type: Function
    -- Name: Citizen.Trace
    -- Use: Hooks into Citizen.Trace to catch error keywords
--]]
function Citizen.Trace(...)
    local msg = table.concat({...}, ' ')
    oldTrace(msg)

    if type(msg) == 'string' then
        local lowerMsg = msg:lower()
        for _, word in ipairs(errorWords) do
            if lowerMsg:find(word, 1, true) then
                error(msg)
                break
            end
        end
    end
end

