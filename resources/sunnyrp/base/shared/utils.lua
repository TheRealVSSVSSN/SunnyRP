SRP_Utils = SRP_Utils or {}

-- Shallow merge
function SRP_Utils.tableMerge(dst, src)
  if type(dst) ~= 'table' then dst = {} end
  if type(src) ~= 'table' then return dst end
  for k,v in pairs(src) do dst[k] = v end
  return dst
end

-- Deep merge
function SRP_Utils.deepMerge(dst, src)
  if type(dst) ~= 'table' then dst = {} end
  if type(src) ~= 'table' then return dst end
  for k, v in pairs(src) do
    if type(v) == 'table' and type(dst[k]) == 'table' then
      SRP_Utils.deepMerge(dst[k], v)
    else
      dst[k] = v
    end
  end
  return dst
end

-- Safe JSON decode
function SRP_Utils.safeJsonDecode(s)
  if type(s) ~= 'string' or s == '' then return nil end
  local ok, res = pcall(function() return json.decode(s) end)
  return ok and res or nil
end

-- Simple logger
local function now() return os.date('%m-%d-%Y %H:%M:%S') end
function SRP_Utils.log(level, msg)
  print(('%s ^5[SRP]^7 [%s] %s'):format(now(), level, msg))
end

-- "A.B.C" path helpers
local function splitDots(path)
  local out = {}
  for part in string.gmatch(path, '([^%.]+)') do table.insert(out, part) end
  return out
end

function SRP_Utils.getByPath(tbl, path)
  if type(tbl) ~= 'table' or type(path) ~= 'string' then return nil end
  local t = tbl
  for _,p in ipairs(splitDots(path)) do
    if type(t) ~= 'table' then return nil end
    t = t[p]
  end
  return t
end

function SRP_Utils.setByPath(tbl, path, value)
  if type(tbl) ~= 'table' or type(path) ~= 'string' then return end
  local t = tbl
  local parts = splitDots(path)
  for i=1,#parts-1 do
    local p = parts[i]
    if type(t[p]) ~= 'table' then t[p] = {} end
    t = t[p]
  end
  t[parts[#parts]] = value
end

function SRP_Utils.round(n, dp)
  local m = 10^(dp or 0)
  return math.floor(n * m + 0.5) / m
end

-- Guard a function to avoid crashing threads/handlers
function SRP_Utils.try(fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then SRP_Utils.log('ERR', tostring(err)) end
  return ok
end