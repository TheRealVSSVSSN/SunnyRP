local CanDropOff = true
local DropOffTime = 0
local DROPOFF_COOLDOWN = 300
local DROPOFF_COORDS = vector3(925.329, 46.152, 80.908)

--[[
    -- Type: Event
    -- Name: np-dirtymoney:allowDirtyMoneyDrops
    -- Use: Initiates and manages the cooldown timer for dropping off dirty money.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-dirtymoney:allowDirtyMoneyDrops", function()
    if DropOffTime ~= 0 then
        DropOffTime = DROPOFF_COOLDOWN
        return
    end

    DropOffTime = DROPOFF_COOLDOWN
    CanDropOff = false

    CreateThread(function()
        while DropOffTime > 0 do
            Wait(1000)
            DropOffTime = DropOffTime - 1
        end

        CanDropOff = true
        DropOffTime = 0
        --TriggerEvent("DoLongHudText","Marked Bills is ready to be dropped off!")
    end)
end)

--[[
    -- Type: Event
    -- Name: np-dirtymoney:attemptDirtyMoneyDrops
    -- Use: Checks cooldown before starting a dropoff attempt.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-dirtymoney:attemptDirtyMoneyDrops", function()
    if DropOffTime == 0 then
        TriggerEvent('np-dirtymoney:allowDirtyMoneyDrops')
        --TriggerServerEvent('mobdelivery:checkjob')
        --TriggerServerEvent("np-dirtymoney:alterDirtyMoney", "TurnToCash", 0)
    else
        local msgtoplayer = "You must wait " .. DropOffTime .. " Seconds to drop off your cash.."
        TriggerEvent("DoLongHudText", msgtoplayer)
    end
end)

--[[
    -- Type: Function
    -- Name: IsNearDirtyMoney
    -- Use: Determines if the player is within range of the dropoff location.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
function IsNearDirtyMoney()
    return #(DROPOFF_COORDS - GetEntityCoords(PlayerPedId())) < 15
end

local backpack = false
local attachedProp = 0

--[[
    -- Type: Event
    -- Name: dmbackpack
    -- Use: Adds or removes a backpack prop based on dirty money amount.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("dmbackpack", function(amt)
    if amt > 5000 and not backpack then
        backpack = true
        attachProp("prop_cs_heist_bag_01", 24816, 0.15, -0.4, -0.38, 90.0, 0.0, 0.0)
    elseif backpack and amt < 5000 then
        backpack = false
        removeAttachedProp()
    end
end)

--[[
    -- Type: Function
    -- Name: removeAttachedProp
    -- Use: Deletes the currently attached prop from the player.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
local function removeAttachedProp()
    DeleteEntity(attachedProp)
    attachedProp = 0
end

--[[
    -- Type: Function
    -- Name: attachProp
    -- Use: Attaches a specified prop to the player.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
local function attachProp(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR)
    removeAttachedProp()
    local attachModel = GetHashKey(attachModelSent)
    local boneNumber = boneNumberSent
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end
    attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
    exports["isPed"]:GlobalObject(attachedProp)
    AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

--[[
    -- Type: Event
    -- Name: dirtymoney:dropDirty
    -- Use: Drops marked bills on the ground and removes them from the player.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("dirtymoney:dropDirty", function(DirtyMoney, amount)
    if DirtyMoney >= amount then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerEvent("DoLongHudText", "You Dropped $ " .. amount .. " Marked Bills.")
        TriggerServerEvent("np-dirtymoney:alterDirtyMoney", "ItemDrop", amount)
        TriggerEvent('item:itemDrop', {"DirtyMoney"}, {amount}, {pos.x, pos.y, pos.z - 0.7}, {false}, false)
    else
        TriggerEvent("DoLongHudText", "You do not have enough Marked Bills to drop.")
    end
end)

--[[
    -- Type: Event
    -- Name: dirtymoney:dropCash
    -- Use: Drops clean cash on the ground.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("dirtymoney:dropCash", function(amount)
    local pos = GetEntityCoords(PlayerPedId())
    TriggerEvent("DoLongHudText", "You Dropped $ " .. amount .. ".")
    TriggerEvent('item:itemDrop', {"Money"}, {amount}, {pos.x, pos.y, pos.z - 0.7}, {false}, false)
end)

