--[[
    -- Type: Utility
    -- Name: ServerUtils
    -- Use: Helper functions for EssentialMode
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

--[[
    -- Type: Function
    -- Name: stringsplit
    -- Use: Splits a string by separator into a table
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function stringsplit(input, sep)
    local t = {}
    if not sep or sep == '' then sep = '%s' end
    for str in string.gmatch(input, '([^' .. sep .. ']+)') do
        t[#t + 1] = str
    end
    return t
end

--[[
    -- Type: Function
    -- Name: startswith
    -- Use: Checks if a string starts with another
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function startswith(str, start)
    return string.sub(str, 1, #start) == start
end

--[[
    -- Type: Function
    -- Name: returnIndexesInTable
    -- Use: Counts entries in a table
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function returnIndexesInTable(t)
    local i = 0
    for _, _ in pairs(t) do
        i = i + 1
    end
    return i
end

--[[
    -- Type: Function
    -- Name: debugMsg
    -- Use: Prints debug messages when enabled
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function debugMsg(msg)
    if settings.defaultSettings.debugInformation and msg then
        print('ES_DEBUG: ' .. msg)
    end
end

AddEventHandler('es:debugMsg', debugMsg)

-- Export helpers globally
_G.stringsplit = stringsplit
_G.startswith = startswith
_G.returnIndexesInTable = returnIndexesInTable
_G.debugMsg = debugMsg
