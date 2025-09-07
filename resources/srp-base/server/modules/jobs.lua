SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Jobs = {}

--[[
    -- Type: Function
    -- Name: SRP.Modules.Jobs.stub
    -- Use: Stub during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
SRP.Modules.Jobs.stub = function()
  return { status = 501, message = 'Not implemented in failover path' }
end
