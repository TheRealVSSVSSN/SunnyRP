-- sunnyrp-chat: server/main.lua
-- Proximity chat, /me /do, OOC, staff chat. Uses sunnyrp-base guards & perms.

local function convarOr(name, default)
  local v = GetConvar(name, '')
  if v == '' then return default end
  return v
end

local CHAT_ENABLED      = (convarOr('srp_chat_enable', 'true') == 'true')
local OOC_ENABLED       = (convarOr('srp_chat_ooc_enabled', 'true') == 'true')
local FILTER_PROFANITY  = (convarOr('srp_chat_profanity_filter', 'true') == 'true')

local RANGE_LOCAL       = tonumber(convarOr('srp_chat_range_local', '15.0')) or 15.0
local RANGE_ME_DO       = tonumber(convarOr('srp_chat_range_me_do', '15.0')) or 15.0

local RATE_GENERAL_MS   = tonumber(convarOr('srp_chat_rate_ms_general', '1500')) or 1500
local RATE_ME_DO_MS     = tonumber(convarOr('srp_chat_rate_ms_me_do', '1000')) or 1000
local RATE_OOC_MS       = tonumber(convarOr('srp_chat_rate_ms_ooc', '3000')) or 3000
local RATE_STAFF_MS     = tonumber(convarOr('srp_chat_rate_ms_staff', '1000')) or 1000

local STAFF_SCOPE       = convarOr('srp_chat_staff_scope', 'staff.chat')

-- Minimal profanity list (extend/replace later from backend)
local BAD_WORDS = {
  'fuck','shit','bitch','cunt','faggot','retard'
}
local function sanitize(text)
  if type(text) ~= 'string' then return '' end
  -- strip GTA color codes & overly long strings
  text = text:gsub('%^%d', '')
  text = text:sub(1, 300)
  if FILTER_PROFANITY then
    local lower = text:lower()
    for _,w in ipairs(BAD_WORDS) do
      local patt = '%f[%a]' .. w .. '%f[%A]'
      lower = lower:gsub(patt, string.rep('*', #w))
    end
    -- rebuild preserving original case per-char mask
    local masked = {}
    for i=1,#text do
      local ch = text:sub(i,i)
      local m  = lower:sub(i,i)
      if m == '*' then ch = '*' end
      masked[#masked+1] = ch
    end
    text = table.concat(masked)
  end
  return text
end

local function getCoords(src)
  local ped = GetPlayerPed(src)
  if not ped or ped == 0 then return nil end
  local x,y,z = table.unpack(GetEntityCoords(ped))
  return vector3(x,y,z)
end

local function dist(a, b)
  return #(a - b)
end

local function broadcastLocal(src, message, range, color, tag)
  local pos = getCoords(src)
  if not pos then return end
  for _, pid in ipairs(GetPlayers()) do
    local p = tonumber(pid)
    local ppos = getCoords(p)
    if ppos and dist(pos, ppos) <= range then
      TriggerClientEvent('srp:chat:push', p, {
        channel = tag, text = message, color = color or {255,255,255},
        from = src
      })
    end
  end
end

local function broadcastAll(message, color, tag)
  for _, pid in ipairs(GetPlayers()) do
    TriggerClientEvent('srp:chat:push', tonumber(pid), {
      channel = tag, text = message, color = color or {255,255,255},
      from = -1
    })
  end
end

local function broadcastStaff(message, color, tag)
  for _, pid in ipairs(GetPlayers()) do
    local p = tonumber(pid)
    if exports['sunnyrp-base']:HasScope(p, STAFF_SCOPE) then
      TriggerClientEvent('srp:chat:push', p, {
        channel = tag, text = message, color = color or {255,180,255},
        from = -1
      })
    end
  end
end

local function logToBackend(src, channel, text)
  if not SRP_HTTP or not SRP_HTTP.Fetch then return end
  local P = exports['sunnyrp-base']:getModule('Player')
  local u = P.GetUser(src) or {}
  local char = u.char or {}
  local pos = getCoords(src)
  local payload = {
    playerId = u.playerId,
    characterId = char.id,
    channel = channel,
    message = text,
    coords = pos and { x = pos.x, y = pos.y, z = pos.z } or nil
  }
  SRP_HTTP.Fetch('POST', '/chat/log', payload, { retries = 0, timeout = 3000 })
end

-- Validation helpers ----------------------------------------------------------
local function validatePayload(_, p)
  if type(p) ~= 'table' or type(p.text) ~= 'string' then
    return false, 'bad_payload'
  end
  if #p.text < 1 then return false, 'empty' end
  return true
end

if not CHAT_ENABLED then
  print('[sunnyrp-chat] Chat disabled via srp_chat_enable=false')
  return
end

-- Event guards via base -------------------------------------------------------
local Guard = exports['sunnyrp-base'].GuardNetEvent

-- LOCAL (default say)
Guard('srp:chat:local', {
  scopes = nil,
  cooldownMs = RATE_GENERAL_MS,
  bucket = { capacity = 5, refill = 5, perMs = 5000 },
  validate = validatePayload,
  logName = 'chat.local',
}, function(src, p)
  local msg = sanitize(p.text)
  broadcastLocal(src, msg, RANGE_LOCAL, {255,255,255}, 'local')
  logToBackend(src, 'local', msg)
end)

-- /me
Guard('srp:chat:me', {
  cooldownMs = RATE_ME_DO_MS,
  bucket = { capacity = 6, refill = 6, perMs = 4000 },
  validate = validatePayload,
  logName = 'chat.me',
}, function(src, p)
  local msg = sanitize(p.text)
  broadcastLocal(src, ('* %s *'):format(msg), RANGE_ME_DO, {180,200,255}, 'me')
  logToBackend(src, 'me', msg)
end)

-- /do
Guard('srp:chat:do', {
  cooldownMs = RATE_ME_DO_MS,
  bucket = { capacity = 6, refill = 6, perMs = 4000 },
  validate = validatePayload,
  logName = 'chat.do',
}, function(src, p)
  local msg = sanitize(p.text)
  broadcastLocal(src, ('%s'):format(msg), RANGE_ME_DO, {255,200,160}, 'do')
  logToBackend(src, 'do', msg)
end)

-- OOC (global)
if OOC_ENABLED then
  Guard('srp:chat:ooc', {
    cooldownMs = RATE_OOC_MS,
    bucket = { capacity = 4, refill = 4, perMs = 6000 },
    validate = validatePayload,
    logName = 'chat.ooc',
  }, function(src, p)
    local msg = sanitize(p.text)
    broadcastAll(('[OOC] %s'):format(msg), {200,200,200}, 'ooc')
    logToBackend(src, 'ooc', msg)
  end)
else
  print('[sunnyrp-chat] OOC disabled (srp_chat_ooc_enabled=false)')
end

-- STAFF (scoped)
Guard('srp:chat:staff', {
  scopes = { STAFF_SCOPE },
  cooldownMs = RATE_STAFF_MS,
  bucket = { capacity = 8, refill = 8, perMs = 5000 },
  validate = validatePayload,
  logName = 'chat.staff',
}, function(src, p)
  local msg = sanitize(p.text)
  broadcastStaff(('[STAFF] %s'):format(msg), {255,180,255}, 'staff')
  logToBackend(src, 'staff', msg)
end)

-- Commands via base dispatcher -----------------------------------------------
local RegisterCommandEx = exports['sunnyrp-base'].RegisterCommandEx

RegisterCommandEx('me', {
  description = 'Local emote text',
  cooldownMs = RATE_ME_DO_MS,
  restricted = false,
}, function(src, args)
  TriggerEvent('srp:chat:me', src, { text = table.concat(args, ' ') })
end)

RegisterCommandEx('do', {
  description = 'Describe scene (local)',
  cooldownMs = RATE_ME_DO_MS,
  restricted = false,
}, function(src, args)
  TriggerEvent('srp:chat:do', src, { text = table.concat(args, ' ') })
end)

RegisterCommandEx('ooc', {
  description = 'Out-of-character (global)',
  cooldownMs = RATE_OOC_MS,
  restricted = false,
}, function(src, args)
  if not OOC_ENABLED then return end
  TriggerEvent('srp:chat:ooc', src, { text = table.concat(args, ' ') })
end)

RegisterCommandEx('a', {
  description = 'Staff chat',
  scopes = { STAFF_SCOPE },
  cooldownMs = RATE_STAFF_MS,
}, function(src, args)
  TriggerEvent('srp:chat:staff', src, { text = table.concat(args, ' ') })
end)