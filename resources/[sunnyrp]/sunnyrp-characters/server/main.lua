-- resources/sunnyrp/characters/server/main.lua

SRP = SRP or {}
SRP.Characters = SRP.Characters or {}
SRP.Characters.activeBySrc = SRP.Characters.activeBySrc or {}

-- Helper: read number convar with default
SRP.Characters.ReadIntConvar = function(name, def)
  local v = tonumber(GetConvar(name, tostring(def)))
  return v or def
end

-- Helper: link/resolve current user via Phase B endpoint
SRP.Characters.GetUserViaLink = function(src)
  -- Collect all identifiers (Phase A base provides SRP.GetPrimaryIdentifier)
  local _, all = SRP.GetPrimaryIdentifier(src)
  local ip = GetPlayerEndpoint(src) or ''
  all['ip'] = ip

  local res = SRP.Fetch({
    path = '/players/link',
    method = 'POST',
    body = { primary = SRP.Config.PrimaryIdentifier, ip = ip, identifiers = all }
  })

  if not res or res.status ~= 200 then return nil end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then return nil end
  return obj.data.user
end

-- Helper: fetch and send character list to NUI
SRP.Characters.SendCharList = function(src, userId)
  local res = SRP.Fetch({ path = '/characters?userId=' .. tostring(userId), method = 'GET' })
  if not res or res.status ~= 200 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Failed to fetch characters' })
    return
  end

  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Invalid response' })
    return
  end

  local maxSlots = SRP.Characters.ReadIntConvar('srp_max_characters', 3)
  TriggerClientEvent('srp:ui:charselect:data', src, { list = obj.data, maxSlots = maxSlots })
end

-- Public getter: active character id for a source (used by other modules e.g., Map)
SRP.Characters.GetActiveCharId = function(src)
  return SRP.Characters.activeBySrc and SRP.Characters.activeBySrc[src] or nil
end

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
  if SRP.Characters and SRP.Characters.activeBySrc then
    SRP.Characters.activeBySrc[source] = nil
  end
end)

-- ========== Events ==========

-- Open character select
RegisterNetEvent('srp:ui:open:charselect', function()
  local src = source
  local user = SRP.Characters.GetUserViaLink(src)
  if not user then
    DropPlayer(src, 'Identity error — please reconnect.')
    return
  end
  SRP.Characters.SendCharList(src, user.id)
end)

-- Create character
RegisterNetEvent('srp:characters:create', function(data)
  local src = source
  local user = SRP.Characters.GetUserViaLink(src)
  if not user then return DropPlayer(src, 'Identity error') end

  local payload = {
    userId     = user.id,
    first_name = tostring(data.first_name or 'John'),
    last_name  = tostring(data.last_name or 'Doe'),
    dob        = data.dob or nil,
    gender     = data.gender or nil
  }

  -- Pass slot limit & starting balances via headers (enforced server-authoritatively in backend)
  local res = SRP.Fetch({
    path   = '/characters',
    method = 'POST',
    body   = payload,
    headers = {
      ['X-SRP-Max-Slots']  = tostring(SRP.Characters.ReadIntConvar('srp_max_characters', 3)),
      ['X-SRP-Start-Cash'] = tostring(SRP.Characters.ReadIntConvar('srp_start_cash', 500)),
      ['X-SRP-Start-Bank'] = tostring(SRP.Characters.ReadIntConvar('srp_start_bank', 1500)),
    }
  })

  if not res or res.status ~= 200 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Create failed' })
    return
  end

  SRP.Characters.SendCharList(src, user.id)
end)

-- Delete character
RegisterNetEvent('srp:characters:delete', function(data)
  local src = source
  local user = SRP.Characters.GetUserViaLink(src)
  if not user then return DropPlayer(src, 'Identity error') end

  local charId = tonumber(data.characterId or 0)
  if not charId or charId <= 0 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Invalid character id' })
    return
  end

  local res = SRP.Fetch({
    path   = '/characters/' .. tostring(charId),
    method = 'DELETE',
    body   = { userId = user.id }
  })

  if not res or res.status ~= 200 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Delete failed' })
    return
  end

  -- If the deleted char was active, clear it
  if SRP.Characters.activeBySrc[src] == charId then
    SRP.Characters.activeBySrc[src] = nil
  end

  SRP.Characters.SendCharList(src, user.id)
end)

-- Select character -> canonical state -> spawn
RegisterNetEvent('srp:characters:select', function(data)
  local src = source
  local user = SRP.Characters.GetUserViaLink(src)
  if not user then return DropPlayer(src, 'Identity error') end

  local charId = tonumber(data.characterId or 0)
  if not charId or charId <= 0 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Invalid character id' })
    return
  end

  local res = SRP.Fetch({
    path   = '/characters/select',
    method = 'POST',
    body   = { userId = user.id, characterId = charId }
  })

  if not res or res.status ~= 200 then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Select failed' })
    return
  end

  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then
    TriggerClientEvent('srp:ui:charselect:data', src, { error = 'Select invalid response' })
    return
  end

  -- Decide spawn point: last known or default (LSIA arrivals safe area)
  local state = obj.data.state or {}
  local pos = state.position or { x = -1037.52, y = -2737.36, z = 20.17, heading = 330.0 }

  -- Optional routing bucket isolation on spawn
  local bucket = 0
  if GetConvar('srp_use_routing_buckets', 'false') == 'true' then
    bucket = math.random(1000, 9999)
  end

  -- Handoff to spawn manager (server will persist position & route client)
  TriggerEvent('srp:spawn:internal:spawn', src, {
    characterId   = charId,
    position      = pos,
    routing_bucket= bucket,
    character     = obj.data.character,
    accounts      = obj.data.accounts
  })

  -- Close NUI
  TriggerClientEvent('srp:ui:charselect:close', src)

  -- Track active character for this source (used by Map/Telemetry and any per-char modules)
  SRP.Characters.activeBySrc[src] = charId
end)