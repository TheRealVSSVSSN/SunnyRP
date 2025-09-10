--[[
    -- Type: Client Script
    -- Name: cl_errorlog
    -- Use: Detects error-related traces and forwards them to the server
    -- Created: 2024-05-27
    -- By: VSSVSSN
--]]

local originalError = error
local originalTrace = Citizen.Trace

local errorWords = {
    "failure", "error", "not", "failed", "not safe", "invalid", "cannot",
    ".lua", "server", "client", "attempt", "traceback", "stack", "function"
}

local function sendErrorLog(msg)
    local resource = GetCurrentResourceName()
    TriggerServerEvent('np-errorlog:logError', resource, msg)
end

function error(message, ...)
    sendErrorLog(tostring(message))
    return originalError(message, ...)
end

function Citizen.Trace(message, ...)
    originalTrace(message, ...)

    if type(message) == 'string' then
        local lower = message:lower()

        for _, word in ipairs(errorWords) do
            if lower:find(word, 1, true) then
                sendErrorLog(message)
                break
            end
        end
    end
end

