--[[
    -- Type: Module
    -- Name: srp
    -- Use: Provides global SRP table and export helper
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]

SRP = rawget(_G, 'SRP') or {}

--[[
    -- Type: Function
    -- Name: export
    -- Use: Registers functions to the SRP namespace and exports them
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function export(name, fn)
    SRP[name] = fn
    exports(name, fn)
end

SRP.Export = export

return SRP
