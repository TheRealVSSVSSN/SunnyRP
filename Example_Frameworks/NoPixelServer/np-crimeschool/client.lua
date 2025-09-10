local nearClothing = false
local isExportReady = false
local insideRooster = false
local rank = 0

--[[ 
    -- Type: Constant
    -- Name: HEAD_BONE
    -- Use: Head bone id used for zone tracking
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
local HEAD_BONE = 0x796e

--[[ 
    -- Type: Constant
    -- Name: INPUT_PICKUP
    -- Use: Key code for opening stashes (E)
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
local INPUT_PICKUP = 38

--[[ 
    -- Type: Constant
    -- Name: INPUT_DETONATE
    -- Use: Key code for swapping characters (G)
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
local INPUT_DETONATE = 47

--[[ 
    -- Type: Function
    -- Name: logout
    -- Use: Clears player states and reinitializes spawn manager
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
local function logout()
    TriggerEvent("np-base:clearStates")
    exports["np-base"]:getModule("SpawnManager"):Initialize()
end

--[[ 
    -- Type: Function
    -- Name: isNearLocation
    -- Use: Returns nearest location data from a list
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
local function isNearLocation(locations)
    local playerPos = GetEntityCoords(PlayerPedId())
    local closestDist, closestLoc, index = math.huge
    for i, loc in ipairs(locations) do
        local dist = #(playerPos - loc)
        if dist < closestDist then
            closestDist, closestLoc, index = dist, loc, i
        end
    end
    return closestDist, closestLoc, index
end

RegisterNetEvent('hotel:outfit')
AddEventHandler('hotel:outfit', function(args, sentType)
    if not nearClothing then return end

    if sentType == 1 then
        local id = args[2]
        table.remove(args, 1)
        table.remove(args, 1)
        local strng = ""
        for i = 1, #args do
            strng = strng .. " " .. args[i]
        end
        TriggerEvent("raid_clothes:outfits", sentType, id, strng)
    elseif sentType == 2 then
        local id = args[2]
        TriggerEvent("raid_clothes:outfits", sentType, id)
    elseif sentType == 3 then
        local id = args[2]
        TriggerEvent('item:deleteClothesDna')
        TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
        TriggerEvent("raid_clothes:outfits", sentType, id)
    else
        TriggerServerEvent("raid_clothes:list_outfits")
    end
end)

local stashes = {
    vector3(-161.91, 326.30, 93.77),
    vector3(-161.91, 335.79, 93.77),
    vector3(-167.52, 335.88, 93.77),
    vector3(-167.52, 326.26, 93.76),
    vector3(-173.08, 335.74, 93.76),
    vector3(-173.08, 326.21, 93.76),
}

local clothes = {
    vector3(-158.44, 326.67, 93.77),
    vector3(-158.44, 335.66, 93.77),
    vector3(-164.05, 335.41, 93.77),
    vector3(-164.05, 326.82, 93.77),
    vector3(-169.61, 335.38, 93.76),
    vector3(-169.61, 326.72, 93.76),
}

CreateThread(function()
    while true do
        Wait(1)
        if insideRooster then
            if rank > 0 then
                local stashDist, stashLoc, stashIndex = isNearLocation(stashes)
                local changeDist, changeLoc, changeIndex = isNearLocation(clothes)

                if stashDist < 1.0 then
                    nearClothing = false
                    DrawText3D(stashLoc.x, stashLoc.y, stashLoc.z, '~g~E~s~ to open stash.')
                    if IsControlJustPressed(0, INPUT_PICKUP) then
                        TriggerEvent("server-inventory-open", "1", "Crimeschool-" .. stashIndex)
                        Wait(1000)
                    end
                elseif changeDist < 1.0 then
                    nearClothing = true
                    DrawText3D(changeLoc.x, changeLoc.y, changeLoc.z, '~g~G~s~ to swap char or /outfits.')
                    if IsControlJustReleased(0, INPUT_DETONATE) then
                        logout()
                    end
                else
                    nearClothing = false
                    local dist = math.min(stashDist, changeDist)
                    if dist > 10 then
                        Wait(math.ceil(dist * 10))
                    end
                end
            else
                Wait(10000)
            end
        end
    end
end)

--[[ 
    -- Type: Function
    -- Name: DrawText3D
    -- Use: Renders 3D text at given coordinates
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(_x, _y)

    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

local roosterLoc = PolyZone:Create({
    vector2(-188.3214263916, 351.30450439453),
    vector2(-149.05914306641, 335.25012207031),
    vector2(-136.84013366699, 308.90753173828),
    vector2(-137.62979125977, 295.08831787109),
    vector2(-152.69242858887, 285.56771850586),
    vector2(-177.97177124023, 280.53424072266)
}, {
    name = "rooster_academy",
    debugGrid = false,
    gridDivisions = 25
})

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HEAD_BONE)
        local inPoly = roosterLoc:isPointInside(coord)
        if inPoly and not insideRooster then
            insideRooster = true
        elseif not inPoly and insideRooster then
            insideRooster = false
        end
        Wait(500)
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        if insideRooster and isExportReady then
            rank = exports["isPed"]:GroupRank("rooster_academy")
            Wait(10000)
        end
    end
end)

--[[ 
    -- Type: Event
    -- Name: np-base:exportsReady
    -- Use: Marks export availability for rank updates
    -- Created: 2024-07-07
    -- By: VSSVSSN
--]]
AddEventHandler("np-base:exportsReady", function()
    Wait(1)
    isExportReady = true
end)
