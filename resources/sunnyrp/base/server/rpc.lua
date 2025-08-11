-- SRP RPC (server half) — client<->server requests with optional ACL
SRP_RPC = SRP_RPC or {}

local serverHandlers = {}  -- name -> { fn, scope? }

-- Clients call server: register a server handler
function SRP_RPC.Register(name, fn, opts)
  serverHandlers[name] = { fn = fn, scope = opts and opts.scope or nil }
end

-- Client -> Server request
RegisterNetEvent('srp:rpc:server:req')
AddEventHandler('srp:rpc:server:req', function(id, name, args)
  local src = source
  local entry = serverHandlers[name]
  if not entry then
    TriggerClientEvent('srp:rpc:server:res', src, id, false, 'RPC_NOT_FOUND')
    return
  end
  -- ACL check if configured
  if entry.scope and not exports['srp_base']:HasScope(src, entry.scope) then
    TriggerClientEvent('srp:rpc:server:res', src, id, false, 'RPC_DENIED')
    return
  end
  local ok, res = pcall(entry.fn, src, table.unpack(args or {}))
  if ok then
    TriggerClientEvent('srp:rpc:server:res', src, id, true, res)
  else
    TriggerClientEvent('srp:rpc:server:res', src, id, false, tostring(res))
  end
end)

-- Server -> Client execute
function SRP_RPC.ExecuteClient(target, name, timeoutMs, ...)
  local id = ('s%05d_%d'):format(math.random(1,99999), math.random(1000,9999))
  local p = promise.new()
  local key = ('srp:rpc:server:cb:%s'):format(id)

  local timer = SetTimeout(timeoutMs or 8000, function()
    RemoveEventHandler(key)
    p:reject('RPC_TIMEOUT')
  end)

  local eh
  eh = RegisterNetEvent(key)
  AddEventHandler(key, function(ok, payload)
    if timer then ClearTimeout(timer) end
    RemoveEventHandler(eh)
    if ok then p:resolve(payload) else p:reject(payload) end
  end)

  TriggerClientEvent('srp:rpc:client:req', target, id, name, { ... })

  -- client will respond on 'srp:rpc:client:res' → we map it back to this key
  RegisterNetEvent('srp:rpc:client:res')
  AddEventHandler('srp:rpc:client:res', function(respId, ok, payload)
    if respId ~= id then return end
    if timer then ClearTimeout(timer) end
    RemoveEventHandler(eh)
    p:resolve(ok and payload or ('RPC_ERROR: '..tostring(payload)))
  end)

  return Citizen.Await(p)
end

exports('RPCRegister', SRP_RPC.Register)
exports('RPCExecuteClient', function(target, name, timeoutMs, ...) return SRP_RPC.ExecuteClient(target, name, timeoutMs, ...) end)