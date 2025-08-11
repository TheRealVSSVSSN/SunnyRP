SRP_Utils = SRP_Utils or {}

function SRP_Utils.tableMerge(dst, src)
  if type(dst) ~= 'table' then dst = {} end
  if type(src) ~= 'table' then return dst end
  for k,v in pairs(src) do dst[k] = v end
  return dst
end

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

function SRP_Utils.round(n, dp)
  local m = 10^(dp or 0)
  return math.floor(n * m + 0.5) / m
end

function SRP_Utils.try(cb)
  local ok, err = pcall(cb)
  if not ok then print(('^1[SRP][ERR]^7 %s'):format(err)) end
end