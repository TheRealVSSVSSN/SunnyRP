--[[
    -- Type: Resource
    -- Name: fsn_teleporters
    -- Use: Handles predefined teleport spots and generic teleport events
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]

local spots = {
    ["Bahama Mamas"] = {
        enter = vector3(-1388.638, -586.485, 30.219),
        exit  = vector3(-1387.596, -588.039, 30.320),
        locked = false
    },
    ["The Morgue"] = {
        enter = vector3(240.860, -1379.319, 33.742),
        exit  = vector3(274.084, -1360.337, 24.538),
        locked = false
    },
    ["Hospital Offices"] = {
        enter = vector3(340.399, -592.730, 43.282),
        exit  = vector3(254.402, -1372.535, 29.648),
        locked = false
    },
    ["ICU"] = {
        enter = vector3(333.992, -569.834, 43.317),
        exit  = vector3(276.593, -1334.724, 24.538),
        locked = false
    },
    ["The Thinking Box"] = {
        enter = vector3(-1062.859, -240.672, 44.021),
        exit  = vector3(-1063.595, -239.770, 44.021),
        locked = false
    },
    ["Meeting Room"] = {
        enter = vector3(-1048.204, -238.303, 44.021),
        exit  = vector3(-1047.192, -237.757, 44.021),
        locked = false
    },
    ["Courthouse"] = {
        enter = vector3(269.195, -432.842, 45.325),
        exit  = vector3(224.795, -419.655, -118.200),
        locked = false
    },
    ["Courtroom"] = {
        enter = vector3(235.942, -413.406, -118.163),
        exit  = vector3(238.666, -334.355, -118.773),
        locked = true
    },
    ["Court Bench"] = {
        enter = vector3(-1006.814, -481.070, 50.027),
        exit  = vector3(241.270, -304.190, -118.800),
        locked = false
    },
    ["Judges Office"] = {
        enter = vector3(242.901, -416.606, -118.200),
        exit  = vector3(-1002.921, -477.943, 50.027),
        locked = false
    },
    ["Pillbox Roof"] = {
        enter = vector3(246.681, -1372.209, 24.537),
        exit  = vector3(338.826, -583.955, 74.165),
        locked = false
    },
    ["Comedy Club"] = {
        enter = vector3(-430.142, 261.665, 83.005),
        exit  = vector3(-458.790, 284.750, 78.521),
        locked = false
    }
}

local restrictedWeapons = {}
for _, weapon in ipairs({
    "WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT",
    "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_PISTOL", "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_MICROSMG", "WEAPON_SMG",
    "WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE", "WEAPON_MG", "WEAPON_COMBATMG",
    "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN", "WEAPON_STUNGUN", "WEAPON_SNIPERRIFLE",
    "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNSPISTOL",
    "WEAPON_SPECIALCARBINE", "WEAPON_HEAVYPISTOL", "WEAPON_BULLPUPRIFLE",
    "WEAPON_HOMINGLAUNCHER", "WEAPON_PROXMINE", "WEAPON_SNOWBALL",
    "WEAPON_VINTAGEPISTOL", "WEAPON_DAGGER", "WEAPON_FIREWORK",
    "WEAPON_MUSKET", "WEAPON_MARKSMANRIFLE", "WEAPON_HEAVYSHOTGUN",
    "WEAPON_GUSENBERG", "WEAPON_HATCHET", "WEAPON_COMBATPDW",
    "WEAPON_KNUCKLE", "WEAPON_MARKSMANPISTOL", "WEAPON_BOTTLE",
    "WEAPON_FLAREGUN", "WEAPON_FLARE", "WEAPON_REVOLVER",
    "WEAPON_SWITCHBLADE", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT",
    "WEAPON_MACHINEPISTOL", "WEAPON_DBSHOTGUN", "WEAPON_COMPACTRIFLE",
    "GADGET_PARACHUTE"
}) do
    restrictedWeapons[GetHashKey(weapon)] = true
end

--[[
    -- Type: Function
    -- Name: fsn_drawText3D
    -- Use: Renders 3D text at a given world coordinate
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function fsn_drawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 140)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

--[[
    -- Type: Function
    -- Name: teleportPlayer
    -- Use: Handles screen fade and moves the player to the target coordinates
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function teleportPlayer(coords)
    DoScreenFadeOut(1000)
    Wait(1500)
    SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false)
    Wait(1500)
    DoScreenFadeIn(2000)
end

--[[
    -- Type: Thread
    -- Name: Teleport Spots Loop
    -- Use: Monitors player proximity to teleport spots and handles interactions
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for name, spot in pairs(spots) do
            local distEnter = #(coords - spot.enter)
            if distEnter < 10.0 then
                wait = 0
                DrawMarker(25, spot.enter.x, spot.enter.y, spot.enter.z - 0.95, 0,0,0,0,0,0,1.0,1.0,10.3,255,255,255,140,0,0,2,0,0,0,0)
                if distEnter < 1.5 then
                    if spot.locked then
                        fsn_drawText3D(spot.enter, ("~r~%s is locked!"):format(name))
                    elseif IsControlJustPressed(0, 51) then
                        local canEnter = true
                        if not exports["fsn_police"]:fsn_PDDuty() and name == "Courtroom" then
                            for hash in pairs(restrictedWeapons) do
                                if HasPedGotWeapon(ped, hash, false) then
                                    TriggerEvent("fsn_notify:displayNotification", "No weapons in the courtroom.", "centerLeft", 4000, "error")
                                    canEnter = false
                                    break
                                end
                            end
                        end
                        if canEnter then
                            teleportPlayer(spot.exit)
                        end
                    end
                end
            end

            local distExit = #(coords - spot.exit)
            if distExit < 10.0 then
                wait = 0
                DrawMarker(25, spot.exit.x, spot.exit.y, spot.exit.z - 0.95, 0,0,0,0,0,0,1.0,1.0,10.3,255,255,255,140,0,0,2,0,0,0,0)
                if distExit < 1.5 then
                    fsn_drawText3D(spot.exit, ("Press [E] to exit %s"):format(name))
                    if IsControlJustPressed(0, 51) then
                        teleportPlayer(spot.enter)
                    end
                end
            end
        end

        Wait(wait)
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_doj:judge:toggleLock
    -- Use: Updates the locked state of the courtroom teleport
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent("fsn_doj:judge:toggleLock", function(state)
    if spots["Courtroom"] then
        spots["Courtroom"].locked = state
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_teleporters:teleport:waypoint
    -- Use: Teleports the player to their map waypoint
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent("fsn_teleporters:teleport:waypoint", function()
    local ped = PlayerPedId()
    local waypoint = GetFirstBlipInfoId(8)

    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)

        for height = 1, 1000 do
            local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, height + 0.0)
            if found then
                SetPedCoordsKeepVehicle(ped, coords.x, coords.y, groundZ + 1.0)
                break
            end
            Wait(5)
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_teleporters:teleport:coordinates
    -- Use: Teleports the player to specified coordinates
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent("fsn_teleporters:teleport:coordinates", function(x, y, z)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, x + 0.0, y + 0.0, z + 0.0)
    Wait(5)
end)

