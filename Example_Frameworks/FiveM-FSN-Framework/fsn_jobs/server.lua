--[[ 
    -- Type: Module
    -- Name: fsn_jobs server
    -- Use: Handles server-side job tracking and paychecks
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]

local playerJobs = {}

--[[
    -- Type: Event
    -- Name: fsn_jobs:updateJob
    -- Use: Stores a player's current job on the server
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_jobs:updateJob', function(job)
    local src = source
    playerJobs[src] = job or 'Unemployed'
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Cleans up job data when a player leaves
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    playerJobs[source] = nil
end)

--[[
    -- Type: Thread
    -- Name: Paycheck loop
    -- Use: Sends salary payments based on job every 10 minutes
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(600000)
        print(':fsn_jobs: distributing paychecks')
        for src, job in pairs(playerJobs) do
            local amount = 50
            if job == 'Police' or job == 'EMS' then
                amount = 350
            elseif job == 'Mechanic' or job == 'CarDealer' or job == 'BoatDealer' or job == 'Rancher' then
                amount = 100
            elseif job == 'Taxi Driver' then
                amount = 150
            elseif job == 'Truck Driver' then
                amount = 100
            end
            TriggerClientEvent('fsn_bank:change:bankAdd', src, amount)
            TriggerClientEvent('fsn_notify:displayNotification', src, 'Salary: $'..amount, 'centerLeft', 5000, 'info')
        end
    end
end)
