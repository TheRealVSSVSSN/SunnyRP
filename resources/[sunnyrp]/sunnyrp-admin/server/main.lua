-- resources/sunnyrp/admin/server/main.lua
SRP = SRP or {}
SRP.Admin = SRP.Admin or {}
local CFG = SRP.Admin.Config

local lastActionAt = {}          -- [src][action] = time
local function now() return GetGameTimer() end

-- === Helpers ===
local function activeChar(src)
  return SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
end
local function userIdFor(src)
  -- Phase B helper reused:
  local user = SRP.GetUserBySrc and SRP.GetUserBySrc(src)
  if user and user.id then return user.id end
  -- fallback: link
  local res = SRP.Fetch({ path='/players/link', method='POST', body={ primary = SRP.Config.PrimaryIdentifier, ip = GetPlayerEndpoint(src) or '', identifiers = (select(2, SRP.GetPrimaryIdentifier(src))) } })
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  return ok and obj and obj.data and obj.data.user and obj.data.user.id or nil
end

local function hasScope(src, scope)
  if SRP.Permissions and SRP.Permissions.HasScope then return SRP.Permissions.HasScope(src, scope) end
  -- fallback: ask backend
  local uid = userIdFor(src); if not uid then return false end
  local res = SRP.Fetch({ path='/permissions/'..tostring(uid), method='GET' })
  if not res or res.status ~= 200 then return false end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then return false end
  local scopes = obj.data or {}
  for _, s in ipairs(scopes) do if s == scope then return true end end
  return false
end

local function cooldownOK(src, action)
  local t = lastActionAt[src] and lastActionAt[src][action] or 0
  if now() - t < CFG.cooldownMs then return false end
  lastActionAt[src] = lastActionAt[src] or {}
  lastActionAt[src][action] = now()
  return true
end

-- === Presence heartbeat (for /admin/players UI) ===
CreateThread(function()
  while true do
    Wait(CFG.presenceHeartbeatMs)
    for _, sid in ipairs(GetPlayers()) do
      local charId = activeChar(sid)
      local name = GetPlayerName(sid) or ('ID '..sid)
      local health = GetEntityHealth(GetPlayerPed(sid))
      local ped = GetPlayerPed(sid)
      local x,y,z = table.unpack(GetEntityCoords(ped))
      local veh = GetVehiclePedIsIn(ped,false) ~= 0
      local jobCode = (SRP.Jobs and SRP.Jobs.GetJobCode and SRP.Jobs.GetJobCode(sid)) or 'unemployed'
      SRP.Fetch({
        path='/admin/players/heartbeat',
        method='POST',
        body={ user_id = userIdFor(sid), char_id = charId, src = tostring(sid), name = name,
               job_code = jobCode, position = {x=x,y=y,z=z}, health = health, in_vehicle = veh }
      })
    end
  end
end)

-- === Preflight with backend + execute ===
local function adminPreflight(src, action, payload)
  if not cooldownOK(src, action) then
    TriggerClientEvent('srp:notify', src, 'Cooldown...')
    return false, nil
  end
  local scope = CFG.ScopeMap[action]; if not scope then return false, nil end
  if not hasScope(src, scope) then
    TriggerClientEvent('srp:notify', src, 'No permission: '..scope)
    return false, nil
  end
  local uid = userIdFor(src)
  local cid = activeChar(src)
  local res = SRP.Fetch({
    path='/admin/actions/'..action,
    method='POST',
    body={
      actor_user_id = uid, actor_char_id = cid,
      target_src = payload and payload.target_src or nil,
      params = payload or {}
    }
  })
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.data and obj.ok then
      return true, obj.data.audit_id
    end
  end
  return false, nil
end

local function adminComplete(auditId, status, code, msg)
  SRP.Fetch({ path='/admin/actions/complete', method='POST', body={ audit_id = auditId, status = status, result_code = code, result_message = msg } })
end

-- === Server-executed actions ===

RegisterNetEvent('srp:admin:action', function(action, data)
  local src = source
  data = data or {}
  local ok, auditId = adminPreflight(src, action, data)
  if not ok then return end

  -- Dispatch effects
  if action == 'goto' then
    -- ask actor client to goto target
    TriggerClientEvent('srp:admin:client:goto', src, tonumber(data.target_src))
    adminComplete(auditId, 'success', 'OK', 'goto issued')

  elseif action == 'bring' then
    -- ask target client to move to actor
    TriggerClientEvent('srp:admin:client:bring', tonumber(data.target_src or 0), src)
    adminComplete(auditId, 'success', 'OK', 'bring issued')

  elseif action == 'spectate' then
    TriggerClientEvent('srp:admin:client:spectate', src, tonumber(data.target_src))
    adminComplete(auditId, 'success', 'OK', 'spectate toggle')

  elseif action == 'noclip' then
    TriggerClientEvent('srp:admin:client:noclip', src)
    adminComplete(auditId, 'success', 'OK', 'noclip toggle')

  elseif action == 'cleanup' then
    -- cleanup around actor (vehicles & peds)
    local radius = tonumber(data.radius or 120.0)
    TriggerClientEvent('srp:admin:client:cleanup', -1, src, radius)
    adminComplete(auditId, 'success', 'OK', ('cleanup radius=%s'):format(radius))

  elseif action == 'kick' then
    local tgt = tonumber(data.target_src or 0)
    if tgt > 0 then
      DropPlayer(tgt, data.reason or 'Kicked by admin')
      adminComplete(auditId, 'success', 'OK', 'kicked '..tostring(tgt))
    else
      adminComplete(auditId, 'error', 'BAD_TARGET', 'No target')
    end

  elseif action == 'ban' then
    local tgt = tonumber(data.target_src or 0)
    if tgt > 0 then
      -- collect identifiers
      local _, ids = SRP.GetPrimaryIdentifier(tgt)
      SRP.Fetch({ path='/admin/ban', method='POST', body={ identifiers = ids, reason = data.reason or 'Banned', expires_at = data.expires_at or nil } })
      DropPlayer(tgt, 'Banned: '..tostring(data.reason or ''))
      adminComplete(auditId, 'success', 'OK', 'banned '..tostring(tgt))
    else
      adminComplete(auditId, 'error', 'BAD_TARGET', 'No target')
    end

  else
    adminComplete(auditId, 'error', 'UNSUPPORTED', 'No handler')
  end
end)

-- Open the panel
RegisterCommand('admin', function(src)
  if hasScope(src, 'admin.audit') or hasScope(src, 'admin.teleport') or hasScope(src, 'admin.spectate') then
    TriggerClientEvent('srp:admin:open', src)
  else
    TriggerClientEvent('srp:notify', src, 'No admin access')
  end
end)

-- NUI callbacks (RegisterNUICallback stubs on client already post)
RegisterNetEvent('srp:admin:requestPlayers', function()
  local src = source
  -- Ask backend for presence list
  local res = SRP.Fetch({ path='/admin/players', method='GET' })
  local data = {}
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.ok then data = obj.data end
  end
  TriggerClientEvent('srp:admin:players', src, data)
end)