-- resources/sunnyrp/telemetry/server/main.lua
SRP = SRP or {}
SRP.Telemetry = SRP.Telemetry or {}
local CFG = SRP.Telemetry.Config

local prev = {}              -- [src] = { pos=vector3, time=ms }
local lastAlert = {}         -- [src-kind] = os.time() last alert second
local lastHttp = {}          -- post rate limiter per src

local function tooSoon(src)
  local now = GetGameTimer()
  if (now - (lastHttp[src] or 0)) < CFG.postRateMs then return true end
  lastHttp[src] = now; return false
end

local function headersFor(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId']=tostring(uid or 0), ['X-SRP-CharId']=tostring(cid or 0) }
end

local function postTelemetry(src, body)
  if tooSoon(src) then return end
  SRP.Fetch({ path='/telemetry/events', method='POST', headers=headersFor(src), body=body })
end

local function alertStaff(kind, sev, msg, meta)
  -- Queue alert in backend; SRP.Admin/Chat can subscribe via polling route.
  SRP.Fetch({ path='/telemetry/anomaly', method='POST', body={ kind=kind, meta=meta }, headers={ } })
  -- Also bubble to any online staff (requires Phase K scopes on your server chat/notify)
  TriggerEvent('srp:staff:alert:broadcast', { kind=kind, severity=sev, message=msg, meta=meta })
end

local function shouldAlert(src, kind)
  local key = (src..':'..kind)
  local now = os.time()
  if (now - (lastAlert[key] or 0)) < CFG.alertRepeatS then return false end
  lastAlert[key] = now; return true
end

-- Main sample intake from clients
RegisterNetEvent('srp:telemetry:simple:note', function(k, m)
  -- utility hook to record arbitrary notes, if you need them later
  local src = source
  postTelemetry(src, { type='custom', subcategory=k, payload=m })
end)

RegisterNetEvent('srp:telemetry:sample', function(sample)
  local src = source
  local ped = GetPlayerPed(src)
  if not DoesEntityExist(ped) then return end

  local pos = sample and sample.pos or {x=0,y=0,z=0}
  local cur = vector3(pos.x+0.0, pos.y+0.0, pos.z+0.0)
  local onFoot = sample and sample.onFoot or true
  local speedClient = tonumber(sample and sample.speed or 0.0) or 0.0

  local prevData = prev[src]
  prev[src] = { pos = cur, time = GetGameTimer() }

  -- Basic telemetry event (thin)
  postTelemetry(src, { type='movement', subcategory='tick', payload = { pos=pos, onFoot=onFoot, sp=math.floor(speedClient*100)/100 } })

  if not prevData then return end
  local dt = (GetGameTimer() - prevData.time) / 1000.0; if dt <= 0 then dt = 0.001 end
  local dist = #(cur - prevData.pos)
  local mps = dist / dt

  -- Teleport detector
  if dist >= CFG.tpThreshold and shouldAlert(src, 'teleport') then
    alertStaff('teleport', 3, ('Teleport? Δ=%.1fm'):format(dist), { value=dist, dt=dt, from={x=prevData.pos.x,y=prevData.pos.y,z=prevData.pos.z}, to=pos })
  end

  -- Speed cap check
  local veh = GetVehiclePedIsIn(ped, false)
  local cap = veh ~= 0 and CFG.vehMax or CFG.footMax
  if mps > cap and shouldAlert(src, 'speed') then
    alertStaff('speed', (veh~=0) and 2 or 3, ('Speed anomaly: %.1fm/s (cap %.1f)'):format(mps, cap), { value=mps, cap=cap, onFoot=onFoot })
  end
end)

-- === Staff alert polling loop (backend -> server -> staff)
-- This lets staff get real-time alerts without websockets.
CreateThread(function()
  local sinceId = 0
  while true do
    Wait(3000)
    local res = SRP.Fetch({ path='/admin/alerts?sinceId='..tostring(sinceId), method='GET' })
    if res and res.status == 200 then
      local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
      if ok and obj and obj.ok then
        local list = obj.data or {}
        for _, a in ipairs(list) do
          sinceId = math.max(sinceId, tonumber(a.id or 0))
          if a.kind == 'anomaly' and not a.ack then
            -- Broadcast to connected staff (tie into your chat/notify and ACL)
            TriggerEvent('srp:staff:alert:broadcast', { id=a.id, kind=a.kind, severity=a.severity, message=a.message, meta=a.meta })
          end
        end
      end
    end
  end
end)