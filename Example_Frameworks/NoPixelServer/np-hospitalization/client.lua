local curDoctors, curPolice, curEms, curTaxi, curTow = 0, 0, 0, 0, 0
local isTriageEnabled = false

--[[
    -- Type: Table
    -- Name: interactionPoints
    -- Use: Locations for hospital interactions
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
local interactionPoints = {
    { coords = vector3(309.23, -593.03, 43.36), name = "[E] Check In" },
    { coords = vector3(307.93, -594.99, 43.29), name = "[E] Prescriptions" },
    { coords = vector3(312.3,  -592.4,  43.29), name = "[E] Results" },
    { coords = vector3(343.77, -591.44, 43.29), name = "[E] Check Up" }
}

--[[
    -- Type: Table
    -- Name: pedSpawns
    -- Use: Coordinates for ambient hospital NPCs
--]]
local pedSpawns = {
    vector4(326.2477, -583.0090, 43.3174, 330.01),
    vector4(308.5078, -596.7372, 43.2918,   9.66),
    vector4(305.0848, -598.1174, 43.2918,  74.24),
    vector4(331.9149, -576.8653, 43.3172,  66.37),
    vector4(344.1036, -586.1152, 43.3150, 143.52),
    vector4(347.2256, -587.9169, 43.3150,  67.97)
}

-- Helper to load animation dictionaries
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Helper to load models
local function loadModel(model)
    if type(model) == 'string' then model = GetHashKey(model) end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    return model
end

-- Draw 3D text at given coordinates
local function drawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: handleHospitalAction
    -- Use: Handles interaction prompts
--]]
RegisterNetEvent('event:control:hospitalization')
AddEventHandler('event:control:hospitalization', function(id)
    if id == 1 then
        loadAnimDict('anim@narcotics@trash')
        TaskPlayAnim(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0, 1.0, -1, 1, 0, false, false, false)
        local finished = exports['np-taskbar']:taskBar(1700, 'Checking Credentials')
        if finished == 100 then
            if curDoctors > 0 and not isTriageEnabled then
                TriggerEvent('DoLongHudText', 'A doctor has been paged. Please take a seat and wait.', 2)
                TriggerServerEvent('phone:triggerPager')
            else
                TriggerEvent('bed:checkin')
            end
        end
    elseif id == 2 then
        DoHospitalCheck(1)
    elseif id == 3 then
        DoHospitalCheck(2)
    elseif id == 4 then
        DoHospitalCheck(3)
    end
end)

-- Thread to display interaction prompts
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i, point in ipairs(interactionPoints) do
            if #(point.coords - pos) < 5.0 then
                local text = point.name
                if i == 1 and curDoctors > 0 and not isTriageEnabled then
                    text = 'Press [E] to page a doctor'
                end
                drawText3D(point.coords, text)
            end
        end
        Wait(1)
    end
end)

-- Hospitalization state
local hospitalization = { level = 0, illness = 'None', time = 0 }
local skipCheckup = false
local checkupCounter = 45 + math.random(10, 25)
local mychecktype = 0

RegisterNetEvent('client:hospitalization:status')
AddEventHandler('client:hospitalization:status', function(level, illness, time)
    hospitalization.level = level
    hospitalization.illness = illness
    hospitalization.time = time
    if illness == 'icu' and not ICU then
        ICUscreen(false)
    elseif illness == 'dead' and not ICU then
        ICUscreen(true)
    end
end)

--[[
    -- Type: Function
    -- Name: DoHospitalCheck
    -- Use: Performs checkups and reduces illness level
--]]
function DoHospitalCheck(checkType)
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 0.9, -8, 1500, 49, 0, false, false, false)
    local finished = exports['np-taskbar']:taskBar(10000, 'Checking Credentials')
    if finished == 100 then
        if hospitalization.level > 0 and skipCheckup and checkType == mychecktype then
            skipCheckup = false
            TriggerEvent('client:newStress', false, math.random(500))
            hospitalization.level = hospitalization.level - 1
            TriggerServerEvent('stress:illnesslevel', hospitalization.level)
            TriggerEvent('chatMessage', 'EMAIL ', 8, 'You are looking healthier already! Successful Checkup')
        else
            TriggerEvent('DoLongHudText', 'It appears your name isnt on this list? Please wait for a call.', 1)
        end
    end
end

ICU = false
local dead = false
local counter = 0

--[[
    -- Type: Function
    -- Name: ICUscreen
    -- Use: Handles ICU and death states
--]]
function ICUscreen(dying)
    counter = 0
    ICU = true
    dead = false
    while ICU do
        SetEntityCoords(PlayerPedId(), 345.02133, -590.51825, 60.10908)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityHealth(PlayerPedId(), 200.0)
        SetEntityInvincible(PlayerPedId(), true)
        Wait(2300)
        if math.random(15) > 14 then
            TriggerEvent('changethirst')
            TriggerEvent('changehunger')
        end
        TriggerEvent('InteractSound_CL:PlayOnOne', 'ventilator', 0.2)
        counter = counter + 1
        if counter > 20 then
            dead = true
        end
        if dead then
            if dying then
                TriggerEvent('InteractSound_CL:PlayOnOne', 'heartmondead', 0.5)
                Wait(9500)
            end
            ICU = false
            logout()
            return
        end
    end
end

--[[
    -- Type: Function
    -- Name: logout
    -- Use: Resets player state when leaving ICU
--]]
function logout()
    TriggerEvent('np-base:clearStates')
    exports['np-base']:getModule('SpawnManager'):Initialize()
end

-- Disable controls while in ICU
CreateThread(function()
    while true do
        if ICU then
            DrawRect(0, 0, 10.0, 10.0, 1, 1, 1, 255)
            DisableControlAction(0, 47, true)
        end
        Wait(1)
    end
end)

-- Checkup reminder thread
local checktypes = {
    [1] = 'Prescription Pickup',
    [2] = 'Result Review',
    [3] = 'Injury Checkup'
}
CreateThread(function()
    while true do
        Wait(60000)
        if hospitalization.illness == 'ICU' and not ICU then
            ICUscreen(false)
        end
        if hospitalization.illness == 'DEAD' and not ICU then
            ICUscreen(true)
        end
        if checkupCounter > 0 then
            if hospitalization.level > 0 and checkupCounter == 45 and not skipCheckup then
                mychecktype = math.random(1, 3)
                TriggerEvent('chatMessage', 'EMAIL ', 8, 'You are ready for your next ' .. checktypes[mychecktype] .. ' at the hospital! (Regarding: ' .. hospitalization.illness .. ') Failure to report may be bad for your health.')
                skipCheckup = true
            end
            checkupCounter = checkupCounter - 1
        else
            checkupCounter = 60 + math.random(80)
            if hospitalization.level > 0 and skipCheckup then
                TriggerEvent('client:newStress', true, math.random(500))
            end
        end
    end
end)

-- Update job counts
RegisterNetEvent('job:counts')
AddEventHandler('job:counts', function(activePolice, activeEms, activeTaxi, activeTow, activeDoctors)
    curPolice = activePolice
    curEms = activeEms
    curTaxi = activeTaxi
    curTow = activeTow
    curDoctors = activeDoctors
end)

-- Request triage state on spawn
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('doctor:setTriageState')
    TriggerEvent('loading:disableLoading')
end)

-- Receive triage state updates
RegisterNetEvent('doctor:setTriageState')
AddEventHandler('doctor:setTriageState', function(state)
    isTriageEnabled = state
end)

-- Spawn ambient hospital NPCs
RegisterNetEvent('SpawnPeds')
AddEventHandler('SpawnPeds', function()
    for _, spawn in ipairs(pedSpawns) do
        local model = randomHspPed()
        local pedModel = loadModel(model)
        local hospPed = CreatePed(4, pedModel, spawn.x, spawn.y, spawn.z, spawn.w, false, true)
        DecorSetBool(hospPed, 'ScriptedPed', true)
        TaskStartScenarioInPlace(hospPed, randomScenario(), 0, true)
        SetEntityInvincible(hospPed, true)
        TaskSetBlockingOfNonTemporaryEvents(hospPed, true)
        SetPedFleeAttributes(hospPed, 0, 0)
        SetPedCombatAttributes(hospPed, 17, 1)
        SetPedSeeingRange(hospPed, 0.0)
        SetPedHearingRange(hospPed, 0.0)
        SetPedAlertness(hospPed, 0)
        SetPedKeepTask(hospPed, true)
    end
end)

-- Random ped model
local pedModels = {
    's_m_m_doctor_01',
    's_m_m_paramedic_01',
    's_f_y_scrubs_01'
}
function randomHspPed()
    return pedModels[math.random(#pedModels)]
end

-- Random scenario for ambient peds
local scenarios = {
    'WORLD_HUMAN_CLIPBOARD',
    'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT',
    'CODE_HUMAN_MEDIC_TIME_OF_DEATH'
}
function randomScenario()
    return scenarios[math.random(#scenarios)]
end

