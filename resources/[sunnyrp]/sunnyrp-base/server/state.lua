-- sunnyrp-base/server/state.lua
-- Authoritative server-side helpers to set/get player state bags.

local Keys = (SRP_State and SRP_State.Keys) or {}

local function pedOf(src)
  local ped = GetPlayerPed(src)
  if not ped or ped == 0 then return nil end
  return ped
end

local function setState(src, key, value, replicate)
  local ped = pedOf(src); if not ped then return false end
  -- default replicate=true (sync to others)
  local rep = (replicate == nil) and true or (replicate == true)
  Entity(ped).state:set(key, value, rep)
  return true
end

local function getState(src, key)
  local ped = pedOf(src); if not ped then return nil end
  return Entity(ped).state[key]
end

local function setBatch(src, tbl, replicate)
  local ped = pedOf(src); if not ped then return false end
  local rep = (replicate == nil) and true or (replicate == true)
  for k,v in pairs(tbl or {}) do
    Entity(ped).state:set(k, v, rep)
  end
  return true
end

SRP_State = SRP_State or {}
SRP_State.Set     = setState
SRP_State.Get     = getState
SRP_State.SetMany = setBatch

-- Exports for other resources
exports('SetState', setState)
exports('GetState', getState)
exports('SetStateMany', setBatch)
exports('StateKey', function(name) return Keys[name] end)