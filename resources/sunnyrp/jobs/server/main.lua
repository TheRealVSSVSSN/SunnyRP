-- resources/sunnyrp/jobs/server/main.lua
SRP = SRP or {}
SRP.Jobs = SRP.Jobs or {}
local CFG = SRP.Jobs.Config

local Cache = {
  byChar = {},       -- [charId] = { code, grade, onDuty, hourly_cents }
  bySrc  = {},       -- [src] = charId
}

-- Helpers
local function activeChar(src)
  return SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
end
local function parseResp(res)
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.ok then return obj.data end
  end
  return nil
end

-- ===== Backend calls =====
local function loadState(charId)
  local r = SRP.Fetch({ path = '/jobs/state?charId='..tostring(charId), method='GET' })
  local data = parseResp(r)
  if not data or not data.job then
    Cache.byChar[charId] = { code='unemployed', grade=0, onDuty=false, hourly_cents=0 }
    return Cache.byChar[charId]
  end
  local def = data.def or {}
  Cache.byChar[charId] = {
    code = def.code or 'unemployed',
    grade = tonumber(data.job.grade or 0),
    onDuty = data.job.on_duty and true or false,
    hourly_cents = tonumber(data.hourly_cents or 0),
  }
  return Cache.byChar[charId]
end

local function setJob(charId, jobCode, grade)
  local r = SRP.Fetch({ path='/jobs/set', method='POST', body={ char_id=charId, job_code=jobCode, grade=grade } })
  local data = parseResp(r); if not data then return false end
  Cache.byChar[charId] = {
    code = data.def.code, grade = tonumber(data.job.grade), onDuty = false,
    hourly_cents = tonumber(data.hourly_cents or 0)
  }
  return true
end

local function setDuty(charId, onDuty)
  local r = SRP.Fetch({ path='/jobs/duty', method='POST', body={ char_id=charId, on_duty = onDuty } })
  local data = parseResp(r); if not data then return false end
  local c = Cache.byChar[charId] or {}
  c.onDuty = data.job.on_duty and true or false
  Cache.byChar[charId] = c
  return true
end

-- ===== Public SRP.Jobs API =====
SRP.Jobs.GetJobCode = function(src)
  local charId = activeChar(src); if not charId then return 'unemployed' end
  local c = Cache.byChar[charId]
  if not c then c = loadState(charId) end
  return c.code or 'unemployed'
end

SRP.Jobs.GetHourlyCentsFor = function(src)
  local charId = activeChar(src); if not charId then return 0 end
  local c = Cache.byChar[charId]
  if not c then c = loadState(charId) end
  -- pay only if duty_required satisfied (most jobs): if not on duty, zero pay
  if not c.onDuty then return 0 end
  return tonumber(c.hourly_cents or 0)
end

SRP.Jobs.IsOnDuty = function(src, jobCode)
  local charId = activeChar(src); if not charId then return false end
  local c = Cache.byChar[charId]
  if not c then c = loadState(charId) end
  if jobCode and c.code ~= jobCode then return false end
  return c.onDuty and true or false
end

SRP.Jobs.RequireJob = function(jobCode, minGrade, onDutyOnly)
  return function(src)
    local charId = activeChar(src); if not charId then return false, 'no character' end
    local c = Cache.byChar[charId] or loadState(charId)
    if c.code ~= jobCode then return false, 'wrong job' end
    if (minGrade or 0) > 0 and (c.grade or 0) < minGrade then return false, 'insufficient grade' end
    if onDutyOnly and not c.onDuty then return false, 'not on duty' end
    return true
  end
end

-- Convenience for other resources:
SRP.Jobs.Set = function(src, jobCode, grade)
  local charId = activeChar(src); if not charId then return false end
  return setJob(charId, jobCode, tonumber(grade or 0))
end

SRP.Jobs.Duty = function(src, on)
  local charId = activeChar(src); if not charId then return false end
  return setDuty(charId, on and true or false)
end

-- ===== Wiring / lifecycle =====
-- When a character becomes active (Phase C sets SRP.Characters.activeBySrc), refresh jobs
AddEventHandler('srp:spawn:internal:spawn', function(src, _spawnData)
  local charId = activeChar(src); if charId then Cache.bySrc[src] = charId; loadState(charId) end
end)

AddEventHandler('playerDropped', function()
  local src = source
  Cache.bySrc[src] = nil
  -- keep byChar (persists while server runs)
end)

-- Optional periodic refresh to pick up admin/job changes while online
CreateThread(function()
  while true do
    Wait(CFG.refreshMs)
    for _, src in ipairs(GetPlayers()) do
      local cid = activeChar(src)
      if cid then loadState(cid) end
    end
  end
end)

-- ===== Commands for quick testing =====
RegisterCommand('jobset', function(src, args)
  local code = tostring(args[1] or '')
  local grade = tonumber(args[2] or 0)
  local ok = SRP.Jobs.Set(src, code, grade)
  TriggerClientEvent('srp:notify', src, ok and ('Job set to '..code..'('..grade..')') or 'Job set failed')
end)

RegisterCommand('duty', function(src, args)
  local on = tostring(args[1] or 'toggle')
  if on == 'toggle' then
    local isOn = SRP.Jobs.IsOnDuty(src)
    on = not isOn
  else
    on = (on == 'on' or on == '1' or on == 'true')
  end
  local ok = SRP.Jobs.Duty(src, on)
  TriggerClientEvent('srp:notify', src, ok and (on and 'On duty' or 'Off duty') or 'Duty toggle failed')
end)