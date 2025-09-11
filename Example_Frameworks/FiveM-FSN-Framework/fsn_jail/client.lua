--[[
    -- Type: Client Script
    -- Name: fsn_jail client
    -- Use: Handles jail logic for players
    -- Created: 2024-04-21
    -- By: VSSVSSN
--]]

local state = {
    time = 0,
    total = 0,
    tick = 0,
    active = false,
    lastJob = 0,
    jobId = 0
}

local jailCoords = vector3(1653.5433, 2603.8093, 45.5649)
local releaseCoords = vector3(1852.42, 2603.44, 45.672)
local boundaryCentre = vector3(1691.8677, 2606.4614, 45.5603)
local boundaryRadius = 330.0

local jobs = {
    vector3(1609.4789, 2668.8982, 45.5649),
    vector3(1608.2047, 2655.5576, 45.5649),
    vector3(1663.1888, 2635.4958, 45.5649),
    vector3(1703.9364, 2631.6931, 45.5649),
    vector3(1758.1615, 2646.4929, 45.5649),
    vector3(1779.0939, 2659.8835, 45.5649),
    vector3(1756.6636, 2677.1621, 45.5649),
    vector3(1697.4556, 2686.0820, 45.5649),
    vector3(1661.9941, 2636.4446, 45.5649),
    vector3(1649.4086, 2586.0710, 45.5649),
    vector3(1624.4453, 2577.3071, 45.5649),
    vector3(1625.0990, 2575.7471, 45.5649),
    vector3(1608.9230, 2567.0066, 45.5649),
    vector3(1609.6904, 2568.5940, 45.5649),
    vector3(1707.1981, 2481.3538, 45.5649),
    vector3(1706.1644, 2479.4211, 45.5649),
    vector3(1737.2510, 2504.7339, 45.5650),
    vector3(1735.4583, 2504.5320, 45.5650),
    vector3(1760.7621, 2519.2300, 45.5650),
    vector3(1760.8270, 2517.3140, 45.5650),
    vector3(1761.4669, 2540.3828, 45.5650),
    vector3(1760.5580, 2541.4290, 45.5650),
    vector3(1695.7876, 2535.9917, 45.5649),
    vector3(1695.1467, 2537.8662, 45.5649),
    vector3(1679.4932, 2480.4077, 45.5649),
    vector3(1678.0529, 2480.9507, 45.5649),
    vector3(1622.4355, 2507.7373, 45.5649),
    vector3(1621.6309, 2509.3667, 45.5649)
}

local function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    if outline then SetTextOutline() end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

local function teleport(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
end

local function assignJob()
    state.jobId = math.random(1, #jobs)
    state.lastJob = state.tick
    TriggerEvent('fsn_notify:displayNotification', 'You just got a new job (#' .. state.jobId .. "), head to it to reduce your sentence!", 'centerRight', 4000, 'info')
end

local function completeJob()
    local earned = math.random(60, 180)
    state.time = math.max(state.time - earned, 0)
    state.lastJob = state.tick
    state.jobId = 0
    TriggerEvent('fsn_notify:displayNotification', 'Job well done! ' .. earned .. ' seconds earned!', 'centerRight', 4000, 'success')
end

local function jailInfo()
    local inmins = math.floor(state.time / 60)
    drawTxt(1.24, 1.44, 1.0, 1.0, 0.4, 'Jailtime: ~r~' .. inmins .. '~w~ minutes remaining', 255, 255, 255, 255)
end

RegisterNetEvent('fsn_jail:spawn:receive', function(result)
    state.time = result
    if state.time >= 1 then
        TriggerEvent('fsn_jail:enter', state.time)
        TriggerServerEvent('fsn_jail:update:database', state.time)
    else
        state.time = 0
        state.active = false
    end
end)

-- compatibility with old misspelled event
RegisterNetEvent('fsn_jail:spawn:recieve', function(result)
    TriggerEvent('fsn_jail:spawn:receive', result)
end)

RegisterNetEvent('fsn_jail:enter', function(time)
    state.time = time
    state.total = time
    state.active = true
    RemoveAllPedWeapons(PlayerPedId())
    teleport(jailCoords + vector3(0.0, 0.0, 1.0))
    TriggerEvent('pNotify:SendNotification', {text = "You've been sent to jail for: " .. math.floor(state.time / 60) .. " minutes",
        layout = 'centerRight', timeout = 600, progressBar = true, type = 'info'})
    TriggerEvent('fsn_hungerandthirst:pause')
end)

RegisterNetEvent('fsn_jail:release', function()
    state.time = 0
    state.active = false
    state.jobId = 0
    teleport(releaseCoords)
    TriggerServerEvent('fsn_jail:update:database', state.time)
    TriggerEvent('pNotify:SendNotification', {text = "You've been released from jail", layout = 'centerRight', timeout = 600, progressBar = true, type = 'info'})
    TriggerEvent('fsn_hungerandthirst:unpause')
end)

-- compatibility alias
RegisterNetEvent('fsn_jail:releaseme', function()
    TriggerEvent('fsn_jail:release')
end)

RegisterNetEvent('fsn_jail:init', function(charId)
    TriggerServerEvent('fsn_jail:spawn', charId)
end)

CreateThread(function()
    while true do
        if state.active then
            Wait(0)
            local now = state.tick
            if state.jobId == 0 and (now - state.lastJob) >= 30 and state.time > (state.total / 50) then
                assignJob()
            end
            if state.jobId ~= 0 then
                local job = jobs[state.jobId]
                DrawMarker(1, job.x, job.y, job.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 90.4001, 0, 155, 255, 175, false, false, 0, false)
                if #(GetEntityCoords(PlayerPedId()) - job) < 1.0 then
                    RequestAnimDict('amb@world_human_welding@male@idle_a')
                    while not HasAnimDictLoaded('amb@world_human_welding@male@idle_a') do
                        Wait(1)
                    end
                    TaskPlayAnim(PlayerPedId(), 'amb@world_human_welding@male@idle_a', 'idle_a', 4.0, -4.0, -1, 1, 0, false, false, false)
                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName('~g~working...')
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    completeJob()
                end
            end
            jailInfo()
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if state.active then
            Wait(1000)
            state.tick = state.tick + 1
            state.time = state.time - 1
            if #(GetEntityCoords(PlayerPedId()) - boundaryCentre) > boundaryRadius then
                teleport(jailCoords)
                TriggerEvent('fsn_notify:displayNotification', 'You must stay in jail for the entirety of your sentence!', 'centerRight', 6000, 'error')
            end
            if state.time <= 0 then
                TriggerEvent('fsn_jail:release')
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if state.active then
            TriggerServerEvent('fsn_jail:update:database', state.time)
        end
    end
end)
