-- resources/[sunnyrp]/sunnyrp-base/server/integration/characters.lua
-- Lua wrappers for Characters endpoints.

SRP_Characters = SRP_Characters or {}

function SRP_Characters.List(owner_hex)
  local res = SRP_HTTP.Fetch('GET', '/v1/characters?owner_hex=' .. tostring(owner_hex), nil, { retries = 0 })
  return res
end

function SRP_Characters.Create(data)
  -- data: { owner_hex, first_name, last_name, dob?, gender?, story? }
  local res = SRP_HTTP.Fetch('POST', '/v1/characters', data, { retries = 0 })
  return res
end

function SRP_Characters.Get(id)
  local res = SRP_HTTP.Fetch('GET', '/v1/characters/' .. tostring(id), nil, { retries = 0 })
  return res
end

function SRP_Characters.Update(id, patch)
  local res = SRP_HTTP.Fetch('PATCH', '/v1/characters/' .. tostring(id), patch, { retries = 0 })
  return res
end

exports('CharactersList', SRP_Characters.List)
exports('CharactersCreate', SRP_Characters.Create)
exports('CharactersGet', SRP_Characters.Get)
exports('CharactersUpdate', SRP_Characters.Update)