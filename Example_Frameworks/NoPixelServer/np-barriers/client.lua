--[[
    -- Type: Resource
    -- Name: np-barriers
    -- Use: Handles placement and removal of cones and barriers
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]

--[[
    -- Type: Table
    -- Name: objList
    -- Use: Models that can be picked up by the pickup event
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local objList = {
    "prop_mp_cone_01",
    "prop_mp_barrier_02b",
    "prop_barrier_work05",
    "prop_flare_01",
    "prop_flare_01b"
}

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Requests and waits for an animation dictionary
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

--[[
    -- Type: Function
    -- Name: loadModel
    -- Use: Requests and waits for a model to load
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function loadModel(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
    return model
end

--[[
    -- Type: Function
    -- Name: playPlacementAnim
    -- Use: Plays placement animation and shows taskbar
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function playPlacementAnim(label)
    loadAnimDict("anim@narcotics@trash")
    TaskPlayAnim(PlayerPedId(), "anim@narcotics@trash", "drop_front", 0.9, -8.0, 1700, 49, 0.0, false, false, false)
    local finished = exports["np-taskbar"]:taskBar(1800, label)
    return finished == 100
end

--[[
    -- Type: Function
    -- Name: placeProp
    -- Use: Spawns a prop at provided coordinates and heading
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function placeProp(modelName, x, y, z, heading)
    local model = loadModel(modelName)
    local obj = CreateObject(model, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, heading or 0.0)
    SetModelAsNoLongerNeeded(model)
    return obj
end

--[[
    -- Type: Event
    -- Name: barriers:pickup
    -- Use: Removes nearby barrier objects
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
RegisterNetEvent("barriers:pickup")
AddEventHandler("barriers:pickup", function()
    if not playPlacementAnim("Picking up barrier") then return end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.25, 0.0))
    local heading = GetEntityHeading(ped)
    for _, model in ipairs(objList) do
        local obj = GetClosestObjectOfType(x, y, z, 5.0, GetHashKey(model), false, false, false)
        if obj and obj ~= 0 then
            SetEntityAsMissionEntity(obj, true, true)
            DeleteObject(obj)
        end
    end
    TriggerServerEvent("aidsarea", false, x, y, z, heading)
end)

--[[
    -- Type: Event
    -- Name: barriers:cone
    -- Use: Places a traffic cone in front of the player
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
RegisterNetEvent("barriers:cone")
AddEventHandler("barriers:cone", function()
    if not playPlacementAnim("Placing Cone") then return end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.2, 0.0))
    local heading = GetEntityHeading(ped)
    local cone = placeProp("prop_mp_cone_01", x, y, z, heading)
    exports["isPed"]:GlobalObject(cone)
end)

--[[
    -- Type: Event
    -- Name: barriers:sbarrier
    -- Use: Places a single barrier in front of the player
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
RegisterNetEvent("barriers:sbarrier")
AddEventHandler("barriers:sbarrier", function()
    if not playPlacementAnim("Placing Barrier") then return end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.2, 0.0))
    local heading = GetEntityHeading(ped)
    local barrier = placeProp("prop_barrier_work05", x, y, z, heading)
    exports["isPed"]:GlobalObject(barrier)
end)

--[[
    -- Type: Event
    -- Name: barriers:barrier
    -- Use: Places a barrier with cones on each side and notifies players
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
RegisterNetEvent("barriers:barrier")
AddEventHandler("barriers:barrier", function()
    if not playPlacementAnim("Placing Roadblock") then return end
    local ped = PlayerPedId()
    local bx, by, bz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.2, 0.0))
    local c1x, c1y, c1z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 1.5, 2.2, 0.0))
    local c2x, c2y, c2z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.5, 2.2, 0.0))
    local heading = GetEntityHeading(ped)
    local barrier = placeProp("prop_barrier_work05", bx, by, bz, heading)
    local cone1 = placeProp("prop_mp_cone_01", c1x, c1y, c1z, heading)
    local cone2 = placeProp("prop_mp_cone_01", c2x, c2y, c2z, heading)
    exports["isPed"]:GlobalObject(barrier)
    exports["isPed"]:GlobalObject(cone1)
    exports["isPed"]:GlobalObject(cone2)
    TriggerEvent("DoLongHudText", "Traffic Blocked in facing direction.", 1)
    TriggerServerEvent("aidsarea", true, bx, by, bz, heading)
end)

