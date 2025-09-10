-- export for getting description of current clothing!

--[[
    -- Type: Function
    -- Name: getSex
    -- Use: Determines the player's character sex based on model
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function getSex()
    local ped = PlayerPedId()
    local sex = false
    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        sex = 'm'
    elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
        sex = 'f'
    end
    return sex
end

--[[
    -- Type: Function
    -- Name: getJacket
    -- Use: Retrieves localized jacket description
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function getJacket()
    local sex = getSex()
    local jacket
    local comp = {
        GetPedDrawableVariation(PlayerPedId(), 11),
        GetPedTextureVariation(PlayerPedId(), 11)
    }

    if sex then
        if sex == 'm' then
            jacket = tostring(MALE.tops[tostring(comp[1])][tostring(comp[2])].Localized)
        elseif sex == 'f' then
            jacket = tostring(FEMALE.tops[tostring(comp[1])][tostring(comp[2])].Localized)
        end
    end

    return jacket or "I can't remember"
end

--[[
    -- Type: Function
    -- Name: getTop
    -- Use: Retrieves localized undershirt description
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function getTop()
    local sex = getSex()
    local top
    local comp = {
        GetPedDrawableVariation(PlayerPedId(), 3),
        GetPedTextureVariation(PlayerPedId(), 3)
    }

    if sex then
        if sex == 'm' then
            top = tostring(MALE.undershirts[tostring(comp[1])][tostring(comp[2])].Localized)
        elseif sex == 'f' then
            top = tostring(FEMALE.undershirts[tostring(comp[1])][tostring(comp[2])].Localized)
        end
    end

    return top or "I can't remember"
end

--[[
    -- Type: Function
    -- Name: getPants
    -- Use: Retrieves localized pants description
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function getPants()
    local sex = getSex()
    local pants
    local comp = {
        GetPedDrawableVariation(PlayerPedId(), 4),
        GetPedTextureVariation(PlayerPedId(), 4)
    }

    if sex then
        if sex == 'm' then
            pants = tostring(MALE.pants[tostring(comp[1])][tostring(comp[2])].Localized)
        elseif sex == 'f' then
            pants = tostring(FEMALE.pants[tostring(comp[1])][tostring(comp[2])].Localized)
        end
    end

    return pants or "I can't remember"
end

CreateThread(function()
    while not MALE.tops do
        Wait(1)
    end
end)

RegisterCommand('evi_clothing', function()
    print("Sex: "..getSex())
    print("Jacket: "..getJacket())
    print("Top: "..getTop())
    print("Pants: "..getPants())
end)

