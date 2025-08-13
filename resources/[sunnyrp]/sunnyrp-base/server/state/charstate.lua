-- sunnyrp-base/server/charstate.lua
-- Small helpers other resources can call to standardize character state bags.

local Keys = (SRP_State and SRP_State.Keys) or {}

exports('SetCharacterState', function(src, char)
  -- char = { id, job?, duty? }
  local patch = {}
  if char and char.id then patch[Keys.charId] = tonumber(char.id) end
  if char and char.job then patch[Keys.job] = tostring(char.job) end
  if char and (char.duty ~= nil) then patch[Keys.duty] = (char.duty == true) end
  if next(patch) then
    SRP_State.SetMany(src, patch, true)
  end
end)