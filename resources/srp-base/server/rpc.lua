SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.RPC = {}

function SRP.RPC.handle(env)
  if not env or not env.type then
    return { ok = false, error = 'invalid_envelope' }
  end
  local t = env.type
  if t == 'srp.base.characters.list' then
    return { ok = true, result = SRP.Modules.Base.charactersList(env.data.accountId) }
  elseif t == 'srp.base.characters.create' then
    return { ok = true, result = SRP.Modules.Base.charactersCreate(env.data.accountId, env.data.data, env.id) }
  elseif t == 'srp.base.characters.select' then
    return { ok = true, result = SRP.Modules.Base.charactersSelect(env.data.accountId, env.data.characterId) }
  elseif t == 'srp.base.characters.delete' then
    return { ok = true, result = SRP.Modules.Base.charactersDelete(env.data.accountId, env.data.characterId) }
  end
  return { ok = false, error = 'not_implemented' }
end
