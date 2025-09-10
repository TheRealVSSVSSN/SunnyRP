local instructorActions = {}

--[[
    -- Type: Function
    -- Name: bool_to_number
    -- Use: Converts boolean to integer for DB storage
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
local function bool_to_number(b)
    return b and 1 or 0
end

--[[
    -- Type: Function
    -- Name: is_int
    -- Use: Validates value is an integer
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
local function is_int(n)
    return type(n) == "number" and math.floor(n) == n
end

--[[
    -- Type: Function
    -- Name: checkForWhiteList
    -- Use: Checks if player is whitelisted for a job
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
local function checkForWhiteList(hexId, characterId, job, callback)
    if not hexId or not characterId then return end

    local q = [[SELECT job, rank FROM jobs_whitelist WHERE cid = @cid]]
    local v = { ['cid'] = characterId }

    exports.ghmattimysql:execute(q, v, function(results)
        if not results then return callback(false) end
        local whitelist = false
        for _, r in ipairs(results) do
            if r.job == job and r.rank >= 1 then
                whitelist = true
                break
            end
        end
        callback(whitelist)
    end)
end

--[[
    -- Type: Event
    -- Name: driving:submitTest
    -- Use: Stores driving test results to database
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:submitTest')
AddEventHandler('driving:submitTest', function(data)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then
        TriggerClientEvent('DoShortHudText', src, 'Failed to get results, please try again in a minute...', 2)
        return
    end
    local userjob = user:getVar('job') or 'unemployed'
    if userjob ~= 'driving instructor' then return end

    local instructorChar = user:getCurrentCharacter()
    local instructorName = (data and data.instructor and data.instructor ~= '') and data.instructor or (instructorChar.first_name .. ' ' .. instructorChar.last_name)

    local drivingTest = {
        cid = tonumber(data.cid),
        icid = instructorChar.id,
        instructor = instructorName,
        timestamp = os.time(),
        points = tonumber(data.points),
        passed = bool_to_number(data.passed),
        results = json.encode(data.results or {})
    }

    exports.ghmattimysql:execute(
        "INSERT INTO driving_tests (cid, icid, instructor, timestamp, points, passed, results) VALUES (@cid, @icid, @instructor, @timestamp, @points, @passed, @results)",
        drivingTest,
        function(rowsChanged)
            if rowsChanged and rowsChanged > 0 then
                exports.ghmattimysql:execute("SELECT id FROM driving_tests WHERE cid = @cid AND icid = @icid AND timestamp = @timestamp", {
                    cid = drivingTest.cid,
                    icid = drivingTest.icid,
                    timestamp = drivingTest.timestamp
                }, function(response)
                    if response[1] then
                        TriggerClientEvent('player:recieveItem', src, 'drivingtest', 1, true, {
                            id = tonumber(response[1].id),
                            cid = drivingTest.cid,
                            instructor = drivingTest.instructor,
                            date = os.date('%Y %m %d', drivingTest.timestamp)
                        })
                        TriggerClientEvent('DoShortHudText', src, 'You received a copy of the driving test.', 1)
                    else
                        TriggerClientEvent('DoShortHudText', src, 'Failed to submit the test! Please try again.', 2)
                    end
                end)
            else
                TriggerClientEvent('DoShortHudText', src, 'Failed to submit the test! Please try again.', 2)
            end
        end
    )
end)

--[[
    -- Type: Event
    -- Name: driving:getHistory
    -- Use: Returns recent driving tests for a citizen
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:getHistory')
AddEventHandler('driving:getHistory', function(cid)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then
        TriggerClientEvent('DoShortHudText', src, 'Failed to get results, please try again in a minute...', 1)
        return
    end
    local userjob = user:getVar('job') or 'Unemployed'
    if userjob ~= 'driving instructor' and userjob ~= 'police' and userjob ~= 'judge' then return end
    if not cid then
        TriggerClientEvent('DoShortHudText', src, 'Enter a persons CID to retrieve a list of past driving tests.', 2)
        return
    end

    exports.ghmattimysql:execute("SELECT id, instructor FROM driving_tests WHERE cid = @cid ORDER BY id DESC LIMIT 5", { cid = tonumber(cid) }, function(response)
        if not response or #response == 0 then
            TriggerClientEvent('chatMessage', src, "[Driving History for #" .. cid .. "]", 5, "- No tests found -")
        else
            local lines = ""
            for _, test in ipairs(response) do
                lines = lines .. ("\n Test ID: %d | Instructor: %s"):format(test.id, test.instructor)
            end
            TriggerClientEvent('chatMessage', src, "[Driving History for #" .. cid .. "]", 5, lines)
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: driving:getReport
    -- Use: Sends a copy of a driving test to the player
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:getReport')
AddEventHandler('driving:getReport', function(tID)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then
        TriggerClientEvent('DoShortHudText', src, 'Failed to get results, please try again in a minute...', 1)
        return
    end
    local userjob = user:getVar('job') or 'Unemployed'
    if userjob ~= 'driving instructor' and userjob ~= 'police' and userjob ~= 'judge' then return end

    local testID = tonumber(tID)
    if not testID or not is_int(testID) then
        TriggerClientEvent('DoShortHudText', src, 'Enter a driving test ID number to retrieve the report for.', 2)
        return
    end

    exports.ghmattimysql:execute("SELECT * FROM driving_tests WHERE id = @testID", { testID = testID }, function(response)
        if response and response[1] then
            local test = response[1]
            TriggerClientEvent('player:recieveItem', src, 'drivingtest', 1, true, {
                id = test.id,
                cid = test.cid,
                instructor = test.instructor,
                date = os.date('%Y %m %d', test.timestamp)
            })
            TriggerClientEvent('DoShortHudText', src, 'You received a copy of the driving test.', 1)
        else
            TriggerClientEvent('DoShortHudText', src, "No test was found with the ID:" .. tID, 2)
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: driving:getResults
    -- Use: Sends driving test data to the client for viewing
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:getResults')
AddEventHandler('driving:getResults', function(tID)
    local src = source
    local testID = tonumber(tID)
    if not testID or not is_int(testID) then
        TriggerClientEvent('DoShortHudText', src, 'Failed to get driving test results', 2)
        return
    end

    exports.ghmattimysql:execute("SELECT * FROM driving_tests WHERE id = @testID", { testID = testID }, function(response)
        if response and response[1] then
            TriggerClientEvent('drivingInstructor:viewResults', src, response[1])
        else
            TriggerClientEvent('DoShortHudText', src, "No test was found with the ID:" .. tID, 2)
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: driving:vehicleAction
    -- Use: Relays instructor vehicle actions to driver
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:vehicleAction')
AddEventHandler('driving:vehicleAction', function(dID, action)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end
    local userjob = user:getVar('job') or 'Unemployed'
    if userjob ~= 'driving instructor' and userjob ~= 'police' and userjob ~= 'judge' then return end

    local driverId = tonumber(dID)
    if not driverId then return end

    instructorActions[src] = driverId
    TriggerClientEvent('drivingInstructor:vehicleAction', driverId, action)
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Clears active instructor actions when instructor disconnects
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end
    local userjob = user:getVar('job') or 'Unemployed'
    if userjob == 'driving instructor' then
        local lastActionID = instructorActions[src]
        if lastActionID and lastActionID > 0 then
            TriggerClientEvent('drivingInstructor:vehicleAction', lastActionID, 4)
            instructorActions[src] = nil
        end
    end
end)

--[[
    -- Type: Event
    -- Name: np-base:characterLoaded
    -- Use: Applies whitelist and job on character load
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
AddEventHandler('np-base:characterLoaded', function(user, char)
    local src = source
    local hexId = user:getVar('hexId')
    local cid = char.id

    checkForWhiteList(hexId, cid, 'driving instructor', function(whiteListed)
        if whiteListed then
            local jobs = exports['np-base']:getModule('JobManager')
            jobs:SetJob(user, 'driving instructor', false)
        end
    end)
end)

--[[
    -- Type: Event
    -- Name: driving:toggleInstructorMode
    -- Use: Toggles instructor mode for the player
    -- Created: 2024-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('driving:toggleInstructorMode')
AddEventHandler('driving:toggleInstructorMode', function(toggle)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end
    local char = user:getCurrentCharacter()
    local newState = not toggle
    TriggerClientEvent('drivingInstructor:instructorToggle', src, newState, char.first_name .. ' ' .. char.last_name)
end)
