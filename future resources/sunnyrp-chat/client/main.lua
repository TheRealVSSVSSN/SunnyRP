-- sunnyrp-chat: client/main.lua
-- Minimal NUI chat (open with T), sends to server events, receives srp:chat:push

local CHAT_VISIBLE = false

local function convarOr(name, default)
  local v = GetConvar(name, '')
  if v == '' then return default end
  return v
end

local CHAT_ENABLED = (convarOr('srp_chat_enable', 'true') == 'true')
if not CHAT_ENABLED then return end

local function openChat()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'open' })
  CHAT_VISIBLE = true
end

local function closeChat()
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })
  CHAT_VISIBLE = false
end

-- Keybind: open chat (T by default)
RegisterCommand('srp_chat_open', function()
  if CHAT_VISIBLE then return end
  openChat()
end)
RegisterKeyMapping('srp_chat_open', 'Open Chat', 'keyboard', 'T')

-- NUI → Server
RegisterNUICallback('submit', function(data, cb)
  cb(1)
  local text = tostring(data and data.text or '') or ''
  if text == '' then closeChat() return end

  -- Simple parsing: /me, /do, /ooc, /a (staff)
  local first = text:match('^/(%S+)')
  if first == 'me' then
    TriggerServerEvent('srp:chat:me', { text = text:gsub('^/%S+%s*', '') })
  elseif first == 'do' then
    TriggerServerEvent('srp:chat:do', { text = text:gsub('^/%S+%s*', '') })
  elseif first == 'ooc' then
    TriggerServerEvent('srp:chat:ooc', { text = text:gsub('^/%S+%s*', '') })
  elseif first == 'a' then
    TriggerServerEvent('srp:chat:staff', { text = text:gsub('^/%S+%s*', '') })
  else
    -- default local
    if text:sub(1,1) == '/' then
      -- unrecognized slash -> treat as local without slash
      text = text:sub(2)
    end
    TriggerServerEvent('srp:chat:local', { text = text })
  end

  closeChat()
end)

RegisterNUICallback('close', function(_, cb)
  cb(1)
  closeChat()
end)

-- Server → NUI
RegisterNetEvent('srp:chat:push', function(payload)
  -- payload: { channel, text, color={r,g,b}, from }
  if not payload or type(payload.text) ~= 'string' then return end
  SendNUIMessage({ action = 'push', payload = payload })
end)