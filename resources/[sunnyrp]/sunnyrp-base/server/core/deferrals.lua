-- server/core/deferrals.lua
-- Aligns to /v1/players/link and handles standard envelope from backend.

local function splitCsv(s)
  local out = {}
  for token in string.gmatch(s or '', '([^,]+)') do
    out[#out+1] = (token:gsub('^%s*',''):gsub('%s*$',''))
  end
  return out
end

local function getIdentifiers(src)
  local ids = GetPlayerIdentifiers(src)
  local map = { ip = GetPlayerEndpoint(src) or '' }
  for _,v in ipairs(ids) do
    local k, val = v:match('([^:]+):(.*)')
    if k and val then map[k] = val end
  end
  return map
end

local function convarOr(name, default)
  local v = GetConvar(name, '')
  if v == '' then return default end
  return v
end

local REQ_IDS_CSV = convarOr('srp_required_identifiers', 'license,discord')
local PRIMARY_ID  = convarOr('srp_primary_identifier', 'license')
local WHITELIST   = (convarOr('srp_whitelist_enabled', 'false') == 'true')
local REQUIRE_VER = (convarOr('srp_require_verification', 'false') == 'true')
local DEBUG_DEF   = (convarOr('srp_deferrals_debug', 'false') == 'true')

local function step(deferrals, msg)
  if DEBUG_DEF then print(('[SRP:DEF] %s'):format(msg)) end
  deferrals.update(msg)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local src = source
  deferrals.defer()

  step(deferrals, 'Checking identifiers…')
  local ids = getIdentifiers(src)

  -- required identifiers
  local missing = {}
  for _, need in ipairs(splitCsv(REQ_IDS_CSV)) do
    if (ids[need] == nil) or (ids[need] == '') then
      missing[#missing+1] = need
    end
  end
  if #missing > 0 then
    deferrals.done(('Connection blocked: missing required identifier(s): %s'):format(table.concat(missing, ', ')))
    CancelEvent(); return
  end

  -- link / create
  step(deferrals, 'Linking your account…')
  local payload = {
    name = playerName or ('player:%d'):format(src),
    identifiers = ids,
    primary = ids[PRIMARY_ID],
    meta = { endpoint = ids.ip or '', ts = os.time() }
  }

  local res = SRP_HTTP.Fetch('POST', '/v1/players/link', payload, { retries = 1, timeout = 8000 })
  if not res.ok then
    if SRP_Config.Dev and SRP_Config.Dev.fakeBackend then
      step(deferrals, 'Backend unavailable; dev bypass enabled.')
    else
      deferrals.done(('Core-API unavailable (%s). Try again soon.'):format(res.message or res.error or 'timeout'))
      CancelEvent(); return
    end
  end

  local data = res.data or {}
  local playerId = data.playerId or data.id
  if not playerId and not (SRP_Config.Dev and SRP_Config.Dev.fakeBackend) then
    deferrals.done('Failed to create/link your account. (No playerId)')
    CancelEvent(); return
  end

  -- gates
  if data.banned == true then
    deferrals.done(('You are banned.%s'):format(data.banReason and (' Reason: ' .. tostring(data.banReason)) or ''))
    CancelEvent(); return
  end
  if WHITELIST and (data.whitelisted ~= true) then
    deferrals.done('Whitelist only at this time. Apply via website/Discord.')
    CancelEvent(); return
  end
  if REQUIRE_VER and (data.verified ~= true) then
    deferrals.done('Account not verified. Complete SMS/Discord verification to play.')
    CancelEvent(); return
  end

  -- hydrate player cache
  step(deferrals, 'Finalizing session…')
  local P = exports['sunnyrp-base']:getModule('Player')
  local user, linkErr = P.Link(src, playerName)
  if not user then
    deferrals.done(('Internal link error: %s'):format(linkErr or 'unknown'))
    CancelEvent(); return
  end

  -- perms cache
  if type(data.scopes) == 'table' then
    SRP_Perms.cache[src] = { playerId = playerId, scopes = data.scopes, ts = GetGameTimer() }
  else
    P.RefreshPerms(src, playerId)
  end

  -- statebag hints
  local ped = GetPlayerPed(src)
  if ped and ped ~= 0 then
    Entity(ped).state:set('srp:playerId', playerId, true)
    Entity(ped).state:set('srp:verified', data.verified == true, true)
  end

  -- loading bucket if available
  if SRP_Buckets and SRP_Buckets.ToLoading then
    SRP_Buckets.ToLoading(src)
  end

  deferrals.done()
end)