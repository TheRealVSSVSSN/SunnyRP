-- resources/sunnyrp/phone/server/main.lua
SRP = SRP or {}
SRP.Phone = SRP.Phone or {}
local CFG = SRP.Phone.Config

local smsCooldown = {}     -- src -> last send time
local charSrc = {}         -- charId -> src (for push delivery)

-- Track active characters so we can push notifications
SRP.Characters = SRP.Characters or {}
SRP.Characters.activeBySrc = SRP.Characters.activeBySrc or {}
SRP.Characters.GetActiveCharId = SRP.Characters.GetActiveCharId or function(src)
  local m = SRP.Characters.activeBySrc or {}
  return m[src]
end
-- Build reverse map periodically
CreateThread(function()
  while true do
    Wait(5000)
    local rev = {}
    for src, cid in pairs(SRP.Characters.activeBySrc or {}) do
      if cid then rev[cid] = tonumber(src) end
    end
    charSrc = rev
  end
end)

local function actorHeaders(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId']=tostring(uid or 0), ['X-SRP-CharId']=tostring(cid or 0) }
end

local function parseOK(res)
  if not res or res.status ~= 200 then return nil end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  return (ok and obj and obj.ok) and obj.data or nil
end

-- Ensure the char has a phone (auto-claim if none)
SRP.Phone.Ensure = function(src, area)
  local data = parseOK(SRP.Fetch({ path='/phones/ensure', method='POST', body={ area = area or CFG.areaDefault }, headers=actorHeaders(src) }))
  return data
end

-- Get my phones (active)
SRP.Phone.List = function(src)
  return parseOK(SRP.Fetch({ path = '/phones', method='GET', headers=actorHeaders(src) })) or {}
end

-- Resolve a phone number to a char (if owned)
local function findSrcByNumber(number)
  local row = parseOK(SRP.Fetch({ path='/phones/number/'..tostring(number), method='GET' }))
  if row and row.char_id and charSrc[row.char_id] then return charSrc[row.char_id] end
  return nil
end

-- SMS send (server-authoritative)
SRP.Phone.SendSMS = function(src, fromNumber, toNumber, text)
  local now = GetGameTimer()
  if (now - (smsCooldown[src] or 0)) < CFG.smsRateMs then
    return TriggerClientEvent('srp:notify', src, 'Please wait before sending again.')
  end
  smsCooldown[src] = now

  local idem = ('sms:%s:%s:%s'):format(fromNumber, toNumber, now)
  local res = SRP.Fetch({
    path='/sms/send', method='POST', headers=actorHeaders(src),
    body={ from = tostring(fromNumber), to = tostring(toNumber), text = tostring(text or ''):sub(1,500), idempotencyKey = idem }
  })
  local data = parseOK(res)
  if not data then return TriggerClientEvent('srp:notify', src, 'SMS failed.') end

  -- Echo to sender NUI immediately
  TriggerClientEvent('srp:phone:sms:echo', src, { id = data.id, from = data.from, to = data.to, text = data.text, created_at = os.time() })

  -- Try to push to recipient if online
  local rsrc = findSrcByNumber(toNumber)
  if rsrc then
    TriggerClientEvent('srp:phone:sms:push', rsrc, { id = data.id, from = data.from, to = data.to, text = data.text, created_at = os.time() })
  end
end

-- Inbox pull for a given number (used on open + periodic poll)
SRP.Phone.FetchInbox = function(src, number, sinceId)
  local q = '/sms/inbox?number='..tostring(number)
  if sinceId then q = q .. '&sinceId='..tostring(sinceId) end
  local data = parseOK(SRP.Fetch({ path=q, method='GET', headers=actorHeaders(src) })) or {}
  return data
end

-- Contacts
SRP.Phone.ListContacts = function(src, phoneId)
  local data = parseOK(SRP.Fetch({ path='/contacts?phone_id='..tostring(phoneId), method='GET', headers=actorHeaders(src) })) or {}
  return data
end
SRP.Phone.SaveContact = function(src, phoneId, contact)
  local data = parseOK(SRP.Fetch({ path='/contacts', method='POST', headers=actorHeaders(src), body={ phone_id=phoneId, name=contact.name, number=contact.number, favorite=contact.favorite } })) or {}
  return data
end
SRP.Phone.DeleteContact = function(src, phoneId, id)
  parseOK(SRP.Fetch({ path='/contacts/'..tostring(id)..'?phone_id='..tostring(phoneId), method='DELETE', headers=actorHeaders(src) }))
end

-- Ads
SRP.Phone.FetchAds = function(src, limit)
  local data = parseOK(SRP.Fetch({ path='/ads?active=true&limit='..tostring(limit or 50), method='GET', headers=actorHeaders(src) })) or {}
  return data
end
SRP.Phone.PostAd = function(src, number, title, body)
  local data = parseOK(SRP.Fetch({ path='/ads', method='POST', headers=actorHeaders(src), body={ phone_number=number, title=title, body=body } })) or {}
  return data
end

-- NUI callbacks bridge
RegisterNetEvent('srp:phone:sms:send', function(payload)
  local src=source; SRP.Phone.SendSMS(src, payload.from, payload.to, payload.text)
end)
RegisterNetEvent('srp:phone:open', function()
  local src=source
  local phone = SRP.Phone.Ensure(src, CFG.areaDefault)
  if not phone then return TriggerClientEvent('srp:notify', src, 'No phone available.') end
  local contacts = SRP.Phone.ListContacts(src, phone.id)
  local inbox = SRP.Phone.FetchInbox(src, phone.number, nil)
  local ads = SRP.Phone.FetchAds(src, 25)
  TriggerClientEvent('srp:phone:open:data', src, { phone = phone, contacts = contacts, inbox = inbox, ads = ads })
end)
RegisterNetEvent('srp:phone:contacts:save', function(payload)
  local src=source
  local list = SRP.Phone.SaveContact(src, payload.phoneId, payload.contact)
  TriggerClientEvent('srp:phone:contacts:update', src, list)
end)
RegisterNetEvent('srp:phone:contacts:delete', function(payload)
  local src=source
  SRP.Phone.DeleteContact(src, payload.phoneId, payload.id)
  local list = SRP.Phone.ListContacts(src, payload.phoneId)
  TriggerClientEvent('srp:phone:contacts:update', src, list)
end)
RegisterNetEvent('srp:phone:ads:post', function(payload)
  local src=source; local out = SRP.Phone.PostAd(src, payload.number, payload.title, payload.body)
  if out and out.id then TriggerClientEvent('srp:notify', src, 'Ad posted.') end
end)

-- Periodic inbox poll (fallback if push misses)
CreateThread(function()
  while true do
    Wait(CFG.pollMs)
    for _, sid in ipairs(GetPlayers()) do
      local src = tonumber(sid)
      local phone = SRP.Phone.Ensure(src, CFG.areaDefault)
      if phone then
        local msgs = SRP.Phone.FetchInbox(src, phone.number, nil) or {}
        if #msgs > 0 then
          TriggerClientEvent('srp:phone:sms:bulk', src, msgs)
        end
      end
    end
  end
end)