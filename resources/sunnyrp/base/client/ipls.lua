-- Base only ensures/removes IPL lists by set name; actual lists live in a separate resource (e.g., srp_ipls)

local loaded = {}

RegisterNetEvent('srp:ipl:ensure')
AddEventHandler('srp:ipl:ensure', function(setName, ipls)
  if loaded[setName] then return end
  if type(ipls) ~= 'table' then return end
  for _, name in ipairs(ipls) do RequestIpl(name) end
  loaded[setName] = true
end)

RegisterNetEvent('srp:ipl:remove')
AddEventHandler('srp:ipl:remove', function(setName, ipls)
  if not loaded[setName] then return end
  if type(ipls) ~= 'table' then return end
  for _, name in ipairs(ipls) do RemoveIpl(name) end
  loaded[setName] = nil
end)