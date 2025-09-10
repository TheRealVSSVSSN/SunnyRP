--[[
    -- Type: Server Script
    -- Name: sv_jobmanager.lua
    -- Use: Server-side job management including whitelists and paychecks
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

NPX.Jobs.CurPlayerJobs = {}

for job, _ in pairs(NPX.Jobs.ValidJobs) do
    NPX.Jobs.CurPlayerJobs[job] = {}
end

--[[
    -- Type: Function
    -- Name: IsWhiteListed
    -- Use: Checks if a character is whitelisted for a job
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:IsWhiteListed(hexId, characterId, job, callback)
    if not hexId or not characterId then
        callback(false, false)
        return
    end

    local q = [[SELECT cid, owner, job, rank FROM jobs_whitelist WHERE cid = @cid AND job = @job LIMIT 1]]
    local v = { owner = hexId, cid = characterId, job = job }

    exports.ghmattimysql:execute(q, v, function(results)
        if not results or not results[1] then
            callback(false, false)
            return
        end
        local rank = results[1].rank or 0
        callback(true, rank)
    end)
end

--[[
    -- Type: Function
    -- Name: JobExists
    -- Use: Validates if a job is defined
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:JobExists(job)
    return NPX.Jobs.ValidJobs[job] ~= nil
end

--[[
    -- Type: Function
    -- Name: CountJob
    -- Use: Returns number of players with a specific job
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:CountJob(job)
    if not NPX.Jobs:JobExists(job) then return 0 end

    local count = 0
    for _, data in pairs(NPX.Jobs.CurPlayerJobs[job]) do
        if job ~= "ems" or data.isWhiteListed then
            count = count + 1
        end
    end
    return count
end

--[[
    -- Type: Function
    -- Name: CanBecomeJob
    -- Use: Validates whether the user can switch to a job
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:CanBecomeJob(user, job, callback)
    if not user then callback(false) return end
    if not user:getVar("characterLoaded") then callback(false, "Character not loaded") return end

    local src = user:getVar("source")
    local hexId = user:getVar("hexid")
    local characterId = user:getVar("character").id

    if not hexId or not characterId or not src then callback(false, "Id's don't exist") return end
    if not NPX.Jobs.ValidJobs[job] then callback(false, "Job isn't a valid job") return end

    TriggerEvent("np-jobmanager:attemptBecomeJob", src, characterId, function(allowed, reason)
        if not allowed then callback(false, reason) return end
    end)

    if WasEventCanceled() then callback(false) return end

    if NPX.Jobs.ValidJobs[job].whitelisted then
        NPX.Jobs:IsWhiteListed(hexId, characterId, job, function(whiteListed, rank)
            if not whiteListed then callback(false, "You're not whitelisted for this job") return end
            callback(true, nil, rank)
        end)
        return
    end

    if NPX.Jobs:JobExists(job) then
        local jobTable = NPX.Jobs.ValidJobs[job]
        if jobTable.max and NPX.Jobs:CountJob(job) >= jobTable.max then
            callback(false, "There are too many employees for this job right now, try again later")
            return
        end
    end
    callback(true)
end

--[[
    -- Type: Function
    -- Name: AddWhiteList
    -- Use: Adds a character to a job whitelist
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:AddWhiteList(user, job, rank)
    local cid = user:getCurrentCharacter().id
    local hexId = user:getVar("hexid")
    local q = [[INSERT INTO jobs_whitelist (cid, owner, job, rank) VALUES (@cid, @owner, @job, @rank)]]
    local v = { cid = cid, owner = hexId, job = job, rank = rank }
    exports.ghmattimysql:execute(q, v)
end

--[[
    -- Type: Function
    -- Name: SetRank
    -- Use: Updates a character's rank for a job
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:SetRank(user, job, rank)
    local cid = user:getCurrentCharacter().id
    local q = [[UPDATE jobs_whitelist SET rank = @rank WHERE cid = @cid AND job = @job]]
    local v = { cid = cid, rank = rank, job = job }
    exports.ghmattimysql:execute(q, v)
end

--[[
    -- Type: Function
    -- Name: SetJob
    -- Use: Assigns a job to a user
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function NPX.Jobs:SetJob(user, job, notify, callback)
    if not user or type(job) ~= "string" then return false end
    if not user:getVar("characterLoaded") then return false end

    NPX.Jobs:CanBecomeJob(user, job, function(allowed, reason, rank)
        if not allowed then
            if reason and type(reason) == "string" then
                TriggerClientEvent("DoLongHudText", user.source, tostring(reason), 1)
            end
            return
        end

        local src = user:getVar("source")
        local oldJob = user:getVar("job")

        if oldJob then
            NPX.Jobs.CurPlayerJobs[oldJob][src] = nil
        end

        user:setVar("job", job)
        NPX.Jobs.CurPlayerJobs[job][src] = {
            rank = rank or 0,
            lastPayCheck = os.time(),
            isWhiteListed = false
        }

        local name = NPX.Jobs.ValidJobs[job].name

        TriggerClientEvent("np-jobmanager:playerBecameJob", src, job, name, false)
        TriggerClientEvent("np-jobmanager:playerBecomeEvent", src, job, name, notify)

        if NPX.Jobs:CountJob("trucker") >= 1 then
            TriggerEvent("lscustoms:IsTruckerOnline", true)
        else
            TriggerEvent("lscustoms:IsTruckerOnline", false)
        end

        if callback then callback() end
    end)
end

AddEventHandler("playerDropped", function()
    local src = source
    for job, players in pairs(NPX.Jobs.CurPlayerJobs) do
        players[src] = nil
    end
end)

AddEventHandler("np-base:characterLoaded", function(user)
    NPX.Jobs:SetJob(user, "unemployed", false)
end)

-- Exports registration after resources are ready
AddEventHandler("np-base:exportsReady", function()
    exports["np-base"]:addModule("JobManager", NPX.Jobs)
end)

local policebonus, emsbonus, civbonus = 0, 0, 0

RegisterNetEvent('updatePays', function(policeBonus, emsBonus, civBonus)
    policebonus = policeBonus
    emsbonus = emsBonus
    civbonus = civBonus
end)

RegisterNetEvent('updateSinglePays', function(bonus, bonusType)
    if bonusType == 'police' then
        policebonus = bonus
    elseif bonusType == 'ems' then
        emsbonus = bonus
    elseif bonusType == 'civilian' then
        civbonus = bonus
    end
end)

CreateThread(function()
    while true do
        local curTime = os.time()
        for job, tbl in pairs(NPX.Jobs.CurPlayerJobs) do
            local payCheck = NPX.Jobs.ValidJobs[job].paycheck
            if payCheck then
                if job == "police" then
                    payCheck = payCheck + policebonus
                elseif job == "ems" then
                    payCheck = payCheck + emsbonus
                else
                    payCheck = payCheck + civbonus
                end

                for src, data in pairs(tbl) do
                    if curTime - data.lastPayCheck >= 1200 then
                        NPX.Jobs.CurPlayerJobs[job][src].lastPayCheck = curTime
                        TriggerEvent("server:givepayJob", job, math.floor(payCheck), src)
                        local user = exports["np-base"]:getModule("Player"):GetUser(src)
                        if user then
                            exports["np-log"]:AddLog("Job Pay", user, "User received paycheck, amount: " .. tostring(payCheck))
                        end
                    end
                end
            end
        end
        Wait(1200000) -- 20 minutes
    end
end)

RegisterNetEvent('jobssystem:jobs', function(job, src)
    src = src ~= nil and src ~= 0 and src or source
    local jobs = exports["np-base"]:getModule("JobManager")
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user or not jobs then return end
    jobs:SetJob(user, tostring(job))
end)

RegisterCommand('setjob', function(source, args)
    TriggerEvent('jobssystem:jobs', args[1], source)
end)

RegisterCommand('addwhitelist', function(source, args)
    local user = exports["np-base"]:getModule("Player"):GetUser(tonumber(args[1]))
    local jobs = exports["np-base"]:getModule("JobManager")
    if user and jobs then
        jobs:AddWhiteList(user, args[2], args[3])
    end
end)

