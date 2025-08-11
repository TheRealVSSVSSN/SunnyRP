-- resources/sunnyrp/leoems/server/main.lua
SRP = SRP or {}
SRP.LeoEms = SRP.LeoEms or {}
local CFG = SRP.LeoEms.Config

local lastCallAt = {}  -- [src] = ms

-- Util
local function canCallNow(src)
  local now = GetGameTimer()
  local t = lastCallAt[src] or 0
  if (now - t) < CFG.dispatchRateLimitMs then return false end
  lastCallAt[src] = now
  return true
end

local function actorHeaders(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId'] = tostring(uid or 0), ['X-SRP-CharId'] = tostring(cid or 0) }
end

-- ===== /911 & /311 intake =====
RegisterNetEvent('srp:dispatch:call', function(kind, summary, meta)
  local src = source
  if not canCallNow(src) then return TriggerClientEvent('srp:notify', src, 'Please wait before sending another call.') end
  summary = tostring(summary or '')
  if summary == '' then return end

  local ped = GetPlayerPed(src)
  local x,y,z = table.unpack(GetEntityCoords(ped))
  local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
  local body = {
    kind = (kind == '311' and '311' or '911'),
    summary = summary,
    location = { x = x, y = y, z = z, street = street },
    metadata = meta or {}
  }
  local res = SRP.Fetch({ path = '/dispatch/call', method = 'POST', body = body, headers = actorHeaders(src) })
  if not res or res.status ~= 200 then return end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if ok and obj and obj.ok then
    -- Broadcast to on-duty units
    TriggerEvent('srp:dispatch:broadcast', obj.data)
  end
end)

-- ===== Broadcast new calls to units (police & ems) =====
AddEventHandler('srp:dispatch:broadcast', function(call)
  for _, sid in ipairs(GetPlayers()) do
    if SRP.Jobs and SRP.Jobs.IsOnDuty and (SRP.Jobs.IsOnDuty(sid, 'police') or SRP.Jobs.IsOnDuty(sid, 'ems')) then
      TriggerClientEvent('srp:dispatch:new', sid, call)
    end
  end
end)

-- ===== MDT endpoints (server -> backend) =====
SRP.LeoEms.CreateReport = function(src, payload)
  local res = SRP.Fetch({ path='/mdt/reports', method='POST', body=payload, headers=actorHeaders(src) })
  if res and res.status == 200 then local ok, obj = pcall(function() return json.decode(res.body) end); if ok and obj.ok then return obj.data end end
  return nil
end
SRP.LeoEms.ListReports = function(src, qstr)
  local res = SRP.Fetch({ path='/mdt/reports'..(qstr or ''), method='GET', headers=actorHeaders(src) })
  if res and res.status == 200 then local ok, obj = pcall(function() return json.decode(res.body) end); if ok and obj.ok then return obj.data end end
  return {}
end

-- ===== Unit attach/clear (from client MDT) =====
RegisterNetEvent('srp:dispatch:attach', function(callId, unitJob)
  local src = source
  if not (SRP.Jobs and (SRP.Jobs.IsOnDuty(src, 'police') or SRP.Jobs.IsOnDuty(src, 'ems'))) then return end
  local body = { call_id = tonumber(callId), unit_job = tostring(unitJob or 'police') }
  SRP.Fetch({ path='/dispatch/attach', method='POST', body=body, headers=actorHeaders(src) })
end)
RegisterNetEvent('srp:dispatch:clear', function(callId)
  local src = source
  if not (SRP.Jobs and (SRP.Jobs.IsOnDuty(src, 'police') or SRP.Jobs.IsOnDuty(src, 'ems'))) then return end
  SRP.Fetch({ path='/dispatch/clear', method='POST', body={ call_id = tonumber(callId) }, headers=actorHeaders(src) })
end)

-- ===== Cuff / Escort (basic) =====
SRP.LeoEms.Cuff = function(src, target)
  if not SRP.Jobs or not SRP.Jobs.RequireJob('police', 0, true)(src) then return end
  TriggerClientEvent('srp:police:cuff', target, src)
end
SRP.LeoEms.Escort = function(src, target) 
  if not SRP.Jobs or not SRP.Jobs.RequireJob('police', 0, true)(src) then return end
  TriggerClientEvent('srp:police:escort', target, src)
end

-- ===== EMS Revive (basic) =====
SRP.LeoEms.Revive = function(src, target)
  if not SRP.Jobs or not SRP.Jobs.RequireJob('ems', 0, true)(src) then return end
  TriggerClientEvent('srp:ems:revive', target)
end

-- Quick test commands (you can replace with menu/NUI later)
RegisterCommand('911', function(src, args) TriggerEvent('srp:dispatch:call', '911', table.concat(args,' '), {}) end)
RegisterCommand('311', function(src, args) TriggerEvent('srp:dispatch:call', '311', table.concat(args,' '), {}) end)
RegisterCommand('cuff', function(src, args) local t=tonumber(args[1] or 0); if t>0 then SRP.LeoEms.Cuff(src, t) end end)
RegisterCommand('escort', function(src, args) local t=tonumber(args[1] or 0); if t>0 then SRP.LeoEms.Escort(src, t) end end)
RegisterCommand('revivep', function(src, args) local t=tonumber(args[1] or 0); if t>0 then SRP.LeoEms.Revive(src, t) end end)

-- Job gate for MDT open
RegisterCommand('mdt', function(src)
  local allowPolice = SRP.Jobs and SRP.Jobs.IsOnDuty and SRP.Jobs.IsOnDuty(src, 'police')
  local allowEms    = SRP.Jobs and SRP.Jobs.IsOnDuty and SRP.Jobs.IsOnDuty(src, 'ems')
  local allowDoj    = SRP.Jobs and SRP.Jobs.IsOnDuty and SRP.Jobs.IsOnDuty(src, 'doj')
  if not (allowPolice or allowEms or allowDoj) then
    TriggerClientEvent('srp:notify', src, 'MDT access denied.')
    return
  end
  TriggerClientEvent('srp:notify', src, 'MDT opened.')
  TriggerClientEvent('srp:mdt:open', src)
end)

RegisterNetEvent('srp:mdt:list', function(q)
  local src = source
  -- limit by job if you want: police sees all, ems sees ems/incidents
  local qs = '?limit=50'
  if q and q.type then qs = qs .. '&type='..q.type end
  local res = SRP.Fetch({ path='/mdt/reports'..qs, method='GET', headers=actorHeaders(src) })
  local rows = {}
  if res and res.status == 200 then local ok,obj=pcall(function() return json.decode(res.body) end); if ok and obj.ok then rows = obj.data end end
  TriggerClientEvent('srp:mdt:list:resp', src, rows)
end)

RegisterNetEvent('srp:mdt:create', function(body)
  local src = source
  local out = SRP.LeoEms.CreateReport(src, {
    type = body.type or 'incident',
    title = tostring(body.title or 'Untitled'),
    body = tostring(body.body or ''),
    metadata = body.metadata or {}
  })
  TriggerClientEvent('srp:mdt:create:resp', src, out)
end)
