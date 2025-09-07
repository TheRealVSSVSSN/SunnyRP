SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.World = {}

--[[
    -- Type: Function
    -- Name: SRP.Modules.World.stub
    -- Use: Stub during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
SRP.Modules.World.stub = function()
  return { status = 501, message = 'Not implemented in failover path' }
end
