local currentTime = 0

local cases = {
    {-626.5326, -238.3758, 38.05, blip = false, robbed = false, lastrob = 0},
    {-625.6032, -237.5273, 38.05, blip = false, robbed = false, lastrob = 0},
    {-626.9178, -235.5166, 38.05, blip = false, robbed = false, lastrob = 0},
    {-625.6701, -234.6061, 38.05, blip = false, robbed = false, lastrob = 0},
    {-626.8935, -233.0814, 38.05, blip = false, robbed = false, lastrob = 0},
    {-627.9514, -233.8582, 38.05, blip = false, robbed = false, lastrob = 0},
    {-624.5250, -231.0555, 38.05, blip = false, robbed = false, lastrob = 0},
    {-623.0003, -233.0833, 38.05, blip = false, robbed = false, lastrob = 0},
    {-620.1098, -233.3672, 38.05, blip = false, robbed = false, lastrob = 0},
    {-620.2979, -234.4196, 38.05, blip = false, robbed = false, lastrob = 0},
    {-619.0646, -233.5629, 38.05, blip = false, robbed = false, lastrob = 0},
    {-617.4846, -230.6598, 38.05, blip = false, robbed = false, lastrob = 0},
    {-618.3619, -229.4285, 38.05, blip = false, robbed = false, lastrob = 0},
    {-619.6064, -230.5518, 38.05, blip = false, robbed = false, lastrob = 0},
    {-620.8951, -228.6519, 38.05, blip = false, robbed = false, lastrob = 0},
    {-619.7905, -227.5623, 38.05, blip = false, robbed = false, lastrob = 0},
    {-620.6110, -226.4467, 38.05, blip = false, robbed = false, lastrob = 0},
    {-623.9951, -228.1755, 38.05, blip = false, robbed = false, lastrob = 0},
    {-624.8832, -227.8645, 38.05, blip = false, robbed = false, lastrob = 0},
    {-623.6746, -227.0025, 38.05, blip = false, robbed = false, lastrob = 0}
}

local isMainDoorLocked = false

--[[
    -- Type: Event
    -- Name: fsn_jewellerystore:doors:Lock
    -- Use: Locks main doors and unlocks after timeout
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_jewellerystore:doors:Lock', function()
    isMainDoorLocked = true
    TriggerClientEvent('fsn_jewellerystore:doors:State', -1, true)
    Wait(1200000)
    isMainDoorLocked = false
    TriggerClientEvent('fsn_jewellerystore:doors:State', -1, false)
end)

--[[
    -- Type: Event
    -- Name: fsn_inventory:gasDoorunlock
    -- Use: Toggles gas door and sends police notification
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_inventory:gasDoorunlock', function()
    TriggerClientEvent('fsn_jewellerystore:gasDoor:toggle', -1)
    TriggerClientEvent('fsn_police:911', -1, 69, 'AutoMSG', 'HUMANE LABS ALARM SYSTEM: Stolen ID card used to unlock door #3557')
    Wait(5000)
    TriggerClientEvent('fsn_jewellerystore:gasDoor:toggle', -1)
end)

--[[
    -- Type: Event
    -- Name: fsn_jewellerystore:case:rob
    -- Use: Handles robbing a display case
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_jewellerystore:case:rob', function(index)
    local slot = cases[index]
    if not slot then return end

    local cooldown = slot.lastrob + 1800
    if slot.lastrob ~= 0 and cooldown > currentTime then
        TriggerClientEvent('fsn_notify:displayNotification', source, 'This case has been robbed too recently', 'centerRight', 8000, 'error')
        return
    end

    slot.robbed = true
    slot.lastrob = currentTime
    TriggerClientEvent('fsn_jewellerystore:case:startrob', source, slot)
    TriggerClientEvent('fsn_jewellerystore:cases:update', -1, cases)
end)

--[[
    -- Type: Event
    -- Name: fsn_jewellerystore:cases:request
    -- Use: Sends current case states to client
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_jewellerystore:cases:request', function()
    TriggerClientEvent('fsn_jewellerystore:cases:update', -1, cases)
end)

--[[
    -- Type: Thread
    -- Name: caseResetLoop
    -- Use: Resets robbed cases after cooldown
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(1000)
        currentTime = currentTime + 1
        for _, slot in pairs(cases) do
            if slot.robbed and currentTime >= slot.lastrob + 1800 then
                slot.robbed = false
                slot.lastrob = 0
                TriggerClientEvent('fsn_jewellerystore:cases:update', -1, cases)
            end
        end
    end
end)

