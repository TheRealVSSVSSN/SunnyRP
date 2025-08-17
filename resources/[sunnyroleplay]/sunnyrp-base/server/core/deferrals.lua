-- resources/[sunnyrp]/sunnyrp-base/server/core/deferrals.lua
-- Deferral flow: link player, verify ban/whitelist, ensure user exists/created.

local function idPair(typeName, value) return { type = typeName, value = value } end

local function collectIdentifiers(src)
  local ids = GetPlayerIdentifiers(src)
  local out = { license = nil, steam = nil, discord = nil, fivem = nil }
  for _,id in ipairs(ids or {}) do
    if id:sub(1,8) == 'license:' then out.license = id:sub(9)
    elseif id:sub(1,6) == 'steam:' then out.steam = id:sub(7)
    elseif id:sub(1,8) == 'discord:' then out.discord = id:sub(9)
    elseif id:sub(1,6) == 'fivem:' then out.fivem = id:sub(7)
    end
  end
  return out
end

local function canonicalHexId(idset)
  return idset.license or idset.steam or idset.fivem or idset.discord or ('p'..tostring(math.random(100000,999999)))
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local src = source
  deferrals.defer()
  deferrals.update('Linking your account...')

  if not SRP_HTTP or not SRP_HTTP.Fetch then
    deferrals.done('Service unavailable. Try again later.')
    return
  end

  local ids = collectIdentifiers(src)
  local linkPayload = {
    playerId = src,
    identifiers = {}
  }
  if ids.license then table.insert(linkPayload.identifiers, idPair('license', ids.license)) end
  if ids.steam then table.insert(linkPayload.identifiers, idPair('steam', ids.steam)) end
  if ids.discord then table.insert(linkPayload.identifiers, idPair('discord', ids.discord)) end
  if ids.fivem then table.insert(linkPayload.identifiers, idPair('community', ids.fivem)) end

  local linkRes = SRP_HTTP.Fetch('POST', '/v1/players/link', linkPayload, { retries = 0, timeout = 6000 })
  if not linkRes or not linkRes.ok then
    deferrals.done('Unable to link your account. Please retry.')
    return
  end

  if linkRes.data and linkRes.data.banned then
    local reason = (linkRes.data.banReason or 'You are banned.')
    deferrals.done(('Banned: %s'):format(reason))
    return
  end

  if SRP_CONFIG and SRP_CONFIG.whitelist and SRP_CONFIG.whitelist.enforce then
    if not (linkRes.data and linkRes.data.whitelisted) then
      deferrals.done(SRP_CONFIG.whitelist.message or 'Not whitelisted.')
      return
    end
  end

  -- ensure user exists / create if missing
  deferrals.update('Verifying your profile...')
  local hex = canonicalHexId(ids)
  local existsOk, exists = SRP_Users.Exists(hex)
  if not existsOk then
    deferrals.done('Could not verify user profile.')
    return
  end

  if not exists then
    local idents = {}
    if ids.license then table.insert(idents, idPair('license', ids.license)) end
    if ids.steam then table.insert(idents, idPair('steam', ids.steam)) end
    if ids.discord then table.insert(idents, idPair('discord', ids.discord)) end
    if ids.fivem then table.insert(idents, idPair('community', ids.fivem)) end

    local createRes = SRP_Users.Create(hex, playerName, idents, 'user')
    if not createRes or not createRes.ok then
      deferrals.done('Failed to initialize your user profile.')
      return
    end
  end

  deferrals.update('Welcome to SunnyRP!')
  deferrals.done()
end)