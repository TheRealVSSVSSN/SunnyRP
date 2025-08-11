-- resources/sunnyrp/properties/server/main.lua
SRP = SRP or {}
SRP.Properties = SRP.Properties or {}
local CFG = SRP.Properties.Config

local Instances = { byProp = {}, bySrc = {} } -- propertyId->bucket, src->propertyId
local NextBucket = CFG.bucketBase

local function actorHeaders(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId']=tostring(uid or 0), ['X-SRP-CharId']=tostring(cid or 0) }
end

local function parseOK(res)
  if not res or res.status ~= 200 then return nil end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then return nil end
  return obj.data
end

SRP.Properties.GetForChar = function(src)
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src)
  if not cid then return {} end
  local res = SRP.Fetch({ path = '/properties?charId='..tostring(cid), method='GET', headers = actorHeaders(src) })
  return parseOK(res) or {}
end

-- Enter property (server-authoritative)
SRP.Properties.Enter = function(src, propertyId)
  local data = parseOK(SRP.Fetch({ path='/properties/enter', method='POST', body={ property_id = tonumber(propertyId) }, headers=actorHeaders(src) }))
  if not data then
    TriggerClientEvent('srp:notify', src, 'Door is locked or access denied.')
    return false
  end
  local bucket = Instances.byProp[propertyId]
  if not bucket then
    bucket = NextBucket; NextBucket = NextBucket + 1
    Instances.byProp[propertyId] = bucket
  end
  SetPlayerRoutingBucket(src, bucket)
  Instances.bySrc[src] = propertyId
  TriggerClientEvent('srp:properties:entered', src, { property = data.property, interior = data.interior, bucket = bucket })
  return true
end

SRP.Properties.Exit = function(src)
  local pid = Instances.bySrc[src]; if not pid then return end
  SetPlayerRoutingBucket(src, 0)
  Instances.bySrc[src] = nil
  TriggerClientEvent('srp:properties:exited', src, { property_id = pid })
end

SRP.Properties.ToggleLock = function(src, propertyId, locked)
  local out = parseOK(SRP.Fetch({ path='/properties/lock', method='POST', body={ property_id = tonumber(propertyId), locked = not not locked }, headers=actorHeaders(src) }))
  if out then TriggerClientEvent('srp:notify', src, out.locked and 'Locked' or 'Unlocked') end
end

-- Buy / Sell
SRP.Properties.Purchase = function(src, propertyId)
  local out = parseOK(SRP.Fetch({ path='/properties/purchase', method='POST', body={ property_id = tonumber(propertyId) }, headers=actorHeaders(src) }))
  if out then TriggerClientEvent('srp:notify', src, ('Purchased %s'):format(out.slug)) end
end
SRP.Properties.Sell = function(src, propertyId)
  local out = parseOK(SRP.Fetch({ path='/properties/sell', method='POST', body={ property_id = tonumber(propertyId) }, headers=actorHeaders(src) }))
  if out then TriggerClientEvent('srp:notify', src, ('Listed %s for sale'):format(out.slug)) end
end

-- Keys (share/revoke) & Rent
SRP.Properties.GrantAccess = function(src, propertyId, targetCharId, accessType, expiresAt)
  parseOK(SRP.Fetch({ path='/properties/access/grant', method='POST', body={ property_id=tonumber(propertyId), target_char_id=tonumber(targetCharId), access_type=accessType, expires_at=expiresAt }, headers=actorHeaders(src) }))
end
SRP.Properties.RevokeAccess = function(src, propertyId, targetCharId)
  parseOK(SRP.Fetch({ path='/properties/access/revoke', method='POST', body={ property_id=tonumber(propertyId), target_char_id=tonumber(targetCharId) }, headers=actorHeaders(src) }))
end
SRP.Properties.RentStart = function(src, propertyId)
  parseOK(SRP.Fetch({ path='/properties/rent/start', method='POST', body={ property_id=tonumber(propertyId) }, headers=actorHeaders(src) }))
end
SRP.Properties.RentStop = function(src, propertyId)
  parseOK(SRP.Fetch({ path='/properties/rent/stop', method='POST', body={ property_id=tonumber(propertyId) }, headers=actorHeaders(src) }))
end

-- Simple commands for testing (swap to menus later)
RegisterCommand('prop_list', function(src) TriggerClientEvent('srp:properties:list', src, SRP.Properties.GetForChar(src)) end)
RegisterCommand('prop_enter', function(src, args) local id=tonumber(args[1] or 0); if id>0 then SRP.Properties.Enter(src, id) end end)
RegisterCommand('prop_exit', function(src) SRP.Properties.Exit(src) end)
RegisterCommand('prop_lock', function(src, args) local id=tonumber(args[1] or 0); local s=tostring(args[2] or 'toggle'); if id>0 then
  if s=='toggle' then SRP.Properties.ToggleLock(src, id, true) else SRP.Properties.ToggleLock(src, id, s=='true' or s=='1' or s=='on') end end end)

AddEventHandler('playerDropped', function() local src=source; Instances.bySrc[src]=nil end)