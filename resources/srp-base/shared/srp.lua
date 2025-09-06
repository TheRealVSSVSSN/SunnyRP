--[[
    -- Type: Module
    -- Name: srp
    -- Use: Provides global SRP table and export helper
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

SRP = rawget(_G, 'SRP') or {}

local function export(name, fn)
    SRP[name] = fn
    exports(name, fn)
end

SRP.Export = export

return SRP
