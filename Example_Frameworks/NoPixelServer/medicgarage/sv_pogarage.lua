RegisterNetEvent('attemptdutym')
AddEventHandler('attemptdutym', function(src)
    if src == nil or src == 0 then src = source end
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local jobs = exports["np-base"]:getModule("JobManager")
    local job = 'ems'
    jobs:SetJob(user, job, false, function()
        TriggerClientEvent("chatMessage", src, "DISPATCH ", 3, 'You are 10-41!')
        TriggerClientEvent("hasSignedOnEms", src)
        TriggerClientEvent('police:officerOnDuty', src)
        --SignOnRadio(src) -- old tokovoip
    end)
end)

RegisterNetEvent('medicg:spawn', function(model)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local job = user:getVar("job")

    if job == "ems" then
        TriggerClientEvent('nowService', src)
        TriggerClientEvent('nowMedic', src)
        TriggerClientEvent('nowMedic1', src)

        TriggerClientEvent('medicg:spawnVehicle', src, model)
    else
        TriggerClientEvent("DoLongHudText", src, "You are not signed in!!", 2)
    end
end)

--[[
    -- Type: Function
    -- Name: SignOnRadio
    -- Use: Sets the player's radio display name based on whitelist info
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function SignOnRadio(src)
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

    local q = [[SELECT id, owner, cid, job, callsign, rank FROM jobs_whitelist WHERE cid = @cid AND job = @job LIMIT 1;]]
    local v = { ["cid"] = char.id, ["job"] = "ems" }

    exports.ghmattimysql:execute(q, v, function(results)
        if not results[1] then return end
        local callsign = (results[1].callsign ~= nil and results[1].callsign ~= "") and results[1].callsign or "TBD"
        if src and char.first_name and char.last_name then
            local first = string.sub(char.first_name, 1, 1)
            local playerName = callsign .. " | " .. first .. ". " .. char.last_name
            TriggerClientEvent("TokoVoip:changeName", src, playerName)
        end
    end)
end
