local insidePrompt = false
local guiEnabled = false
local activeTasks = {}
local coffeetimer = 0
local taskInProcess = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Displays the taskbar NUI with initial parameters
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function openGui(length, taskID, label, keepWeapon)
    if not keepWeapon then
        TriggerEvent("actionbar:setEmptyHanded")
    end
    guiEnabled = true
    SendNUIMessage({ runProgress = true, Length = length, Task = taskID, name = label })
end

--[[
    -- Type: Function
    -- Name: updateGui
    -- Use: Updates the progress bar during a task
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function updateGui(progress, taskID, label)
    SendNUIMessage({ runUpdate = true, Length = progress, Task = taskID, name = label })
end

--[[
    -- Type: Function
    -- Name: closeGuiFail
    -- Use: Closes the taskbar when a task fails
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function closeGuiFail()
    guiEnabled = false
    SendNUIMessage({ closeFail = true })
    ClearPedTasks(PlayerPedId())
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Closes the taskbar when a task completes
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeGui()
    guiEnabled = false
    SendNUIMessage({ closeProgress = true })
    ClearPedTasks(PlayerPedId())
end

--[[
    -- Type: Function
    -- Name: closeNormalGui
    -- Use: Hides the taskbar without clearing tasks
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeNormalGui()
    guiEnabled = false
end

--[[
    -- Type: Function
    -- Name: coffee:drink (event handler)
    -- Use: Handles coffee consumption speed boost
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('coffee:drink')
AddEventHandler('coffee:drink', function()
    if coffeetimer > 0 then
        coffeetimer = 6000
        TriggerEvent("Evidence:StateSet", 27, 6000)
        return
    end

    TriggerEvent("Evidence:StateSet", 27, 6000)
    coffeetimer = 6000

    while coffeetimer > 0 do
        coffeetimer = coffeetimer - 1
        Wait(1000)
    end
end)

--[[
    -- Type: Function
    -- Name: taskBar
    -- Use: Runs a timed task with optional checks and vehicle handling
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function taskBar(length, label, runCheck, keepWeapon, vehicle, vehCheck)
    local playerPed = PlayerPedId()
    if taskInProcess then
        return 0
    end

    if coffeetimer > 0 then
        length = math.ceil(length * 0.66)
    end

    taskInProcess = true
    local taskId = "taskid" .. math.random(1000000)
    openGui(length, taskId, label, keepWeapon)
    activeTasks[taskId] = 1

    local maxCount = GetGameTimer() + length
    local curTime = GetGameTimer()

    while activeTasks[taskId] == 1 do
        Wait(1)
        curTime = GetGameTimer()

        if curTime > maxCount or not guiEnabled then
            activeTasks[taskId] = 2
        end

        local progress = 100 - (((maxCount - curTime) / length) * 100)
        progress = math.min(100, progress)
        updateGui(progress, taskId, label)

        if runCheck then
            if IsPedClimbing(playerPed) or IsPedJumping(playerPed) or IsPedSwimming(playerPed) then
                SetPlayerControl(PlayerId(), false, 0)
                local total = math.ceil(progress)
                taskInProcess = false
                closeGuiFail()
                Wait(1000)
                SetPlayerControl(PlayerId(), true, 0)
                Wait(1000)
                return total
            end
        end

        if vehicle and vehicle ~= 0 then
            local driverPed = GetPedInVehicleSeat(vehicle, -1)
            if driverPed ~= playerPed and vehCheck then
                SetPlayerControl(PlayerId(), false, 0)
                local total = math.ceil(progress)
                taskInProcess = false
                closeGuiFail()
                Wait(1000)
                SetPlayerControl(PlayerId(), true, 0)
                Wait(1000)
                return total
            end

            local model = GetEntityModel(vehicle)
            if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
                if IsEntityInAir(vehicle) then
                    Wait(1000)
                    if IsEntityInAir(vehicle) then
                        local total = math.ceil(progress)
                        taskInProcess = false
                        closeGuiFail()
                        Wait(1000)
                        return total
                    end
                end
            end
        end
    end

    curTime = GetGameTimer()
    local result = activeTasks[taskId]
    if result == 2 then
        local total = math.ceil(100 - (((maxCount - curTime) / length) * 100))
        total = math.min(100, total)
        taskInProcess = false
        closeGuiFail()
        return total
    end

    closeGui()
    taskInProcess = false
    return 100
end

--[[
    -- Type: Function
    -- Name: CheckCancels
    -- Use: Helper to determine if player is in a cancel state
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function CheckCancels()
    return IsPedRagdoll(PlayerPedId())
end

--[[
    -- Type: Event
    -- Name: hud:taskBar
    -- Use: External trigger for simple timed tasks
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('hud:taskBar')
AddEventHandler('hud:taskBar', function(length, label)
    taskBar(length, label)
end)

--[[
    -- Type: Event
    -- Name: hud:insidePrompt
    -- Use: Toggles prompt state for UI interactions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('hud:insidePrompt')
AddEventHandler('hud:insidePrompt', function(bool)
    insidePrompt = bool
end)

--[[
    -- Type: Event
    -- Name: event:control:taskBar
    -- Use: Handles keybind controls for various UIs
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('event:control:taskBar')
AddEventHandler('event:control:taskBar', function(useID)
    if useID == 1 and not insidePrompt then
        TriggerEvent("radioGui")
    elseif useID == 2 and not insidePrompt then
        TriggerEvent("stereoGui")
    elseif useID == 3 and not insidePrompt then
        TriggerEvent("phoneGui")
    elseif useID == 4 and not insidePrompt then
        TriggerEvent("inventory-open-request")
    elseif useID == 5 and guiEnabled then
        closeGuiFail()
    end
end)

--[[
    -- Type: Callback
    -- Name: taskCancel
    -- Use: Handles task cancellation from NUI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('taskCancel', function(data, cb)
    closeGui()
    local taskIdentifier = data.tasknum
    activeTasks[taskIdentifier] = 2
end)

--[[
    -- Type: Callback
    -- Name: taskEnd
    -- Use: Marks the task as finished from NUI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('taskEnd', function(data, cb)
    closeNormalGui()
    local taskIdentifier = data.tasknum
    activeTasks[taskIdentifier] = 3
end)

