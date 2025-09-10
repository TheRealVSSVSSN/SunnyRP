--[[
    -- Type: Event
    -- Name: job:Pay
    -- Use: Pays a player for completing a task
    -- Created: 2024-04-18
    -- By: VSSVSSN
--]]
RegisterServerEvent("job:Pay")
AddEventHandler("job:Pay", function(data, pay)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end
    local amount = tonumber(pay) or 0
    if amount <= 0 then return end
    user:addMoney(amount)
end)

--[[
    -- Type: Event
    -- Name: secondary:NewJobServer
    -- Use: Stores or updates a player's secondary job
    -- Created: 2024-04-18
    -- By: VSSVSSN
--]]
RegisterServerEvent("secondary:NewJobServer")
AddEventHandler("secondary:NewJobServer", function(newjob)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end
    local char = user:getCurrentCharacter()
    if not char then return end

    exports.ghmattimysql:execute('INSERT INTO secondary_jobs (cid, job) VALUES (@cid, @job) ON DUPLICATE KEY UPDATE job = @job', {
        ['cid'] = char.id,
        ['job'] = newjob,
    }, function()
        TriggerClientEvent('SecondaryJobUpdate', src, newjob)
    end)
end)

--[[
    -- Type: Event
    -- Name: secondary:NewJobServerWipe
    -- Use: Removes a player's secondary job entry
    -- Created: 2024-04-18
    -- By: VSSVSSN
--]]
RegisterServerEvent("secondary:NewJobServerWipe")
AddEventHandler("secondary:NewJobServerWipe", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end
    local char = user:getCurrentCharacter()
    if not char then return end

    exports.ghmattimysql:execute('DELETE FROM secondary_jobs WHERE cid = @cid', {
        ['cid'] = char.id,
    }, function()
        TriggerClientEvent('SecondaryJobUpdate', src, "none")
    end)
end)
