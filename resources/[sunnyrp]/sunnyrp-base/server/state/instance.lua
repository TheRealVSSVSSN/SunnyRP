-- sunnyrp-base/server/instance.lua
-- Simple instance manager (routing buckets). Content can request an instance and add/remove players.

SRP_Instance = SRP_Instance or {
  byName = {},     -- name -> { bucket, members = { [src] = true }, createdBy, createdAt }
  byPlayer = {},   -- src -> name
  nextOffset = 0,  -- rotating offset
}

local function cfg()
  return SRP_Config and SRP_Config.Buckets or {
    loading = 1, main = 2, charStart = 10001, charCount = 1000, adminStart = 50001
  }
end

local function pickBucket()
  -- Use a deterministic character range for content instances (reuse char range to stay high)
  local base = (cfg().charStart or 10001)
  local span = (cfg().charCount or 1000)
  SRP_Instance.nextOffset = (SRP_Instance.nextOffset + 1) % span
  return base + SRP_Instance.nextOffset
end

local function ensure(name)
  local inst = SRP_Instance.byName[name]
  if inst then return inst end
  local b = pickBucket()
  inst = { bucket = b, members = {}, createdBy = 0, createdAt = os.time() }
  SRP_Instance.byName[name] = inst
  return inst
end

local function setBucket(src, bucket)
  SetPlayerRoutingBucket(src, bucket)
  local ped = GetPlayerPed(src)
  if ped and ped ~= 0 then
    Entity(ped).state:set('srp:bucket', bucket, true)
  end
end

function SRP_Instance.Create(name, createdBy)
  if SRP_Instance.byName[name] then return SRP_Instance.byName[name].bucket end
  local inst = ensure(name)
  inst.createdBy = createdBy or 0
  return inst.bucket
end

function SRP_Instance.AddPlayer(name, src)
  local inst = SRP_Instance.byName[name] or ensure(name)
  setBucket(src, inst.bucket)
  inst.members[src] = true
  SRP_Instance.byPlayer[src] = name
end

function SRP_Instance.RemovePlayer(src)
  local name = SRP_Instance.byPlayer[src]
  if not name then return end
  local inst = SRP_Instance.byName[name]
  if inst then inst.members[src] = nil end
  SRP_Instance.byPlayer[src] = nil
  -- default back to main bucket
  if SRP_Buckets and SRP_Buckets.ToMain then
    SRP_Buckets.ToMain(src)
  else
    setBucket(src, cfg().main or 2)
  end
end

function SRP_Instance.Destroy(name)
  local inst = SRP_Instance.byName[name]
  if not inst then return false end
  for src,_ in pairs(inst.members) do
    SRP_Instance.RemovePlayer(src)
  end
  SRP_Instance.byName[name] = nil
  return true
end

-- Cleanup when player leaves
AddEventHandler('playerDropped', function()
  local src = source
  SRP_Instance.RemovePlayer(src)
end)

-- Exports
exports('InstanceCreate', SRP_Instance.Create)
exports('InstanceAddPlayer', SRP_Instance.AddPlayer)
exports('InstanceRemovePlayer', SRP_Instance.RemovePlayer)
exports('InstanceDestroy', SRP_Instance.Destroy)

-- Admin/staff commands using our scoped command framework
local RegisterCommandEx = exports['sunnyrp-base'].RegisterCommandEx

RegisterCommandEx('instcreate', {
  description = 'Create named instance',
  scopes = { 'admin.instance' },
  argsHint = 'name',
  cooldownMs = 800,
}, function(src, args)
  local name = (args[1] or ''):gsub('%s','')
  if name == '' then return end
  local b = SRP_Instance.Create(name, src)
  TriggerClientEvent('srp:chat:push', src, { channel='admin', text=('[instance] "%s" = bucket %d'):format(name, b), color={255,180,255} })
end)

RegisterCommandEx('instjoin', {
  description = 'Join named instance',
  scopes = { 'admin.instance' },
  argsHint = 'name [playerId]',
  cooldownMs = 800,
}, function(src, args)
  local name = (args[1] or ''):gsub('%s','')
  if name == '' then return end
  local target = tonumber(args[2] or src) or src
  SRP_Instance.AddPlayer(name, target)
end)

RegisterCommandEx('instleave', {
  description = 'Leave current instance (to main)',
  scopes = { 'admin.instance' },
  cooldownMs = 800,
}, function(src)
  SRP_Instance.RemovePlayer(src)
end)

RegisterCommandEx('instdestroy', {
  description = 'Destroy named instance',
  scopes = { 'admin.instance' },
  argsHint = 'name',
  cooldownMs = 800,
}, function(src, args)
  local name = (args[1] or ''):gsub('%s','')
  if name == '' then return end
  SRP_Instance.Destroy(name)
end)