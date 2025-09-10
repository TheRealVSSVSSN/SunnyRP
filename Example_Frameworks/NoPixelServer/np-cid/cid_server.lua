--[[
    -- Type: Server
    -- Name: cid_server.lua
    -- Use: Generates CID items for players
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]

RegisterServerEvent('np-cid:createID')
AddEventHandler('np-cid:createID', function(first, last, job, sex, dob)
    --[[
        -- Type: Function
        -- Name: np-cid:createID
        -- Use: Creates ID card item with provided details
        -- Created: 2024-09-10
        -- By: VSSVSSN
    --]]
    local information = {
        identifier = math.random(100000, 999999),
        Name = tostring(first),
        Surname = tostring(last),
        Job = tostring(job),
        Sex = tostring(sex),
        DOB = tostring(dob)
    }
    TriggerClientEvent("player:receiveItem", source, "idcard", 1, true, information)
end)
