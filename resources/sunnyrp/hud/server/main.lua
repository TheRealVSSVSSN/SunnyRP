-- resources/sunnyrp/hud/server/main.lua
SRP = SRP or {}
SRP.HUD = SRP.HUD or {}
SRP.HUD.__last = SRP.HUD.__last or {}       -- per src last payload for coalescing
SRP.HUD.__vis  = SRP.HUD.__vis or {}         -- per src visibility map

local function getActive(src)
  local user = SRP.Identity.cacheBySrc[src] and SRP.Identity.cacheBySrc[src].user or nil
  local charId = SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return user, charId
end

local function send(src, action, payload)
  TriggerClientEvent('srp:hud:nui', src, action, payload or {})
end

-- Visibility API (per-item & groups)
SRP.HUD.ShowAll = function(src) send(src, 'visible:all', true) end
SRP.HUD.HideAll = function(src) send(src, 'visible:all', false) end

SRP.HUD.ShowGroup = function(src, group) send(src, 'visible:group', { group = group, show = true }) end
SRP.HUD.HideGroup = function(src, group) send(src, 'visible:group', { group = group, show = false }) end

SRP.HUD.ShowItem = function(src, item) send(src, 'visible:item', { item = item, show = true }) end
SRP.HUD.HideItem = function(src, item) send(src, 'visible:item', { item = item, show = false }) end

-- Push data deltas (server-authoritative)
SRP.HUD.Push = function(src, patch)
  send(src, 'hud:update', patch)
end

-- Initialize HUD after spawn
RegisterNetEvent('srp:spawn:done', function(init)
  local src = source
  if not SRP.HUD.Config.enabled then return end

  local user, charId = getActive(src)
  if not user or not charId then return end

  -- fetch status from backend
  local stRes = SRP.Fetch({ path = '/status/'..tostring(charId), method = 'GET' })
  local status = {}
  if stRes and stRes.status == 200 then
    local ok, obj = pcall(function() return json.decode(stRes.body or '{}') end)
    if ok and obj and obj.ok then status = obj.data or {} end
  end

  -- derive identity from caches (accounts from Phase C select or refresh later)
  local cash, bank = 0, 0
  if init and init.accounts then
    cash = tonumber(init.accounts.cash or 0) or 0
    bank = tonumber(init.accounts.bank or 0) or 0
  end

  local job, duty = (init and init.job) or 'Unemployed', (init and init.duty) or false

  SRP.HUD.__vis[src] = {
    vitals   = SRP.HUD.Config.visible.vitals,
    status   = SRP.HUD.Config.visible.status,
    identity = SRP.HUD.Config.visible.identity,
    voice    = SRP.HUD.Config.visible.voice,
  }

  -- initial push
  SRP.HUD.Push(src, {
    identity = { cash = cash, bank = bank, job = job, duty = duty },
    status = {
      hunger = status.hunger or 100,
      thirst = status.thirst or 100,
      stress = status.stress or 0,
      temperature = status.temperature or 50,
      wetness = status.wetness or 0,
      drug = status.drug or 0,
      alcohol = status.alcohol or 0
    }
  })

  -- tell client initial vis
  send(src, 'visible:init', SRP.HUD.__vis[src])
end)

-- Periodic status decay (server-authoritative via backend patch)
CreateThread(function()
  while true do
    Wait((SRP.HUD.Config.tickSeconds or 60) * 1000)
    for _, sid in ipairs(GetPlayers()) do
      local user, charId = getActive(tonumber(sid))
      if user and charId then
        -- simple survival decay; tune later
        local patch = { deltas = { hunger = -1.0, thirst = -1.5, stress = -0.2 } }
        SRP.Fetch({ path = '/status/'..tostring(charId)..'/patch', method = 'POST', body = patch })
        -- Fetch latest and push to client (low frequency)
        local stRes = SRP.Fetch({ path = '/status/'..tostring(charId), method = 'GET' })
        if stRes and stRes.status == 200 then
          local ok, obj = pcall(function() return json.decode(stRes.body or '{}') end)
          if ok and obj and obj.ok then
            SRP.HUD.Push(tonumber(sid), { status = obj.data })
          end
        end
      end
    end
  end
end)

-- Occasional balances refresh (if economy changes elsewhere)
CreateThread(function()
  while true do
    Wait(SRP.HUD.Config.accountsRefreshMs or 10000)
    for _, sid in ipairs(GetPlayers()) do
      local src = tonumber(sid)
      local charId = SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
      if charId then
        -- Assume a GET /inventory/accounts/:charId in future; for now skip or reuse select cache via an event
        -- Placeholder: ask other modules to emit updates; you can replace this with a backend call.
      end
    end
  end
end)

-- Public helpers other modules can call:
SRP.HUD.SetCash = function(src, v) SRP.HUD.Push(src, { identity = { cash = v } }) end
SRP.HUD.SetBank = function(src, v) SRP.HUD.Push(src, { identity = { bank = v } }) end
SRP.HUD.SetJob  = function(src, v) SRP.HUD.Push(src, { identity = { job  = v } }) end
SRP.HUD.SetDuty = function(src, v) SRP.HUD.Push(src, { identity = { duty = v and true or false } }) end

-- Visibility events for scripts/admin:
RegisterNetEvent('srp:hud:show',  function() SRP.HUD.ShowAll(source) end)
RegisterNetEvent('srp:hud:hide',  function() SRP.HUD.HideAll(source) end)
RegisterNetEvent('srp:hud:show:group', function(group) SRP.HUD.ShowGroup(source, tostring(group)) end)
RegisterNetEvent('srp:hud:hide:group', function(group) SRP.HUD.HideGroup(source, tostring(group)) end)
RegisterNetEvent('srp:hud:show:item', function(item) SRP.HUD.ShowItem(source, tostring(item)) end)
RegisterNetEvent('srp:hud:hide:item', function(item) SRP.HUD.HideItem(source, tostring(item)) end)

-- Optional: voice mode passthrough (another voice script can call this)
RegisterNetEvent('srp:voice:mode', function(mode) send(source, 'voice:mode', { mode = tostring(mode) }) end)

AddEventHandler('playerDropped', function()
  SRP.HUD.__last[source] = nil
  SRP.HUD.__vis[source] = nil
end)