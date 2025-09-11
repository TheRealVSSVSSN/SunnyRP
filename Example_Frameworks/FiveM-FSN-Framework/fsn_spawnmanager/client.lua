--[[ 
    -- Type: Variable
    -- Name: myChar
    -- Use: Holds current character data
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
local myChar = false

local spawnLocations = {
    { name = 'Apartment', coords = vector3(312.9697, -218.2705, 54.2218), heading = 282.91 },
    { name = 'Los Santos Airport', coords = vector3(-1037.74, -2738.04, 20.1693), heading = 282.91 },
    { name = 'Bus Station', coords = vector3(454.349, -661.036, 27.6534), heading = 282.91 },
    { name = 'Train Station', coords = vector3(-206.674, -1015.1, 30.1381), heading = 282.91 },
    { name = 'Paleto', coords = vector3(-215.027, 6218.83, 31.4915), heading = 282.91 },
    { name = 'Sandy Shores', coords = vector3(1955.54, 3843.48, 32.0165), heading = 282.91 },
    { name = 'Pier', coords = vector3(-1686.61, -1068.16, 13.1522), heading = 282.91 },
    { name = 'Legion Square', coords = vector3(238.69, -762.66, 30.82), heading = 158.23 },
    { name = 'Vinewood', coords = vector3(280.571, 182.679, 104.504), heading = 282.91 }
}

local isBusy = false
local selectedIndex = nil

local function updateNui()
    SendNUIMessage({ locs = spawnLocations })
end

--[[
    -- Type: Function
    -- Name: camToLoc
    -- Use: Moves camera to a spawn location and highlights selection
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
local function camToLoc(index)
    if isBusy then return end
    isBusy = true

    SendNUIMessage({ hide = true })

    DoScreenFadeOut(1000)
    Wait(800)
    RenderScriptCams(false, true, 500, true, true)
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, -505.09, -1224.11, 232.2, false, false, false)
    Wait(200)
    DoScreenFadeIn(1000)
    Wait(1000)

    for i = 1, #spawnLocations do
        spawnLocations[i].selected = (i == index)
    end
    selectedIndex = index

    local loc = spawnLocations[index]
    SetEntityVisible(ped, false, false)
    SetEntityCoordsNoOffset(ped, loc.coords.x, loc.coords.y, loc.coords.z, false, false, false)
    FreezeEntityPosition(ped, true)
    RenderScriptCams(true, true, 0, true, true)

    PlaySoundFrontend(-1, 'CAR_BIKE_WHOOSH', 'MP_LOBBY_SOUNDS', true)
    local startCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(startCam, -505.09, -1224.11, 232.2)
    SetCamActive(startCam, true)
    PointCamAtCoord(startCam, loc.coords.x, loc.coords.y, loc.coords.z + 200.0)

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, loc.coords.x, loc.coords.y, loc.coords.z + 200.0)
    PointCamAtCoord(cam, loc.coords.x, loc.coords.y, loc.coords.z + 2.0)
    SetCamActiveWithInterp(cam, startCam, 3700, true, true)
    PlaySoundFrontend(-1, 'CAR_BIKE_WHOOSH', 'MP_LOBBY_SOUNDS', true)
    Wait(3700)
    PlaySoundFrontend(-1, 'CAR_BIKE_WHOOSH', 'MP_LOBBY_SOUNDS', true)

    local cam2 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam2, loc.coords.x, loc.coords.y, loc.coords.z + 1.0)
    PointCamAtCoord(cam2, loc.coords.x + 10.0, loc.coords.y, loc.coords.z)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)

    isBusy = false
    updateNui()
end

--[[
    -- Type: Function
    -- Name: openGUI
    -- Use: Displays the spawn selection UI
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
local function openGUI()
    updateNui()
    SetNuiFocus(true, true)
end

RegisterNetEvent('fsn_spawnmanager:start')
AddEventHandler('fsn_spawnmanager:start', function(char)
    local ped = PlayerPedId()
    SetEntityVisible(ped, false, false)

    if char then
        myChar = char
        TriggerEvent('clothes:spawn', json.decode(char.char_model))
    else
        TriggerEvent('clothes:spawn', json.decode(myChar.char_model))
    end

    DoScreenFadeOut(1000)
    Wait(900)
    SetEntityCoordsNoOffset(ped, -505.09, -1224.11, 232.2, false, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    Wait(100)
    DoScreenFadeIn(1000)
    Wait(1000)
    openGUI()
end)

RegisterNUICallback('camToLoc', function(data, cb)
    local idx = tonumber(data.loc)
    if idx then
        camToLoc(idx + 1)
    end
    cb('ok')
end)

RegisterNUICallback('spawnAtLoc', function(_, cb)
    local loc = spawnLocations[selectedIndex]
    if not loc then
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Re-select your spawning location' })
        cb('ok')
        return
    end

    DoScreenFadeOut(1000)
    Wait(900)
    RenderScriptCams(false, true, 500, true, true)

    TriggerEvent('fsn_main:character', myChar)
    TriggerEvent('fsn_police:init', myChar.char_police)
    TriggerEvent('fsn_jail:init', myChar.char_id)
    TriggerEvent('fsn_inventory:initChar', myChar.char_inventory)
    TriggerEvent('fsn_bank:change:bankAdd', 0)
    TriggerEvent('fsn_ems:reviveMe:force')

    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Spawn: ' .. loc.name })
    TriggerServerEvent('fsn_apartments:getApartment', myChar.char_id)

    SendNUIMessage({ hide = true })
    SetNuiFocus(false, false)

    local ped = PlayerPedId()
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)

    if loc.name == 'Apartment' then
        exports['fsn_apartments']:EnterMyApartment()
        TriggerEvent('spawnme')
        TriggerEvent('clothes:spawn', json.decode(myChar.char_model))
    else
        SetEntityCoordsNoOffset(ped, loc.coords.x, loc.coords.y, loc.coords.z, false, false, false)
        SetEntityHeading(ped, loc.heading)
        TriggerEvent('spawnme')
        TriggerEvent('clothes:spawn', json.decode(myChar.char_model))
    end

    Wait(100)
    DoScreenFadeIn(1000)
    cb('ok')
end)

