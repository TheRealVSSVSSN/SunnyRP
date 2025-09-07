SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Sessions = {}

SRP.Modules.Sessions.stub = function()
  return { status = 501, message = 'Not implemented in failover path' }
end
