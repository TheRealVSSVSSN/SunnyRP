--[[
    -- Type: Module
    -- Name: SRP Shared Table
    -- Use: Provides export helpers for resources
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SRP = {}

--[[
    -- Type: Function
    -- Name: Export
    -- Use: Registers a function for external use
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]
function SRP.Export(name, fn)
    _G[name] = fn
    if type(exports) == 'function' then
        exports(name, fn)
    end
end

function exports(name, fn)
    SRP.Export(name, fn)
end
