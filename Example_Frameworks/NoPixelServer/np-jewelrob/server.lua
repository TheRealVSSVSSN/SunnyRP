--[[
    -- Type: Function
    -- Name: resetJewels
    -- Use: Resets jewel case state and schedules next reset
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local TOTAL_CASES = 20
local hasRobbed = {}

local function resetJewels()
    for i = 1, TOTAL_CASES do
        hasRobbed[i] = false
    end
    TriggerClientEvent("jewel:robbed", -1, hasRobbed)
    SetTimeout(4800000, resetJewels)
end

--[[
    -- Type: Function
    -- Name: sendJewelStatus
    -- Use: Sends current jewel state to requesting client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function sendJewelStatus(src)
    TriggerClientEvent("jewel:robbed", src, hasRobbed)
end

CreateThread(function()
    resetJewels()
end)

RegisterNetEvent("jewel:hasrobbed")
AddEventHandler("jewel:hasrobbed", function(num)
    hasRobbed[num] = true
    TriggerClientEvent("jewel:robbed", -1, hasRobbed)
end)

RegisterNetEvent("jewel:request")
AddEventHandler("jewel:request", function()
    local src = source
    sendJewelStatus(src)
end)

RegisterNetEvent("jewel:reset")
AddEventHandler("jewel:reset", function()
    resetJewels()
end)

