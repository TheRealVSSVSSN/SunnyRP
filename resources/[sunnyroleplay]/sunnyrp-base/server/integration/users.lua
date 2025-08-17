-- resources/[sunnyrp]/sunnyrp-base/server/integration/users.lua
-- Lua wrappers for Users & Identity endpoints.

SRP_Users = SRP_Users or {}

local function idPair(typeName, value)
  return { type = typeName, value = value }
end

local function collectIdentifiers(src)
  local ids = GetPlayerIdentifiers(src)
  local out = { license = nil, steam = nil, discord = nil, fivem = nil, ip = nil }
  for _,id in ipairs(ids or {}) do
    if id:sub(1,8) == 'license:' then out.license = id:sub(9)
    elseif id:sub(1,6) == 'steam:' then out.steam = id:sub(7)
    elseif id:sub(1,8) == 'discord:' then out.discord = id:sub(9)
    elseif id:sub(1,6) == 'fivem:' then out.fivem = id:sub(7)
    elseif id:sub(1,3) == 'ip:' then out.ip = id:sub(4)
    end
  end
  return out
end

local function canonicalHexId(idset)
  -- Prefer license, else steam, else fivem, else discord
  return idset.license or idset.steam or idset.fivem or idset.discord or 'unknown'
end

function SRP_Users.LinkPlayer(src)
  local idset = collectIdentifiers(src)
  local payload = {
    playerId = src,
    identifiers = {}
  }
  if idset.license then table.insert(payload.identifiers, idPair('license', idset.license)) end
  if idset.steam then table.insert(payload.identifiers, idPair('steam', idset.steam)) end
  if idset.discord then table.insert(payload.identifiers, idPair('discord', idset.discord)) end
  if idset.fivem then table.insert(payload.identifiers, idPair('community', idset.fivem)) end

  local res = SRP_HTTP.Fetch('POST', '/v1/players/link', payload, { retries = 0 })
  return res
end

function SRP_Users.Exists(hex_id)
  local res = SRP_HTTP.Fetch('GET', '/v1/users/exists?hex_id=' .. tostring(hex_id), nil, { retries = 0 })
  if res and res.ok then
    return true, (res.data and res.data.exists) or false
  end
  return false, res and (res.message or res.error) or 'request_failed'
end

function SRP_Users.Create(hex_id, name, identifiers, rank)
  local payload = {
    hex_id = hex_id,
    name = name,
    rank = rank or 'user',
    identifiers = identifiers or {}
  }
  local res = SRP_HTTP.Fetch('POST', '/v1/users', payload, { retries = 0 })
  return res
end

function SRP_Users.Get(hex_id)
  local res = SRP_HTTP.Fetch('GET', '/v1/users/' .. tostring(hex_id), nil, { retries = 0 })
  return res
end

exports('UsersLink', SRP_Users.LinkPlayer)
exports('UsersExists', SRP_Users.Exists)
exports('UsersCreate', SRP_Users.Create)
exports('UsersGet', SRP_Users.Get)
exports('CanonicalHexId', canonicalHexId)
exports('CollectIdentifiers', collectIdentifiers)