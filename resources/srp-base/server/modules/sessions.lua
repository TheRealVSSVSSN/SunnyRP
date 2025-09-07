SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Sessions = {}

--[[
    -- Type: Function
    -- Name: SRP.Modules.Sessions.stub
    -- Use: Stub during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
SRP.Modules.Sessions.stub = function()
  return { status = 501, message = 'Not implemented in failover path' }
end
