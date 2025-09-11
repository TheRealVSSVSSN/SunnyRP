local myKeys = {}

RegisterNetEvent('fsn_properties:keys:give')
AddEventHandler('fsn_properties:keys:give', function(id)
--[[
-- Type: Function
-- Name: fsn_properties:keys:give
-- Use: Stores a property identifier when keys are granted
-- Created: 2025-09-10
-- By: VSSVSSN
]]
table.insert(myKeys, id)
end)

--[[
-- Type: Function
-- Name: hasPropKeys
-- Use: Determine if the player holds keys for a property
-- Created: 2025-09-10
-- By: VSSVSSN
]]
function hasPropKeys(id)
for _, keyId in ipairs(myKeys) do
if keyId == id then
return true
end
end
return false
end