local function setJobState(jobId, active)
    exports.ghmattimysql:execute(
        'UPDATE delivery_job SET active = @active WHERE id = @id',
        { ['active'] = active, ['id'] = jobId }
    )
    TriggerEvent('trucker:returnCurrentJobs')
end

local function sendCurrentJobs(target)
    local jobs = {}
    exports.ghmattimysql:execute('SELECT * FROM delivery_job', {}, function(result)
        for i = 1, #result do
            jobs[#jobs + 1] = {
                id = result[i].id,
                active = tonumber(result[i].active),
                pickup = json.decode(result[i].pickup),
                JobType = result[i].jobType,
                drop = json.decode(result[i].drop),
                dropAmount = result[i].dropAmount
            }
        end
        TriggerClientEvent('trucker:updateJobs', target or -1, jobs)
    end)
end

RegisterNetEvent('trucker:CarUsed', function(id)
    local src = source
    TriggerClientEvent('trucker:acceptspawn', src, id)
end)

RegisterNetEvent('trucker:jobFinished', function(jobId)
    setJobState(jobId, 0)
end)

RegisterNetEvent('trucker:jobfailure', function(jobId)
    setJobState(jobId, 0)
end)

RegisterNetEvent('trucker:jobTaken', function(jobId)
    setJobState(jobId, 1)
end)

RegisterNetEvent('trucker:returnCurrentJobs', function()
    sendCurrentJobs(-1)
end)

RegisterCommand('truckerjoblist', function(source)
    sendCurrentJobs(source)
end)
