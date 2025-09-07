SRP = SRP or {}

local rawExports = exports

--[[
    -- Type: Function
    -- Name: SRP.Export
    -- Use: Register a global export
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Export(name, fn)
  SRP[name] = fn
  if rawExports and type(rawExports) == 'function' then
    rawExports(name, fn)
  end
end

--[[
    -- Type: Function
    -- Name: exports
    -- Use: Alias to SRP.Export
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function exports(name, fn)
  SRP.Export(name, fn)
end
