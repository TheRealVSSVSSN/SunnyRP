--[[ 
    -- Type: Client
    -- Name: np-rehab client
    -- Use: Manages rehab holding area and player restrictions
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]

local groundCoords = {
    vector3(-1517.29, 852.89, 181.6),
    vector3(-1564.5, 775.2, 189.2),
    vector3(-1572.18, 771.74, 189.2),
    vector3(-1581.47, 788.57, 189.2),
    vector3(-1579.19, 815.84, 186.0)
}

local restrictionCoords = {
    { x = -1512.66, y = 863.0,  z = 181.9,  r = 80.0 },
    { x = -1594.4,  y = 765.59, z = 189.2, r = 36.0 },
    { x = -1576.23, y = 815.9,  z = 185.99, r = 60.0 }
}

local placement = 0
local isInRehab = false

--[[ 
    -- Type: Event
    -- Name: beginJailRehab
    -- Use: Initiates rehab and enforces movement restrictions
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
RegisterNetEvent('beginJailRehab', function(isInRehabSent)
    isInRehab = isInRehabSent
    placement = math.random(#groundCoords)

    TriggerEvent("DensityModifierEnable", false)
    TriggerEvent("DoLongHudText", "You are on a mental hold.", 1)
    Wait(1000)

    local targetPos = groundCoords[placement]
    local ped = PlayerPedId()
    SetEntityCoords(ped, targetPos.x, targetPos.y, targetPos.z, false, false, false, true)
    TriggerEvent("falseCuffs")
    DoScreenFadeIn(1500)

    while isInRehab do
        Wait(1000)
        ped = PlayerPedId()
        RemoveAllPedWeapons(ped, true)
        TriggerEvent("attachWeapons")

        local pos = GetEntityCoords(ped)
        local inside = false
        for _, v in ipairs(restrictionCoords) do
            if #(pos - vector3(v.x, v.y, v.z)) < v.r then
                inside = true
                break
            end
        end

        if not inside then
            TriggerEvent("DoLongHudText", "The orderly have placed you back into the facility for protection.", 1)
            local resetPos = groundCoords[placement]
            SetEntityCoords(ped, resetPos.x, resetPos.y, resetPos.z, false, false, false, true)
        end
    end

    TriggerEvent("DoLongHudText", "You were removed from Mental health care.", 1)
    SetEntityCoords(PlayerPedId(), -1475.86, 884.47, 182.93, false, false, false, true)
    TriggerEvent("DensityModifierEnable", true)
end)

--[[ 
    -- Type: Event
    -- Name: rehab:changeCharacter
    -- Use: Releases the player from the rehab loop
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
RegisterNetEvent('rehab:changeCharacter', function()
    isInRehab = false
end)

