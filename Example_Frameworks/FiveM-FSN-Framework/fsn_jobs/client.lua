curjob = 'Unemployed'

--[[ 
    -- Type: Function
    -- Name: fsn_GetJob
    -- Use: Returns the player's current job
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
function fsn_GetJob()
  return curjob
end

--[[ 
    -- Type: Function
    -- Name: fsn_SetJob
    -- Use: Updates the player's job and informs the server
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
function fsn_SetJob(job)
  curjob = job
  TriggerServerEvent('fsn_jobs:updateJob', job)
end

--[[ 
    -- Type: Function
    -- Name: fsn_jobs:quit handler
    -- Use: Resets job to Unemployed and notifies server
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_jobs:quit')
AddEventHandler('fsn_jobs:quit', function()
  curjob = 'Unemployed'
  TriggerServerEvent('fsn_jobs:updateJob', 'Unemployed')
end)

current_time = 0
CreateThread(function()
  while true do
    Wait(1000)
    current_time = current_time + 1
  end
end)

--[[ 
    -- Type: Event
    -- Name: onClientResourceStart
    -- Use: Sync initial job with server when resource loads
    -- Created: 2024-10-??
    -- By: VSSVSSN
--]]
AddEventHandler('onClientResourceStart', function(res)
  if res == GetCurrentResourceName() then
    TriggerServerEvent('fsn_jobs:updateJob', curjob)
  end
end)

function table.contains(tbl, element)
  for _, value in pairs(tbl) do
    if value[1] == element then
      return true
    end
  end
  return false
end
