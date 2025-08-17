-- Server-side bind manager: persists binds per player/character to backend (server-only HTTP).
-- Clients register local commands; we store/display defaults + future UI sync.

SRP_Binds = SRP_Binds or {}
local cache = {} -- src -> { list = { {name, device, key, desc}... }, t = lastFetch }

local function loadFor(src, playerId, characterId)
  local path = ('/keybinds?playerId=%s%s'):format(playerId, characterId and ('&charId='..characterId) or '')
  local res = SRP_HTTP.Fetch('GET', path, nil, { retries = 1, timeout = 6000 })
  if res.ok then
    cache[src] = { list = res.data.binds or {}, t = GetGameTimer() }
    TriggerClientEvent('srp:binds:apply', src, cache[src].list)
  end
end

-- Called when player linked (deferrals) or character selected (other resource)
RegisterNetEvent('srp:binds:refresh', function(playerId, charId)
  local src = source
  loadFor(src, playerId, charId)
end)

-- Save (from a future NUI or client-side settings; placeholder API)
RegisterNetEvent('srp:binds:save', function(payload)
  local src = source
  local user = exports['srp_base']:getModule('Player').GetUser(src)
  if not user or not user.playerId then return end
  local body = {
    playerId = user.playerId,
    characterId = (exports['srp_base']:getModule('Player').GetVar(src, 'charId')),
    binds = payload or {}
  }
  local res = SRP_HTTP.Fetch('POST', '/keybinds/save', body, { retries = 1, timeout = 7000 })
  if res.ok then
    cache[src] = { list = body.binds, t = GetGameTimer() }
  end
end)

AddEventHandler('playerDropped', function() cache[source] = nil end)