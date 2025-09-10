--[[
    -- Type: Client Script
    -- Name: np-taskbarskill
    -- Use: Provides a skill-based progress bar minigame
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]

local guiEnabled = false
local chance = 0
local skillGap = 20
local activeTasks = 0
local factor = 1.0
local taskInProcess = false
local calm = true

--[[
    -- Type: Function
    -- Name: setGui
    -- Use: Toggle NUI focus for the taskbar UI
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function setGui(state)
    guiEnabled = state
    SetNuiFocus(state, false)
end

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Displays the taskbar UI with the given parameters
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function openGui(length, taskID, name, chanceSent, gap)
    setGui(true)
    SendNUIMessage({
        runProgress = true,
        Length = length,
        Task = taskID,
        name = name,
        chance = chanceSent,
        skillGap = gap
    })
end

--[[
    -- Type: Function
    -- Name: updateGui
    -- Use: Updates the progress bar values during an active task
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function updateGui(length, taskID, name, chanceSent, gap)
    SendNUIMessage({
        runUpdate = true,
        Length = length,
        Task = taskID,
        name = name,
        chance = chanceSent,
        skillGap = gap
    })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Closes the taskbar UI after completion or cancellation
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function closeGui()
    setGui(false)
    SendNUIMessage({ closeProgress = true })
end

--[[
    -- Type: Function
    -- Name: closeGuiFail
    -- Use: Closes the taskbar UI when the task fails
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function closeGuiFail()
    setGui(false)
    SendNUIMessage({ closeFail = true })
end

--[[
    -- Type: Function
    -- Name: closeNormalGui
    -- Use: Removes focus without sending close messages
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function closeNormalGui()
    setGui(false)
end

--[[
    -- Type: Function
    -- Name: FactorFunction
    -- Use: Adjusts difficulty factor based on success or failure
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function FactorFunction(pos)
    if not pos then
        factor = factor - 0.1
        if factor < 0.1 then
            factor = 0.1
        end
        if factor == 0.5 and calm then
            calm = false
            TriggerEvent("notification", "You are frustrated", 2)
        end
        TriggerEvent("factor:restore")
    else
        if factor > 1.0 or factor == 0.9 then
            if not calm then
                TriggerEvent("notification", "You are calm again")
                calm = true
            end
            factor = 1.0
            return
        end
        factor = factor + 0.1
    end
end

RegisterNetEvent('factor:restore')
AddEventHandler('factor:restore', function()
    Wait(15000)
    FactorFunction(true)
end)

RegisterNUICallback('taskCancel', function(_, cb)
    closeGui()
    activeTasks = 2
    FactorFunction(false)
    cb('ok')
end)

RegisterNUICallback('taskEnd', function(data, cb)
    closeNormalGui()
    local result = tonumber(data.taskResult) or 0
    if result < (chance + 20) and result > chance then
        activeTasks = 3
        factor = 1.0
    else
        FactorFunction(false)
        activeTasks = 2
    end
    cb('ok')
end)

--[[
    -- Type: Function
    -- Name: taskBar
    -- Use: Starts the skill-based taskbar challenge
    -- Created: 2024-06-22
    -- By: VSSVSSN
--]]
local function taskBar(difficulty, gap)
    Wait(100)
    skillGap = gap or skillGap
    if skillGap < 5 then
        skillGap = 5
    end
    if taskInProcess then
        return 100
    end

    FactorFunction(false)
    chance = math.random(15, 90)
    local length = math.ceil(difficulty * factor)

    taskInProcess = true
    local taskIdentifier = 'taskid' .. math.random(1000000)
    openGui(length, taskIdentifier, 'E', chance, skillGap)
    activeTasks = 1

    local maxCount = GetGameTimer() + length

    while activeTasks == 1 do
        Wait(0)
        local curTime = GetGameTimer()
        if curTime > maxCount then
            activeTasks = 2
        end
        local updater = 100 - (((maxCount - curTime) / length) * 100)
        updateGui(math.min(100, updater), taskIdentifier, 'E', chance, skillGap)
    end

    closeGui()
    taskInProcess = false
    return activeTasks == 2 and 0 or 100
end

exports('taskBar', taskBar)
exports('closeGuiFail', closeGuiFail)
