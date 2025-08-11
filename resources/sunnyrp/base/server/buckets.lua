SRP_Buckets = {}

local BUCKET = SRP_CONST.BUCKET

local function setBucket(src, id)
  SetPlayerRoutingBucket(src, id)
  return id
end

function SRP_Buckets.AssignLoading(src)
  return setBucket(src, SRP_Config.Buckets.loading or BUCKET.LOADING)
end

function SRP_Buckets.AssignMain(src)
  return setBucket(src, SRP_Config.Buckets.main or BUCKET.MAIN)
end

local start  = SRP_Config.Buckets.charStart or BUCKET.CHAR_START
local count  = SRP_Config.Buckets.charCount or BUCKET.CHAR_COUNT
local finish = start + count - 1
local allocated = {}

function SRP_Buckets.AssignCharCreate(src)
  for id = start, finish do
    if not allocated[id] then
      allocated[id] = src
      return setBucket(src, id)
    end
  end
  return setBucket(src, SRP_Config.Buckets.main or BUCKET.MAIN)
end

function SRP_Buckets.Free(src)
  for id,owner in pairs(allocated) do
    if owner == src then allocated[id] = nil end
  end
end

function SRP_Buckets.AssignAdmin(src, tag)
  local id = (SRP_Config.Buckets.adminStart or BUCKET.ADMIN_START) + (src % 1000)
  return setBucket(src, id)
end

exports('SetBucket', setBucket)