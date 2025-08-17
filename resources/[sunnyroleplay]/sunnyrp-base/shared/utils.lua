SRP_Util = {}

local function extractIdentifier(src, name)
  for _, id in ipairs(GetPlayerIdentifiers(src)) do
    if id:sub(1, #name + 1) == (name .. ":") then return id end
  end
end

function SRP_Util.getHexId(src)
  for _, key in ipairs(SRP_CONST.IDENTIFIERS_PRIORITY) do
    local v = extractIdentifier(src, key)
    if v then return v end
  end
  return nil
end

return SRP_Util