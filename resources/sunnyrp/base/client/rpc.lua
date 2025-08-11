-- SRP RPC (client half) — provides Register/Execute to server with timeouts
SRP_RPC = SRP_RPC or {}
local nextId = 1
local pending = {}   -- id -> { resolve=?, reject=?, t0, timeout }

local function genId()
  nextId = nextId + 1
  return ('c%05d_%d'):format(nextId, math.random(1000,9999))
end

local handlers = {}  -- name -> function(...)

-- Register a client RPC that the server can call
function SRP_RPC.Register(name, fn)
  handlers[name] = fn
end

-- Server -> Client request
RegisterNetEvent('srp:rpc:client:req')
AddEventHandler('srp:rpc:client:req', function(id, name, args)
  local ok, res = pcall(function()
    local fn = handlers[name]
    if not fn then error(('RPC client handler missing: %s'):format(name)) end
    return fn(table.unpack(args or {}))
  end)
  if ok then
    TriggerServerEvent('srp:rpc:client:res', id, true, res)
  else
    TriggerServerEvent('srp:rpc:client:res', id, false, tostring(res))
  end
end)

-- Client -> Server execute
function SRP_RPC.Execute(name, timeoutMs, ...)
  local id = genId()
  local p = promise.new()
  pending[id] = { p = p, t0 = GetGameTimer(), timeout = timeoutMs or 8000 }
  TriggerServerEvent('srp:rpc:server:req', id, name, { ... })
  return Citizen.Await(p)
end

RegisterNetEvent('srp:rpc:server:res')
AddEventHandler('srp:rpc:server:res', function(id, ok, payload)
  local req = pending[id]
  if not req then return end
  pending[id] = nil
  if ok then req.p:resolve(payload) else req.p:reject(payload) end
end)

-- Timeout loop
CreateThread(function()
  while true do
    Wait(250)
    local now = GetGameTimer()
    for id,req in pairs(pending) do
      if now - (req.t0 or now) > (req.timeout or 8000) then
        pending[id] = nil
        req.p:reject('RPC_TIMEOUT')
      end
    end
  end
end)

-- NP-compat global
if SRP_Config and SRP_Config.Dev and SRP_Config.Dev.exposeRPCGlobal then
  RPC = {
    register = SRP_RPC.Register,
    execute = function(name, ...)
      local ok, res = pcall(SRP_RPC.Execute, name, 8000, ...)
      if ok then return res end
      error(res)
    end
  }
end

exports('RPCRegister', SRP_RPC.Register)
exports('RPCExecute', function(name, timeoutMs, ...) return SRP_RPC.Execute(name, timeoutMs, ...) end)