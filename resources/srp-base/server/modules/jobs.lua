SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Jobs = {}

SRP.Modules.Jobs.stub = function()
  return { status = 501, message = 'Not implemented in failover path' }
end
