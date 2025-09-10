local TOTAL_CASES = 20
local hasRobbed = {}
for i = 1, TOTAL_CASES do
    hasRobbed[i] = true
end

local weaponTypes = {
    [2685387236] = { name = "Unarmed", slot = 0 },
    [3566412244] = { name = "Melee", slot = 1 },
    [-728555052] = { name = "Melee", slot = 1 },
    [416676503] = { name = "Pistol", slot = 2 },
    [3337201093] = { name = "SMG", slot = 3 },
    [970310034] = { name = "AssaultRifle", slot = 4 },
    [-957766203] = { name = "AssaultRifle", slot = 4 },
    [3539449195] = { name = "DigiScanner", slot = 4 },
    [4257178988] = { name = "FireExtinguisher", slot = 0 },
    [1159398588] = { name = "MG", slot = 4 },
    [3493187224] = { name = "NightVision", slot = 0 },
    [431593103] = { name = "Parachute", slot = 0 },
    [860033945] = { name = "Shotgun", slot = 3 },
    [3082541095] = { name = "Sniper", slot = 3 },
    [690389602] = { name = "Stungun", slot = 1 },
    [2725924767] = { name = "Heavy", slot = 4 },
    [1548507267] = { name = "Thrown", slot = 0 },
    [1595662460] = { name = "PetrolCan", slot = 1 }
}

local locations = {
    [1] = {-626.5326,-238.3758,38.05},
    [2] = {-625.6032, -237.5273, 38.05},
    [3] = {-626.9178, -235.5166, 38.05},
    [4] = {-625.6701, -234.6061, 38.05},
    [5] = {-626.8935, -233.0814, 38.05},
    [6] = {-627.9514, -233.8582, 38.05},
    [7] = {-624.5250, -231.0555, 38.05},
    [8] = {-623.0003, -233.0833, 38.05},
    [9] = {-620.1098, -233.3672, 38.05},
    [10] = {-620.2979, -234.4196, 38.05},
    [11] = {-619.0646, -233.5629, 38.05},
    [12] = {-617.4846, -230.6598, 38.05},
    [13] = {-618.3619, -229.4285, 38.05},
    [14] = {-619.6064, -230.5518, 38.05},
    [15] = {-620.8951, -228.6519, 38.05},
    [16] = {-619.7905, -227.5623, 38.05},
    [17] = {-620.6110, -226.4467, 38.05},
    [18] = {-623.9951, -228.1755, 38.05},
    [19] = {-624.8832, -227.8645, 38.05},
    [20] = {-623.6746, -227.0025, 38.05}
}

local copAmount = 0
local isCop = false
local jewelKOS = true

--[[
    -- Type: Function
    -- Name: getWeaponSlot
    -- Use: Determines equipped weapon slot type for reward logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getWeaponSlot()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    local group = GetWeapontypeGroup(weapon)
    local info = weaponTypes[group]
    if info then
        return info.slot
    end
    return 0
end

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Loads requested animation dictionary
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

--[[
    -- Type: Function
    -- Name: dropSecurityCard
    -- Use: Gives player a random security access card
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function dropSecurityCard()
    local myluck = math.random(5)
    if myluck == 1 then
        TriggerEvent("player:receiveItem","securityblue",1)
    elseif myluck == 2 then
        TriggerEvent("player:receiveItem","securityblack",1)
    elseif myluck == 3 then
        TriggerEvent("player:receiveItem","securitygreen",1)
    elseif myluck == 4 then
        TriggerEvent("player:receiveItem","securitygold",1)
    else
        TriggerEvent("player:receiveItem","securityred",1)
    end
end

--[[
    -- Type: Function
    -- Name: giveItems
    -- Use: Rewards player with jewel loot
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function giveItems()
    if getWeaponSlot() > 2 then
        if math.random(25) == 20 then
            dropSecurityCard()
        end
        TriggerEvent("player:receiveItem", "rolexwatch", math.random(5,20))
        if math.random(5) == 1 then
            TriggerEvent("player:receiveItem", "goldbar", math.random(1,20))
        end
        if math.random(69) == 69 then
            TriggerEvent("player:receiveItem", "valuablegoods", math.random(15))
        end
        TriggerEvent("player:receiveItem", "goldbar", 1)
    end
end

--[[
    -- Type: Function
    -- Name: loadParticle
    -- Use: Loads particle effect for glass smashing
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadParticle()
    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
        RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
        Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

--[[
    -- Type: Function
    -- Name: loadAnimation
    -- Use: Plays jewel smash animation and sound
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadAnimation()
    loadAnimDict("missheist_jewel")
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
    TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
    Wait(2200)
end

--[[
    -- Type: Function
    -- Name: attackGlass
    -- Use: Handles jewel case smashing and item rewards
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function attackGlass(num)
    if math.random(100) > 70 or getWeaponSlot() > 2 then
        Wait(1500)
        ClearPedTasks(PlayerPedId())
        local plyPos = GetEntityCoords(PlayerPedId())
        if math.random(50) > 35 then
            TriggerServerEvent("dispatch:svNotify", {
                dispatchCode = "10-90A",
                origin = { x = plyPos.x, y = plyPos.y, z = plyPos.z }
            })
        end
        TriggerServerEvent("jewel:hasrobbed", num)
        TriggerEvent("customNotification","You broke the glass and got some items!",2)
        giveItems()
        hasRobbed[num] = true
    else
        TriggerEvent("customNotification","You failed to break the glass - more force would help.",2)
        ClearPedTasks(PlayerPedId())
    end
end

--[[
    -- Type: Function
    -- Name: displayText
    -- Use: Draws 2D help text on screen
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function displayText(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: drawText3D
    -- Use: Draws interaction text at world coordinates
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drawText3D(x,y,z)
    local text = "Press [E] to rob!"
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("jewel:cops")
AddEventHandler("jewel:cops", function(cops)
    copAmount = cops
end)

RegisterNetEvent("jewel:robbed")
AddEventHandler("jewel:robbed", function(newSet)
    hasRobbed = newSet
end)

RegisterNetEvent('event:control:jewelRob')
AddEventHandler('event:control:jewelRob', function(useID)
    if not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and not isCop and copAmount < 2 and not hasRobbed[useID] then
        local v = locations[useID]
        TaskTurnPedToFaceCoord(PlayerPedId(), v[1], v[2], v[3], 1.0)
        Wait(2000)
        loadParticle()
        StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v[1], v[2], v[3], 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        loadAnimation()
        attackGlass(useID)
    end
end)

CreateThread(function()
    Wait(900)
    while true do
        local playerPos = GetEntityCoords(PlayerPedId())
        local distance = #(vector3(-596.47, -283.96, 50.33) - playerPos)
        if distance < 3.0 and not hasRobbed[1] and not hasRobbed[5] and not hasRobbed[10] and not hasRobbed[15] and not hasRobbed[20] then
            Wait(1)
            DrawMarker(27,-596.47,-283.96,50.33,0,0,0,0,0,0,0.60,0.60,0.3,11,111,11,60,0,0,2,0,0,0,0)
            displayText(-596.47,-283.96,50.33,"[E] Use Purple G6 Card")
            if IsControlJustReleased(0,38) and distance < 1.0 then
                if exports["np-inventory"]:hasEnoughOfItem("Gruppe6Card3",1,false) then
                    TriggerEvent("inventory:removeItem","Gruppe6Card3",1)
                    TriggerServerEvent("np-doors:alterlockstate",199)
                    TriggerServerEvent("np-doors:alterlockstate",198)
                    TriggerServerEvent("jewel:reset")
                end
            end
        else
            Wait(3000)
        end
    end
end)

CreateThread(function()
    while true do
        if (#(GetEntityCoords(PlayerPedId()) - vector3(-626.5326, -238.3758, 38.05)) < 100.0 and not isCop and copAmount < 2) then
            for i = 1, #locations do
                local v = locations[i]
                if (#(GetEntityCoords(PlayerPedId()) - vector3(v[1], v[2], v[3])) < 0.8 ) then
                    if not hasRobbed[i] then
                        drawText3D(v[1],v[2],v[3])
                    end
                end
            end
            Wait(1)
        else
            Wait(6000)
        end
    end
end)

RegisterNetEvent('JewelKOS')
AddEventHandler('JewelKOS', function()
    if jewelKOS then
        return
    end
    jewelKOS = true
    SetPedRelationshipGroupDefaultHash(PlayerPedId(), GetHashKey("MISSION3"))
    SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("MISSION3"))
    Wait(60000)
    SetPedRelationshipGroupDefaultHash(PlayerPedId(), GetHashKey("PLAYER"))
    SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
    jewelKOS = false
end)

RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

RegisterNetEvent('spawning')
AddEventHandler('spawning', function()
    TriggerServerEvent("jewel:request")
end)

RegisterCommand("resetjewel", function()
    TriggerServerEvent("jewel:reset")
end)

