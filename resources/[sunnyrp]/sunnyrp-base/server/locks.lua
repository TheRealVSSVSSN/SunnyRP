-- sunnyrp-base/server/locks.lua
-- Simple in-process mutex with TTL to guard critical sections.

SRP_Locks = SRP_Locks or { map = {} }

local function now() return GetGameTimer() end

-- Try to acquire lockName for ttlMs; returns true if lock obtained.
function SRP_Locks.TryLock(lockName, ttlMs)
  local e = SRP_Locks.map[lockName]
  local t = now()
  if e and e.untilTs and t < e.untilTs then
    return false
  end
  SRP_Locks.map[lockName] = { untilTs = t + (ttlMs or 2000) }
  return true
end

-- Release early
function SRP_Locks.Unlock(lockName)
  SRP_Locks.map[lockName] = nil
end

-- WithLock(lockName, ttlMs, fn) -> ok, resultOrErr
function SRP_Locks.WithLock(lockName, ttlMs, fn)
  if not SRP_Locks.TryLock(lockName, ttlMs) then
    return false, 'locked'
  end
  local ok, err = pcall(fn)
  SRP_Locks.Unlock(lockName)
  if not ok then return false, err end
  return true
end

exports('TryLock', SRP_Locks.TryLock)
exports('Unlock', SRP_Locks.Unlock)
exports('WithLock', SRP_Locks.WithLock)