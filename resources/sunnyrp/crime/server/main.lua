-- resources/sunnyrp/crime/server/main.lua
SRP = SRP or {}
SRP.Crime = SRP.Crime or {}
local CFG = SRP.Crime.Config

local lastAttempt = {}   -- [slug] = os.time cooldown snapshot (server memory safeguard)

local function actorHeaders(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId']=tostring(uid or 0), ['X-SRP-CharId']=tostring(cid or 0) }
end

local function parseOK(res)
  if not res or res.status ~= 200 then return nil end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if ok and obj and obj.ok then return obj.data end
  return nil
end

-- === Heat helpers ===
local function addHeat(src, delta, reason)
  local ped = GetPlayerPed(src); local x,y,z = table.unpack(GetEntityCoords(ped))
  SRP.Fetch({ path='/crime/heat/add', method='POST', headers=actorHeaders(src),
    body = { amount = tonumber(delta), reason = tostring(reason or 'crime'), area = 'city', position = {x=x,y=y,z=z} } })
end

-- Decay loop (simple server tick)
CreateThread(function()
  while true do
    Wait((CFG.heatDecayTickS or 300) * 1000)
    for _, sid in ipairs(GetPlayers()) do
      SRP.Fetch({ path='/crime/heat/decay', method='POST', headers=actorHeaders(tonumber(sid)),
        body = { amount = CFG.Heat.decay or 1, area='city' } })
    end
  end
end)

-- === Simple robbery loop: 24/7 Register ===
-- Command for QA: /rob_reg 247_vanilla_reg1
RegisterCommand('rob_reg', function(src, args)
  local slug = tostring(args[1] or '247_vanilla_reg1')
  SRP.Crime.TryRobRegister(src, slug)
end)

-- Main entry
SRP.Crime.TryRobRegister = function(src, slug)
  -- check memory cooldown (fast path)
  local now = os.time()
  local t = lastAttempt[slug] or 0
  if now - t < 2 then return end -- prevent spam
  lastAttempt[slug] = now

  -- backend cooldown check and mark active
  local data = parseOK(SRP.Fetch({ path='/crime/heist/start', method='POST', body={ slug=slug } }))
  if not data then
    TriggerClientEvent('srp:notify', src, 'Register is on cooldown.')
    return
  end

  addHeat(src, CFG.Heat.onAttempt, 'register_attempt')
  -- ask client to lockpick; result comes back via event
  TriggerClientEvent('srp:crime:lockpick:start', src, { slug = slug, ms = CFG.lockpickBaseMs })
end

-- Result from client lockpick minigame
RegisterNetEvent('srp:crime:lockpick:result', function(payload)
  local src = source
  local ok = (payload and payload.ok) and true or false
  local slug = payload and payload.slug or 'unknown'
  if ok then
    -- roll loot on backend
    local loot = parseOK(SRP.Fetch({ path='/crime/loot/roll', method='POST', body={ table='register_247', rolls=1 } })) or { items = {} }
    -- give items (inventory Phase G)
    local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src)
    if cid then
      local idemBase = ('rob:%s:%s:%s'):format(slug, src, GetGameTimer())
      for _, it in ipairs(loot.items) do
        SRP.Fetch({
          path = '/inventory/'..tostring(cid)..'/add',
          method = 'POST',
          body = { item = it.code, count = it.qty, reason = 'register_loot', idempotencyKey = idemBase..':'..it.code }
        })
      end
    end
    addHeat(src, CFG.Heat.onSuccess, 'register_success')
    SRP.Fetch({ path:'/crime/heist/complete', method='POST', body={ slug = slug } })
    TriggerClientEvent('srp:notify', src, 'Register looted.')
  else
    addHeat(src, CFG.Heat.onFail, 'register_fail')
    SRP.Fetch({ path:'/crime/heist/complete', method='POST', body={ slug = slug } }) -- still cooldown the location
    TriggerClientEvent('srp:notify', src, 'Lockpick failed.')
  end
end)