-- srp_base: server/buckets.lua
-- Central routing-bucket helpers and conventions.
-- Buckets Config comes from SRP_Config.Buckets (config.lua)

SRP_Buckets = SRP_Buckets or {}

local function cfg()
  return SRP_Config and SRP_Config.Buckets or {
    loading = 1, main = 2, charStart = 10001, charCount = 1000, adminStart = 50001
  }
end

local function setBucket(src, bucket)
  SetPlayerRoutingBucket(src, bucket)
  -- Optional: reflect in statebag
  local ped = GetPlayerPed(src)
  if ped and ped ~= 0 then
    Entity(ped).state:set('srp:bucket', bucket, true)
  end
end

function SRP_Buckets.ToLoading(src)
  setBucket(src, cfg().loading)
end

function SRP_Buckets.ToMain(src)
  setBucket(src, cfg().main)
end

-- Deterministic per-character bucket: base + (charId % charCount)
function SRP_Buckets.ToCharacter(src, charId)
  local C = cfg()
  local offset = (tonumber(charId) or 0) % (C.charCount or 1000)
  setBucket(src, (C.charStart or 10001) + offset)
end

-- Simple admin bucket grouping: adminStart + small index
function SRP_Buckets.ToAdmin(src, groupIndex)
  local base = cfg().adminStart or 50001
  setBucket(src, base + (tonumber(groupIndex) or 0))
end

-- Export helpers
exports('SetBucket', setBucket)
exports('ToLoading', SRP_Buckets.ToLoading)
exports('ToMain', SRP_Buckets.ToMain)
exports('ToCharacter', SRP_Buckets.ToCharacter)
exports('ToAdmin', SRP_Buckets.ToAdmin)