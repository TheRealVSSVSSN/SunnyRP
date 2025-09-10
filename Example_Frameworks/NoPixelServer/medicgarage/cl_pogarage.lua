--[[
    -- Type: Function
    -- Name: DisplayHelpText
    -- Use: Shows help text on screen
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--[[
    -- Type: Function
    -- Name: LocalPed
    -- Use: Returns the local player's ped
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function LocalPed()
    return PlayerPedId()
end

--[[
    -- Type: Function
    -- Name: DrawText3Ds
    -- Use: Renders 3D text in the world
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Draws 2D text on screen
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- NEW VERSION command mapping
local cmd = {
    ["classic"]  = { event = 'medicg:spawn', model = 'ambulance' },
    ["classic2"] = { event = 'medicg:spawn', model = 'emschief' },
    ["classic3"] = { event = 'medicg:spawn', model = 'emscommand' },
    ["classic4"] = { event = 'medicg:spawn', model = 'emscrt' },
    ["helico"]   = { event = 'medicg:spawn', model = 'maverick' },
    ["firetruk"] = { event = 'medicg:spawn', model = 'firetruk' },
}

RegisterNetEvent("emsGarage:Menu")
AddEventHandler("emsGarage:Menu", function(isWhitelisted)
    InitMenuVehicules(isWhitelisted)
end)

--[[
    -- Type: Function
    -- Name: InitMenuVehicules
    -- Use: Builds the vehicle spawn menu
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function InitMenuVehicules(isWhitelisted)
    MenuTitle = "SpawnJobs"
    ClearMenu()
    if isWhitelisted then
        Menu.addButton("Ambulance", "callSE", cmd["classic"])
        Menu.addButton("Chief 4WD", "callSE", cmd["classic2"])
        Menu.addButton("Command", "callSE", cmd["classic3"])
        Menu.addButton("SCRT", "callSE", cmd["classic4"])
        Menu.addButton("Fire Truck", "callSE", cmd["firetruk"])
    else
        Menu.addButton("Ambulance", "callSE", cmd["classic"])
    end
end

--[[
    -- Type: Function
    -- Name: InitMenuHelico
    -- Use: Builds the helicopter spawn menu
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function InitMenuHelico()
    MenuTitle = "SpawnJobs"
    ClearMenu()
    Menu.addButton("Helicopter", "callSE", cmd["helico"])
end

--[[
    -- Type: Function
    -- Name: callSE
    -- Use: Triggers server event to spawn a vehicle
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function callSE(data)
    Menu.hidden = not Menu.hidden
    Menu.renderGUI()
    TriggerServerEvent(data.event, data.model)
end

isInService = false
local lastPlate = nil

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if job == "ems" then isInService = true else isInService = false end
end)

RegisterNetEvent("hasSignedOnEms")
AddEventHandler("hasSignedOnEms", function()
    SetPedRelationshipGroupDefaultHash(PlayerPedId(), GetHashKey('MISSION2'))
    SetPoliceIgnorePlayer(PlayerPedId(), true)
end)

RegisterNetEvent('nowMedic1')
AddEventHandler('nowMedic1', function()
    isInService = true
end)

RegisterNetEvent('nowMedicOff1')
AddEventHandler('nowMedicOff1', function()
    isInService = false
end)

local spawnNumber = 0
local signInLocation = {
    {-475.67788696289,-356.32354736328,34.100078582764},
    {364.68, -590.98, 28.69},
    {218.34973144531,-1637.6884765625,29.425844192505},
    {-1182.3208007813,-1773.2825927734,3.9084651470184},
    {1198.3963623047,-1455.646484375,34.967601776123},
}

RegisterNetEvent('event:control:hospitalGarage')
AddEventHandler('event:control:hospitalGarage', function(useID)
    if useID == 1 then
        TriggerServerEvent('attemptdutym')
    elseif useID == 2 then
        spawnNumber = 2
        TriggerServerEvent("police:emsVehCheck")
        Menu.hidden = not Menu.hidden
    elseif useID == 3 then
        if isInService then
            isInService = false

            TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))

            TriggerServerEvent("jobssystem:jobs", "unemployed")
            TriggerServerEvent('myskin_customization:wearSkin')
            TriggerServerEvent('tattoos:retrieve')
            TriggerServerEvent('Blemishes:retrieve')
            TriggerEvent("police:noLongerCop")
            TriggerEvent("logoffmedic")
            TriggerEvent("loggedoff")
            TriggerEvent('nowCopDeathOff')
            TriggerEvent('nowCopSpawnOff')
            TriggerEvent('nowMedicOff')
            TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")

            SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey('PLAYER'))
            SetPedRelationshipGroupDefaultHash(PlayerPedId(), GetHashKey('PLAYER'))
            SetPoliceIgnorePlayer(PlayerPedId(), false)
            TriggerEvent("DoLongHudText",'Signed off Duty!',1)
        end
    end
end)

-- #MarkedForMarker
local distancec = 999.0
CreateThread(function()
    while true do
        Wait(0)
        distancec = 999.0
        for i,v in ipairs(signInLocation) do
            local dstchk = #(vector3(v[1],v[2],v[3]) - GetEntityCoords(LocalPed()))
            if dstchk < distancec then
                distancec = dstchk
            end
            if dstchk < 12 then
                DrawText3Ds(v[1],v[2],v[3], '[F] for Car [E] to sign on duty [G] to Sign off.' )
            end
        end

        if distancec > 50.0 then
            Wait(math.ceil(distancec))
        end

        Menu.renderGUI()
    end
end)

--[[
    -- Type: Function
    -- Name: spawnVehicle
    -- Use: Spawns the specified vehicle at the current sign-in location
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function spawnVehicle(model)
    local coords = signInLocation[spawnNumber]
    local hash = GetHashKey(model)

    if IsAnyVehicleNearPoint(coords[1], coords[2], coords[3], 3.0) then
        TriggerEvent("DoLongHudText", "The area is crowded", 2)
        return
    end

    if lastPlate ~= nil then
        TriggerEvent("keys:remove", lastPlate)
    end

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end

    local plate = "EMS " .. GetRandomIntInRange(1000, 9000)
    local spawned_car = CreateVehicle(hash, coords[1], coords[2], coords[3], -20.0, true, false)
    SetVehicleNumberPlateText(spawned_car, plate)
    TriggerEvent("keys:addNew", spawned_car, plate)
    TriggerServerEvent('garages:addJobPlate', plate)
    SetPedIntoVehicle(PlayerPedId(), spawned_car, -1)
    SetModelAsNoLongerNeeded(hash)
    lastPlate = plate

    Wait(250)
    TriggerEvent('car:engine')
end

RegisterNetEvent('medicg:spawnVehicle')
AddEventHandler('medicg:spawnVehicle', function(model)
    spawnVehicle(model)
end)

