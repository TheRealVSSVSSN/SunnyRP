--[[
    -- Type: Script
    -- Name: client.lua
    -- Use: Spawns a memorial vehicle and ped when players are nearby
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local VEHICLE_MODEL = `rmodmustang`
local VEHICLE_COORDS = vector4(1056.84, -387.26, 67.86, 218.59)
local PED_MODEL = 1885233650 -- mp_m_freemode_01
local PED_COORDS = vector4(1059.67, -386.55, 66.85, 131.56)
local SPAWN_RADIUS = 200.0
local SCENARIO = "WORLD_HUMAN_SMOKING_POT"

local VEHICLE_CUSTOMIZATION_JSON = [[{"colors":[12,70],"xenonColor":255,"neon":{"1":false,"2":false,"3":false,"0":false},"oldLiveries":-1,"mods":{"1":0,"2":-1,"3":-1,"4":1,"5":0,"6":-1,"7":4,"8":-1,"9":-1,"10":7,"11":2,"12":2,"13":2,"14":-1,"15":2,"16":2,"17":false,"18":1,"19":false,"20":false,"21":false,"22":1,"23":-1,"24":-1,"25":-1,"26":-1,"27":-1,"28":-1,"29":-1,"30":-1,"31":-1,"32":-1,"33":-1,"34":-1,"35":-1,"36":-1,"37":-1,"38":-1,"39":-1,"40":-1,"41":-1,"42":-1,"43":-1,"44":-1,"45":-1,"46":-1,"47":-1,"48":-1,"0":-1},"interColour":0,"lights":[255,0,255],"extras":[1,0,0,0,0,0,0,0,0,0,0,0],"platestyle":3,"extracolors":[107,70],"plateIndex":3,"smokecolor":[255,255,255],"tint":0,"wheeltype":7,"dashColour":0}]]
local vehicleCustomization = json.decode(VEHICLE_CUSTOMIZATION_JSON)

local pedCustomization = {
    drawables = json.decode('{"1":["masks",-1],"2":["hair",2],"3":["torsos",6],"4":["legs",9],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",184],"0":["face",11]}'),
    props = json.decode('{"1":["glasses",0],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",139]}'),
    drawtextures = json.decode('[["face",0],["masks",255],["hair",2],["torsos",0],["legs",7],["bags",0],["shoes",2],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]'),
    proptextures = json.decode('[["hats",0],["glasses",0],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]'),
    hairColor = json.decode('[3,17]'),
    headBlend = json.decode('{"skinFirst":15,"skinMix":1.0,"skinThird":0,"hasParent":false,"thirdMix":0.0,"shapeMix":0.0,"skinSecond":0,"shapeFirst":0,"shapeSecond":0,"shapeThird":0}'),
    headOverlay = json.decode('[{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Blemishes"},{"firstColour":18,"overlayValue":10,"colourType":1,"secondColour":18,"overlayOpacity":0.75,"name":"FacialHair"},{"firstColour":6,"overlayValue":1,"colourType":1,"secondColour":6,"overlayOpacity":1.0,"name":"Eyebrows"},{"firstColour":5,"overlayValue":255,"colourType":0,"secondColour":5,"overlayOpacity":1.0,"name":"Ageing"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Makeup"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Blush"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Complexion"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"SunDamage"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Lipstick"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"MolesFreckles"},{"firstColour":0,"overlayValue":255,"colourType":1,"secondColour":0,"overlayOpacity":1.0,"name":"ChestHair"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"BodyBlemishes"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"AddBodyBlemishes"}]'),
    headStructure = json.decode('[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]')
}

local vehicle
local ped

--[[
    -- Type: Function
    -- Name: spawnMemorialVehicle
    -- Use: Spawns and configures the memorial vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function spawnMemorialVehicle()
    RequestModel(VEHICLE_MODEL)
    while not HasModelLoaded(VEHICLE_MODEL) do
        Wait(0)
    end

    vehicle = CreateVehicle(VEHICLE_MODEL, VEHICLE_COORDS.x, VEHICLE_COORDS.y, VEHICLE_COORDS.z, VEHICLE_COORDS.w, false, false)
    SetModelAsNoLongerNeeded(VEHICLE_MODEL)

    SetVehicleOnGroundProperly(vehicle)
    SetEntityInvincible(vehicle, true)
    SetVehicleModKit(vehicle, 0)
    SetVehicleNumberPlateText(vehicle, "BLUE622")
    SetVehicleWheelType(vehicle, vehicleCustomization.wheeltype)
    SetVehicleNumberPlateTextIndex(vehicle, 3)

    for i = 0, 16 do
        SetVehicleMod(vehicle, i, vehicleCustomization.mods[tostring(i)] or -1)
    end

    for i = 17, 22 do
        ToggleVehicleMod(vehicle, i, vehicleCustomization.mods[tostring(i)] or false)
    end

    for i = 23, 24 do
        local custom = vehicleCustomization.mods[tostring(i)]
        local isSet = custom and custom ~= "-1" and custom ~= 0 and custom ~= false
        SetVehicleMod(vehicle, i, custom or -1, isSet)
    end

    for i = 25, 48 do
        SetVehicleMod(vehicle, i, vehicleCustomization.mods[tostring(i)] or -1)
    end

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(vehicle, i, vehicleCustomization.neon[tostring(i)] or false)
    end

    if vehicleCustomization.extras then
        for i = 1, 12 do
            local enabled = tonumber(vehicleCustomization.extras[i]) == 1
            SetVehicleExtra(vehicle, i, enabled and 0 or 1)
        end
    end

    if vehicleCustomization.oldLiveries and vehicleCustomization.oldLiveries ~= 24 then
        SetVehicleLivery(vehicle, vehicleCustomization.oldLiveries)
    end

    if vehicleCustomization.plateIndex and vehicleCustomization.plateIndex ~= 4 then
        SetVehicleNumberPlateTextIndex(vehicle, vehicleCustomization.plateIndex)
    end

    SetVehicleXenonLightsColour(vehicle, vehicleCustomization.xenonColor or -1)
    SetVehicleColours(vehicle, vehicleCustomization.colors[1], vehicleCustomization.colors[2])
    SetVehicleExtraColours(vehicle, vehicleCustomization.extracolors[1], vehicleCustomization.extracolors[2])
    SetVehicleNeonLightsColour(vehicle, vehicleCustomization.lights[1], vehicleCustomization.lights[2], vehicleCustomization.lights[3])
    SetVehicleTyreSmokeColor(vehicle, vehicleCustomization.smokecolor[1], vehicleCustomization.smokecolor[2], vehicleCustomization.smokecolor[3])
    SetVehicleWindowTint(vehicle, vehicleCustomization.tint)
    SetVehicleInteriorColour(vehicle, vehicleCustomization.dashColour)
    SetVehicleDashboardColour(vehicle, vehicleCustomization.interColour)

    FreezeEntityPosition(vehicle, true)
    SetVehicleFuelLevel(vehicle, 0.0)
    SetVehicleDoorsLocked(vehicle, 3)
    SetVehicleLights(vehicle,2)
end

--[[
    -- Type: Function
    -- Name: applyHeadBlend
    -- Use: Sets ped head blend data
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function applyHeadBlend(data)
    SetPedHeadBlendData(ped,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
        false)
end

--[[
    -- Type: Function
    -- Name: applyHeadOverlays
    -- Use: Applies ped head overlays
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function applyHeadOverlays(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #data do
            SetPedHeadOverlay(ped, i-1, tonumber(data[i].overlayValue), tonumber(data[i].overlayOpacity))
        end

        SetPedHeadOverlayColor(ped, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(ped, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(ped, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(ped, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(ped, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(ped, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(ped, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(ped, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(ped, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(ped, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(ped, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(ped, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

--[[
    -- Type: Function
    -- Name: applyHeadStructure
    -- Use: Applies facial structure values
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function applyHeadStructure(data)
    for i = 1, #data do
        SetPedFaceFeature(ped, i-1, data[i])
    end
end

--[[
    -- Type: Function
    -- Name: applyClothing
    -- Use: Applies clothing and props to the ped
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function applyClothing(drawables, props, drawTextures, propTextures)
    local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
    local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}

    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        if propZ and propZ > -1 then
            SetPedPropIndex(ped, i-1, propZ, propTextures[i][2], true)
        else
            ClearPedProp(ped, i-1)
        end
    end
end

--[[
    -- Type: Function
    -- Name: loadPedAppearance
    -- Use: Applies all appearance data to ped
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadPedAppearance(data)
    applyClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    Wait(500)
    applyHeadBlend(data.headBlend)
    applyHeadStructure(data.headStructure)
    applyHeadOverlays(data.headOverlay)
    SetPedHairColor(ped, data.hairColor[1], data.hairColor[2])
    TaskStartScenarioInPlace(ped, SCENARIO, 0, true)
    SetEntityInvincible(ped,true)
    FreezeEntityPosition(ped,true)
    SetPedKeepTask(ped, true)
    SetPedDropsWeaponsWhenDead(ped,false)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedSeeingRange(ped, 0.0)
    SetPedHearingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetIgnoreLowPriorityShockingEvents(ped,true)
    SetBlockingOfNonTemporaryEvents(ped,true)
end

--[[
    -- Type: Function
    -- Name: spawnMemorialPed
    -- Use: Spawns the memorial ped
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function spawnMemorialPed(data)
    RequestModel(PED_MODEL)
    while not HasModelLoaded(PED_MODEL) do
        Wait(100)
    end

    ped = CreatePed(27, PED_MODEL, PED_COORDS.x, PED_COORDS.y, PED_COORDS.z, PED_COORDS.w, false, false)
    DecorSetBool(ped, 'ScriptedPed', true)
    ClearPedTasksImmediately(ped)
    loadPedAppearance(data)
    AddPedDecorationFromHashes(ped, `mpbeach_overlays`, `MP_Bea_M_Neck_000`)
end

local memorialCoords = vector3(1066.84, -387.26, 66.86)
local spawned = false

--[[
    -- Type: Thread
    -- Name: memorialThread
    -- Use: Handles spawning and cleanup based on player distance
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if not spawned and #(memorialCoords - playerCoords) <= SPAWN_RADIUS then
            spawnMemorialVehicle()
            spawnMemorialPed(pedCustomization)
            spawned = true
        elseif spawned and #(memorialCoords - playerCoords) > SPAWN_RADIUS then
            DeleteEntity(vehicle)
            DeleteEntity(ped)
            spawned = false
        end

        if spawned and not IsPedActiveInScenario(ped) then
            TaskStartScenarioInPlace(ped, SCENARIO, 0, true)
        end

        Wait(3000)
    end
end)

--[[
    -- Type: Event
    -- Name: onResourceStop
    -- Use: Cleans up entities when resource stops
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if vehicle then DeleteEntity(vehicle) end
        if ped then DeleteEntity(ped) end
        spawned = false
    end
end)
