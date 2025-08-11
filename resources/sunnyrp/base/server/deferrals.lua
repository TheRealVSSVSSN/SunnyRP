-- srp_base: server/deferrals.lua
-- Authoritative connect flow:
-- 1) Validate identifiers (convars: srp_primary_identifier, srp_required_identifiers)
-- 2) Core-API POST /players/link (HMAC via SRP_HTTP.Fetch)
-- 3) Enforce bans / optional whitelist / optional verification
-- 4) Cache user -> Player module, hydrate perms, set statebags, put into loading bucket
-- 5) Hand off to identity/characters resource after deferral completes

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
    if k and val then
      map[k] = val
    end
  end
  return map
end

local function convarOr(name, default)
  local v = GetConvar(name, '')
  if v == '' then return default end
  return v
end

-- ConVars that affect gating
local REQ_IDS_CSV = convarOr('srp_required_identifiers', 'license,discord')     -- must be present
local PRIMARY_ID  = convarOr('srp_primary_identifier', 'license')               -- authoritative id
local WHITELIST   = (convarOr('srp_whitelist_enabled', 'false') == 'true')      -- optional
local REQUIRE_VER = (convarOr('srp_require_verification', 'false') == 'true')   -- optional
local DEBUG_DEF   = (convarOr('srp_deferrals_debug', 'false') == 'true')        -- optional console logs

-- helper for deferral progress + console log (optional)
local function step(deferrals, msg)
  if DEBUG_DEF then print(('[SRP:DEF] %s'):format(msg)) end
  deferrals.update(msg)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local src = source
  deferrals.defer()

  -- 1) Grab identifiers
  step(deferrals, 'Checking identifiers…')
  local ids = getIdentifiers(src)

  -- Validate required identifiers
  local missing = {}
  for _, need in ipairs(splitCsv(REQ_IDS_CSV)) do
    if (ids[need] == nil) or (ids[need] == '') then
      missing[#missing+1] = need
    end
  end
  if #missing > 0 then
    deferrals.done(('Connection blocked: missing required identifier(s): %s'):format(table.concat(missing, ', ')))
    CancelEvent()
    return
  end

  -- 2) Link or create player in Core-API
  step(deferrals, 'Linking your account…')
  local payload = {
    name = playerName or ('player:%d'):format(src),
    identifiers = ids,
    primary = ids[PRIMARY_ID],
    meta = {
      endpoint = ids.ip or '',
      build = GetConvar('sv_enforceGameBuild', 'unknown'),
      ts = os.time()
    }
  }

  local res = SRP_HTTP.Fetch('POST', '/players/link', payload, { retries = 1, timeout = 8000 })
  if not res.ok then
    -- Allow dev bypass if configured
    if SRP_Config.Dev and SRP_Config.Dev.fakeBackend then
      step(deferrals, 'Backend unavailable; dev bypass enabled.')
    else
      deferrals.done(('Core-API unavailable (%s). Please try again shortly.'):format(res.message or res.error or 'timeout'))
      CancelEvent()
      return
    end
  end

  local data = (res.data or {})  -- expected: { playerId, banned, banReason, verified, whitelisted, scopes }
  local playerId = data.playerId or data.id
  if not playerId and not (SRP_Config.Dev and SRP_Config.Dev.fakeBackend) then
    deferrals.done('Failed to create/link your account. (No playerId)')
    CancelEvent()
    return
  end

  -- 3) Enforce bans / whitelist / verification
  if data.banned == true then
    deferrals.done(('You are banned.%s'):format(data.banReason and (' Reason: ' .. tostring(data.banReason)) or ''))
    CancelEvent()
    return
  end

  if WHITELIST and (data.whitelisted ~= true) then
    deferrals.done('Whitelist only at this time. Please apply via our website/Discord.')
    CancelEvent()
    return
  end

  if REQUIRE_VER and (data.verified ~= true) then
    deferrals.done('Account not verified. Complete SMS/Discord verification to play.')
    CancelEvent()
    return
  end

  -- 4) Hydrate Player cache + perms
  step(deferrals, 'Finalizing session…')
  local P = exports['srp_base']:getModule('Player')
  -- Link caches (will store identifiers, verified, scopes in memory)
  local user, linkErr = P.Link(src, playerName)
  if not user then
    deferrals.done(('Internal link error: %s'):format(linkErr or 'unknown'))
    CancelEvent()
    return
  end

  -- Update perms cache if backend returned scopes
  if type(data.scopes) == 'table' then
    SRP_Perms.cache[src] = { playerId = playerId, scopes = data.scopes, ts = GetGameTimer() }
  else
    -- fallback fetch (async)
    P.RefreshPerms(src, playerId)
  end

  -- Set statebags (safe read-only hints for client/UI)
  -- Note: StateBags auto-sync to this player's client; for others we generally keep PII off state.
  local ped = GetPlayerPed(src)
  if ped and ped ~= 0 then
    Entity(ped).state:set('srp:playerId', playerId, true)
    Entity(ped).state:set('srp:verified', data.verified == true, true)
  end

  -- Loading bucket until identity/characters take over
  if SRP_Buckets and SRP_Buckets.ToLoading then
    SRP_Buckets.ToLoading(src)
  end

  -- 5) Done — allow join (spawn is blocked until character is selected)
  deferrals.done()
end)