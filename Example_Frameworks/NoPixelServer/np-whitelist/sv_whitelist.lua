--[[
    -- Type: Table
    -- Name: WhiteList
    -- Use: Handles whitelist and priority logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
WhiteList = {
    list = {},
    Lottery = {},
    Ready = false,
    Emergency = {
        ready = false,
        pd = {},
        ems = {},
        doctor = {},
        judge = {},
        therapist = {},
        doc = {},
        approved = {}
    }
}

--[[
    -- Type: Function
    -- Name: WhiteList.Init
    -- Use: Initialize whitelist data and register queue callback
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.Init()
    local function fetchWhiteList()
        WhiteList.LoadWhiteList(true, function(result)
            if not result then print("^3 ERROR LOADING WHITELIST ^7") end
        end)

        WhiteList.LoadEmergencyJobs(function(result)
            if not result then print("^3 ERROR LOADING EMS AND PD CHARS ^7") end
        end)
    end

    fetchWhiteList()
    Queue.OnJoin(WhiteList.OnJoin)
end

--[[
    -- Type: Function
    -- Name: WhiteList.LoadEmergencyJobs
    -- Use: Cache emergency service job steam IDs
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.LoadEmergencyJobs(callback)
    local q = [[
        SELECT
            t1.job,
            t2.owner
        FROM
            jobs_whitelist t1
        INNER JOIN
            characters t2 ON t1.cid = t2.id;
    ]]

    exports.ghmattimysql:execute(q, function(result)
        if not result then callback(false) return end

        local map = {
            therapist = "therapist",
            doctor = "doctor",
            judge = "judge",
            police = "pd",
            ems = "ems",
            doc = "doc"
        }

        for _, data in ipairs(result) do
            local steamid = Queue.Exports:HexIdToSteamId(data.owner)
            local key = map[data.job]
            if key then
                WhiteList.Emergency[key][steamid] = true
            end
        end

        WhiteList.Emergency.ready = true
        callback(true)
    end)
end

--[[
    -- Type: Function
    -- Name: WhiteList.LoadWhiteList
    -- Use: Load whitelist users and priority from database
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.LoadWhiteList(init, callback)
    if init then
        local function refresh()
            WhiteList.LoadWhiteList(false, callback)
            WhiteList.LoadEmergencyJobs(function(result)
                if not result then print("^3 ERROR LOADING EMS AND PD CHARS ^7") end
            end)
        end
        refresh()
    end

    local function setPriority(list)
        local tmp = {}
        for _, data in ipairs(list) do
            local steamid = string.lower(data.steamid)
            tmp[steamid] = tonumber(data.power)
            WhiteList.list[steamid] = true
        end
        Queue.AddPriority(tmp)
        WhiteList.Ready = true
    end

    local q = [[SELECT steamid,power FROM users_whitelist;]]

    exports.ghmattimysql:execute(q, {}, function(result)
        if not result then callback(false) return end
        setPriority(result)
        callback(result)
    end)
end

--[[
    -- Type: Function
    -- Name: WhiteList.GetSteamId
    -- Use: Retrieve player's steam identifier
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.GetSteamId(src)
    if not src then return false end

    local ids = Queue.Exports:GetIds(src)
    if not ids then return false end

    for _, id in ipairs(ids) do
        if string.sub(id, 1, 5) == "steam" then
            return Queue.Exports:HexIdToSteamId(id)
        end
    end
end

--[[
    -- Type: Function
    -- Name: WhiteList.IsBanned
    -- Use: Check if player is banned
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.IsBanned(src, callback)
    exports["np-base"]:getModule("Admin").DB:IsPlayerBanned(src, function(code, msg, unbandate)
        if not code then callback(true, "Error checking ban") return end

        if code == 0 then
            callback(true, msg)
        elseif code == 1 then
            callback(true, msg, unbandate)
        elseif code == 2 then
            callback(false)
        end
    end)
end

--[[
    -- Type: Function
    -- Name: WhiteList.PriorityLottery
    -- Use: Randomly upgrade priority for players with base priority
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.PriorityLottery(src)
    local steamid = WhiteList.GetSteamId(src)
    local ids = GetPlayerIdentifiers(src)
    if not ids or not steamid then return false end

    local curPriority = Queue.Exports:IsPriority(ids)
    if curPriority ~= 1 then return end

    if WhiteList.Lottery[steamid] ~= nil then return end
    WhiteList.Lottery[steamid] = false

    if WhiteList.Lottery[steamid] then
        Queue.AddPriority(steamid, 2)
        return
    end

    math.randomseed(GetGameTimer())
    if math.random(1, 100) > 82 then
        WhiteList.Lottery[steamid] = true
        Queue.AddPriority(steamid, 2)
        Queue.Exports:DebugPrint(("%s [%s] was given RNG priority %d"):format(GetPlayerName(src), steamid, 2))
    end
end

--[[
    -- Type: Function
    -- Name: WhiteList.EmergencyPriority
    -- Use: Grant priority based on emergency service roles
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.EmergencyPriority(src)
    local steamid = WhiteList.GetSteamId(src)
    local ids = GetPlayerIdentifiers(src)
    if not ids or not steamid then return false end

    local curPower = Queue.Exports:IsPriority(ids)
    if not curPower or curPower >= 10 then return false end

    local jobs = exports["np-base"]:getModule("JobManager")

    local emsCount = jobs:CountJob("ems")
    local pdCount = jobs:CountJob("police")
    local dtrCount = jobs:CountJob("doctor")
    local thrCount = jobs:CountJob("therapist")
    local judgeCount = jobs:CountJob("judge")
    local docCount = jobs:CountJob("doc")

    local power
    if WhiteList.Emergency.pd[steamid] then
        power = pdCount <= 14 and 8 or 5
    elseif WhiteList.Emergency.ems[steamid] then
        power = emsCount <= 6 and 8 or 5
    elseif WhiteList.Emergency.doctor[steamid] then
        power = dtrCount <= 2 and 8 or 5
    elseif WhiteList.Emergency.therapist[steamid] then
        power = thrCount <= 1 and 6 or 5
    elseif WhiteList.Emergency.judge[steamid] then
        power = judgeCount <= 1 and 10 or 5
    elseif WhiteList.Emergency.doc[steamid] then
        power = docCount <= 10 and 6 or 5
    end

    if not power or power <= curPower then return false end

    Queue.AddPriority(steamid, power)
    return true
end

--[[
    -- Type: Function
    -- Name: WhiteList.OnJoin
    -- Use: Verify whitelist and ban status when player joins queue
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function WhiteList.OnJoin(src, ids, deferrals)
    deferrals.defer()
    deferrals.update("Checking whitelist...")

    if not WhiteList.Ready then
        deferrals.done("Whitelist not ready, please try again.")
        return
    end

    WhiteList.IsBanned(src, function(banned, msg)
        if banned then
            deferrals.done(msg or "You are banned.")
            return
        end

        local steamid = WhiteList.GetSteamId(src)
        if not steamid or not WhiteList.list[steamid] then
            deferrals.done("You are not whitelisted.")
            return
        end

        WhiteList.EmergencyPriority(src)
        WhiteList.PriorityLottery(src)
        deferrals.done()
    end)
end

--[[
    -- Type: Event
    -- Name: onResourceStart
    -- Use: Start whitelist when resource starts
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler("onResourceStart", function(res)
    if res == GetCurrentResourceName() then
        WhiteList.Init()
    end
end)
