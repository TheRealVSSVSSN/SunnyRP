--[[
    -- Type: Server Script
    -- Name: sv_commands
    -- Use: Builds command permissions based on player roles and whitelist data
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local commands = require('sv_list')

--[[
    -- Type: Function
    -- Name: isSafe
    -- Use: Validates if a command is allowed for a player's role
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isSafe(police, ems, doctor, judge, driving, tow, jobEnum, job)
    if not jobEnum then return false end
    if jobEnum.F then return true end
    if jobEnum.P and police and job == 'police' then return true end
    if jobEnum.E and ems and job == 'ems' then return true end
    if jobEnum.NE and job == 'ems' then return true end
    if jobEnum.D and doctor and job == 'doctor' then return true end
    if jobEnum.J and judge and job == 'judge' then return true end
    if jobEnum.DI and driving and job == 'driving' then return true end
    if jobEnum.T and tow and job == 'tow' then return true end
    return false
end

--[[
    -- Type: Function
    -- Name: buildCommands
    -- Use: Assigns valid commands to a player based on job and whitelist
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function buildCommands(job, src)
    local Lsrc = src or source
    local commandExport = exports['np-base']:getModule('Commands')
    local user = exports['np-base']:getModule('Player'):GetUser(Lsrc)
    if not user then return end
    local charID = user:getVar('character').id
    local hexID = user:getVar('hexid')

    commandExport:RemoveAllSelfCommands(Lsrc)

    IsWhiteListed(hexID, charID, function(police, ems, doctor, driving, tow)
        IsWhiteListedJudge(charID, function(judge)
            for _, v in ipairs(commands) do
                if isSafe(police, ems, doctor, judge, driving, tow, v[3], job) then
                    commandExport:AddCommandValid(v[1], v[2], Lsrc, v[4])
                end
            end
        end)
    end)

    TriggerEvent('admin:reBuildAdminCommands', Lsrc)
    TriggerEvent('isVip', Lsrc)
end

RegisterServerEvent('np-commands:buildCommands')
AddEventHandler('np-commands:buildCommands', buildCommands)

AddEventHandler('np-jobmanager:playerBecameJob', function(src, job)
    buildCommands(job, src)
end)

--[[
    -- Type: Function
    -- Name: IsWhiteListed
    -- Use: Checks job whitelist for a character
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function IsWhiteListed(hexId, characterId, callback)
    if not hexId or not characterId then
        callback(false, false, false, false, false)
        return
    end

    local q = [[SELECT job, rank FROM jobs_whitelist WHERE cid = @cid;]]
    local v = { ['cid'] = characterId }

    exports.ghmattimysql:execute(q, v, function(results)
        if not results then
            callback(false, false, false, false, false)
            return
        end

        local police, ems, doctor, driving, tow = false, false, false, false, false
        for _, r in ipairs(results) do
            if r.job == 'police' and r.rank >= 1 then police = true end
            if r.job == 'ems' and r.rank >= 1 then ems = true end
            if r.job == 'doctor' and r.rank >= 1 then doctor = true end
            if r.job == 'driving' and r.rank >= 1 then driving = true end
            if r.job == 'tow' and r.rank >= 1 then tow = true end
        end

        callback(police, ems, doctor, driving, tow)
    end)
end

--[[
    -- Type: Function
    -- Name: IsWhiteListedJudge
    -- Use: Determines if a character has judge permissions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function IsWhiteListedJudge(characterId, callback)
    if not characterId then
        callback(false)
        return
    end

    exports.ghmattimysql:execute(
        'SELECT judge_type FROM characters WHERE id = @cid',
        { ['cid'] = characterId },
        function(result)
            if not result then
                callback(false)
                return
            end
            local isJudge = false
            if result[1] and result[1].judge_type and result[1].judge_type >= 1 then
                isJudge = true
            end
            callback(isJudge)
        end
    )
end

