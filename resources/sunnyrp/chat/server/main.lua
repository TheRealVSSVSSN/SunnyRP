-- resources/sunnyrp/chat/server/main.lua
SRP = SRP or {}
SRP.Chat = SRP.Chat or {}
SRP.Chat.__cooldowns = SRP.Chat.__cooldowns or {} -- [src][channel]=lastMs

local function nowMs() return GetGameTimer() end

local function hasScope(src, scope)
  local id = SRP.Identity and SRP.Identity.cacheBySrc and SRP.Identity.cacheBySrc[src]
  if not id or not id.scopes then return false end
  for _, s in ipairs(id.scopes) do if s == scope then return true end end
  return false
end

local function throttle(src, channel, delay)
  SRP.Chat.__cooldowns[src] = SRP.Chat.__cooldowns[src] or {}
  local last = SRP.Chat.__cooldowns[src][channel] or 0
  local n = nowMs()
  if n - last < delay then return false end
  SRP.Chat.__cooldowns[src][channel] = n
  return true
end

local function sanitize(s)
  if not s then return '' end
  s = tostring(s)
  s = s:gsub('[%z\1-\8\11-\31\127]', '')   -- control chars
  s = s:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
  if #s > 300 then s = s:sub(1, 300) end
  return s
end

local PROFANITY = { 'fuck','shit','bitch','asshole' }
local function filterProfanity(s)
  if not SRP.Chat.Config.profanity then return s end
  local out = s
  for _, w in ipairs(PROFANITY) do
    local pattern = '%f[%w]' .. w .. '%f[%W]'
    out = out:gsub(pattern, string.rep('*', #w))
    out = out:gsub(pattern:upper(), string.rep('*', #w))
  end
  return out
end

-- broadcast helpers
local function getRecipientsInRange(src, range)
  local recipients = {}
  local srcPed = GetPlayerPed(src)
  if not srcPed or srcPed == 0 then return recipients end
  local sx, sy, sz = table.unpack(GetEntityCoords(srcPed))
  local range2 = range * range
  for _, pid in ipairs(GetPlayers()) do
    local ped = GetPlayerPed(pid)
    if ped and ped ~= 0 then
      local x, y, z = table.unpack(GetEntityCoords(ped))
      local dx, dy, dz = x - sx, y - sy, z - sz
      local dist2 = dx*dx + dy*dy + dz*dz
      if dist2 <= range2 then table.insert(recipients, pid) end
    end
  end
  return recipients, vector3(sx, sy, sz)
end

local function sendToClients(recipients, payload)
  for _, pid in ipairs(recipients) do
    TriggerClientEvent('srp:chat:message', pid, payload)
  end
end

-- log to backend
local function logToBackend(src, channel, message, pos)
  local user = SRP.Identity.cacheBySrc[src] and SRP.Identity.cacheBySrc[src].user
  local charId = SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  if not user then return end
  local body = {
    userId = user.id,
    characterId = charId,
    channel = channel,
    message = message,
    position = pos and { x = pos.x + 0.0, y = pos.y + 0.0, z = pos.z + 0.0, heading = 0.0 } or nil,
    routing_bucket = GetPlayerRoutingBucket(src),
    src = src
  }
  SRP.Fetch({ path = '/chat/log', method = 'POST', body = body, headers = { ['X-Profanity'] = SRP.Chat.Config.profanity and 'true' or 'false' } })
end

-- Public API (other scripts could reuse)
SRP.Chat.SendLocal = function(src, text)
  if not throttle(src, 'local', SRP.Chat.Config.rate.general) then return end
  local msg = filterProfanity(sanitize(text))
  local recips, pos = getRecipientsInRange(src, SRP.Chat.Config.rangeLocal)
  sendToClients(recips, { channel='local', from=src, text=msg })
  logToBackend(src, 'local', msg, pos)
end

SRP.Chat.SendOOC = function(src, text)
  if not SRP.Chat.Config.oocEnabled then return end
  if not throttle(src, 'ooc', SRP.Chat.Config.rate.ooc) then return end
  local msg = filterProfanity(sanitize(text))
  sendToClients(GetPlayers(), { channel='ooc', from=src, text=msg })
  logToBackend(src, 'ooc', msg, nil)
end

SRP.Chat.SendMe = function(src, text)
  if not throttle(src, 'me', SRP.Chat.Config.rate.me_do) then return end
  local msg = filterProfanity(sanitize(text))
  local recips, pos = getRecipientsInRange(src, SRP.Chat.Config.rangeMeDo)
  sendToClients(recips, { channel='me', from=src, text=msg })
  logToBackend(src, 'me', msg, pos)
end

SRP.Chat.SendDo = function(src, text)
  if not throttle(src, 'do', SRP.Chat.Config.rate.me_do) then return end
  local msg = filterProfanity(sanitize(text))
  local recips, pos = getRecipientsInRange(src, SRP.Chat.Config.rangeMeDo)
  sendToClients(recips, { channel='do', from=src, text=msg })
  logToBackend(src, 'do', msg, pos)
end

SRP.Chat.SendStaff = function(src, text)
  local scope = SRP.Chat.Config.staffScope
  if not hasScope(src, scope) then return end
  if not throttle(src, 'staff', SRP.Chat.Config.rate.staff) then return end
  local msg = sanitize(text) -- staff may bypass profanity filter for accuracy
  local targets = {}
  for _, pid in ipairs(GetPlayers()) do
    if hasScope(pid, scope) then table.insert(targets, pid) end
  end
  sendToClients(targets, { channel='staff', from=src, text=msg })
  logToBackend(src, 'staff', msg, nil)
end

-- Command dispatcher (server authoritative)
RegisterCommand('me', function(src, args) SRP.Chat.SendMe(src, table.concat(args, ' ')) end, false)
RegisterCommand('do', function(src, args) SRP.Chat.SendDo(src, table.concat(args, ' ')) end, false)
RegisterCommand('ooc', function(src, args) SRP.Chat.SendOOC(src, table.concat(args, ' ')) end, false)
RegisterCommand('staff', function(src, args) SRP.Chat.SendStaff(src, table.concat(args, ' ')) end, false)

-- NUI submit (plain text -> inferred channel: default local; allow /me,/do,/ooc,/staff prefix)
RegisterNetEvent('srp:chat:submit', function(payload)
  local src = source
  local text = sanitize(payload and payload.text or '')
  if text == '' then return end
  if text:sub(1,1) == '/' then
    local cmd, rest = text:match('^/(%S+)%s*(.*)$')
    cmd = (cmd or ''):lower()
    if cmd == 'me' then return SRP.Chat.SendMe(src, rest)
    elseif cmd == 'do' then return SRP.Chat.SendDo(src, rest)
    elseif cmd == 'ooc' then return SRP.Chat.SendOOC(src, rest)
    elseif cmd == 'staff' then return SRP.Chat.SendStaff(src, rest)
    else
      -- unknown command: ignore silently or echo
      return
    end
  end
  SRP.Chat.SendLocal(src, text)
end)