-- luacheck: globals GetHashKey RequestModel HasModelLoaded Wait GetPedBoneIndex CreateObject AttachEntityToEntity
-- luacheck: globals SetEntityCollision DeleteObject CreateThread PlayerPedId IsPedInAnyVehicle IsPedGettingIntoAVehicle
-- luacheck: globals HasPedGotWeapon GetSelectedPedWeapon IsPedShooting IsPedDoingDriveby GetCurrentPedWeapon
-- luacheck: globals GetFollowPedCamViewMode GetGameplayCamRelativePitch SetGameplayCamRelativePitch HasAnimDictLoaded
-- luacheck: globals RequestAnimDict TaskPlayAnim ClearPedTasks DoesEntityExist
-- luacheck: globals IsEntityDead IsPedArmed DisableControlAction

--[[
    -- Type: Config
    -- Name: BACK_WEAPONS
    -- Use: Defines weapons to display on the player model when holstered
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local BACK_WEAPONS = {
    {
        name = 'WEAPON_MICROSMG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_sb_microsmg'
    },
    {
        name = 'WEAPON_SMG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_sb_smg'
    },
    {
        name = 'WEAPON_MG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_mg_mg'
    },
    {
        name = 'WEAPON_COMBATMG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_mg_combatmg'
    },
    {
        name = 'WEAPON_GUSENBERG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_sb_gusenberg'
    },
    {
        name = 'WEAPON_ASSAULTSMG',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_sb_assaultsmg'
    },
    {
        name = 'WEAPON_ASSAULTRIFLE',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 10.0, yRot = 160.0, zRot = 10.0,
        model = 'w_ar_assaultrifle'
    },
    {
        name = 'WEAPON_CARBINERIFLE',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_ar_carbinerifle'
    },
    {
        name = 'WEAPON_ADVANCEDRIFLE',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_ar_advancedrifle'
    },
    {
        name = 'WEAPON_SPECIALCARBINE',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_ar_specialcarbine'
    },
    {
        name = 'WEAPON_BULLPUPRIFLE',
        bone = 24818, x = 0.09, y = -0.15, z = 0.1,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_ar_bullpuprifle'
    },
    {
        name = 'WEAPON_PUMPSHOTGUN',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 135.0, zRot = 0.0,
        model = 'w_sg_pumpshotgun'
    },
    {
        name = 'WEAPON_BULLPUPSHOTGUN',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 135.0, zRot = 0.0,
        model = 'w_sg_bullpupshotgun'
    },
    {
        name = 'WEAPON_ASSAULTSHOTGUN',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_sg_assaultshotgun'
    },
    {
        name = 'WEAPON_MUSKET',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 0.0, zRot = 0.0,
        model = 'w_ar_musket'
    },
    {
        name = 'WEAPON_HEAVYSHOTGUN',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 225.0, zRot = 0.0,
        model = 'w_sg_heavyshotgun'
    },
    {
        name = 'WEAPON_HEAVYSNIPER',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 135.0, zRot = 0.0,
        model = 'w_sr_heavysniper'
    },
    {
        name = 'WEAPON_MARKSMANRIFLE',
        bone = 24818, x = 0.10, y = -0.15, z = 0.0,
        xRot = 0.0, yRot = 135.0, zRot = 0.0,
        model = 'w_sr_marksmanrifle'
    }
}

--[[
    -- Type: Config
    -- Name: RECOIL_VALUES
    -- Use: Recoil intensity per weapon hash
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local RECOIL_VALUES = {
    [GetHashKey('WEAPON_PISTOL')] = 0.3,
    [GetHashKey('WEAPON_PISTOL_MK2')] = 0.3,
    [GetHashKey('WEAPON_COMBATPISTOL')] = 0.2,
    [GetHashKey('WEAPON_APPISTOL')] = 0.1,
    [GetHashKey('WEAPON_PISTOL50')] = 0.6,
    [GetHashKey('WEAPON_MICROSMG')] = 0.2,
    [GetHashKey('WEAPON_SMG')] = 0.1,
    [GetHashKey('WEAPON_SMG_MK2')] = 0.1,
    [GetHashKey('WEAPON_ASSAULTSMG')] = 0.1,
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = 0.2,
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 0.2,
    [GetHashKey('WEAPON_CARBINERIFLE')] = 0.1,
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 0.1,
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = 0.1,
    [GetHashKey('WEAPON_MG')] = 0.1,
    [GetHashKey('WEAPON_COMBATMG')] = 0.1,
    [GetHashKey('WEAPON_COMBATMG_MK2')] = 0.1,
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = 0.4,
    [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 0.35,
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 0.7,
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 0.4,
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 0.2,
    [GetHashKey('WEAPON_STUNGUN')] = 0.1,
    [GetHashKey('WEAPON_SNIPERRIFLE')] = 0.5,
    [GetHashKey('WEAPON_HEAVYSNIPER')] = 0.7,
    [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 0.6,
    [GetHashKey('WEAPON_REMOTESNIPER')] = 1.2,
    [GetHashKey('WEAPON_GRENADELAUNCHER')] = 1.0,
    [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = 1.0,
    [GetHashKey('WEAPON_RPG')] = 0.0,
    [GetHashKey('WEAPON_STINGER')] = 0.0,
    [GetHashKey('WEAPON_MINIGUN')] = 0.01,
    [GetHashKey('WEAPON_SNSPISTOL')] = 0.2,
    [GetHashKey('WEAPON_GUSENBERG')] = 0.1,
    [GetHashKey('WEAPON_SPECIALCARBINE')] = 0.2,
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 0.15,
    [GetHashKey('WEAPON_HEAVYPISTOL')] = 0.5,
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = 0.2,
    [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 0.15,
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = 0.4,
    [GetHashKey('WEAPON_MUSKET')] = 0.7,
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = 0.2,
    [GetHashKey('WEAPON_MARKSMANRIFLE')] = 0.3,
    [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 0.25,
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = 0.0,
    [GetHashKey('WEAPON_FLAREGUN')] = 0.9,
    [GetHashKey('WEAPON_COMBATPDW')] = 0.2,
    [GetHashKey('WEAPON_MARKSMANPISTOL')] = 0.9,
    [GetHashKey('WEAPON_RAILGUN')] = 2.4,
    [GetHashKey('WEAPON_MACHINEPISTOL')] = 0.3,
    [GetHashKey('WEAPON_REVOLVER')] = 0.6,
    [GetHashKey('WEAPON_REVOLVER_MK2')] = 0.6,
    [GetHashKey('WEAPON_DBSHOTGUN')] = 0.7,
    [GetHashKey('WEAPON_COMPACTRIFLE')] = 0.3,
    [GetHashKey('WEAPON_AUTOSHOTGUN')] = 0.2,
    [GetHashKey('WEAPON_COMPACTLAUNCHER')] = 0.5,
    [GetHashKey('WEAPON_MINISMG')] = 0.1
}

--[[
    -- Type: Config
    -- Name: HOLSTER_WEAPONS
    -- Use: Weapons that trigger holster animations
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local HOLSTER_WEAPONS = {
    GetHashKey('WEAPON_PISTOL'),
    GetHashKey('WEAPON_COMBATPISTOL'),
    GetHashKey('WEAPON_STUNGUN')
}

--[[
    -- Type: Variable
    -- Name: holstered
    -- Use: Tracks whether the player's weapon is holstered
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local holstered = true
local attachedWeapons = {}

--[[
    -- Type: Function
    -- Name: isHolsterWeapon
    -- Use: Determines if the specified weapon uses holster animations
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function isHolsterWeapon(weapon)
    for _, hash in ipairs(HOLSTER_WEAPONS) do
        if hash == weapon then
            return true
        end
    end
    return false
end

--[[
    -- Type: Function
    -- Name: loadModel
    -- Use: Loads a model into memory
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function loadModel(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    return hash
end

--[[
    -- Type: Function
    -- Name: attachWeapon
    -- Use: Attaches weapon model to the player
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function attachWeapon(ped, cfg)
    local bone = GetPedBoneIndex(ped, cfg.bone)
    local model = loadModel(cfg.model)
    local obj = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(
        obj,
        ped,
        bone,
        cfg.x, cfg.y, cfg.z,
        cfg.xRot, cfg.yRot, cfg.zRot,
        false, false, false, false, 2, true
    )
    SetEntityCollision(obj, false, false)
    attachedWeapons[cfg.name] = obj
end

--[[
    -- Type: Function
    -- Name: removeWeapon
    -- Use: Removes attached weapon model
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function removeWeapon(name)
    if attachedWeapons[name] then
        DeleteObject(attachedWeapons[name])
        attachedWeapons[name] = nil
    end
end

--[[
    -- Type: Thread
    -- Name: Weapon Back Attachment
    -- Use: Displays weapons on player model when not equipped
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, true) or IsPedGettingIntoAVehicle(ped) then
            for name in pairs(attachedWeapons) do
                removeWeapon(name)
            end
        else
            for _, cfg in ipairs(BACK_WEAPONS) do
                local hash = GetHashKey(cfg.name)
                if HasPedGotWeapon(ped, hash, false) then
                    if GetSelectedPedWeapon(ped) == hash then
                        removeWeapon(cfg.name)
                    elseif not attachedWeapons[cfg.name] and cfg.model ~= '' then
                        attachWeapon(ped, cfg)
                    end
                else
                    removeWeapon(cfg.name)
                end
            end
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: Weapon Recoil
    -- Use: Applies recoil based on weapon
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedShooting(ped) and not IsPedDoingDriveby(ped) then
            local _, wep = GetCurrentPedWeapon(ped)
            local recoil = RECOIL_VALUES[wep]
            if recoil and recoil > 0 then
                local view = GetFollowPedCamViewMode()
                local tv = 0.0
                while tv < recoil do
                    Wait(0)
                    local pitch = GetGameplayCamRelativePitch()
                    if view ~= 4 then
                        SetGameplayCamRelativePitch(pitch + 0.1, 0.2)
                        tv = tv + 0.1
                    else
                        local step = recoil > 0.1 and 0.6 or 0.016
                        local inc = recoil > 0.1 and 0.6 or 0.1
                        SetGameplayCamRelativePitch(pitch + step, recoil > 0.1 and 1.2 or 0.333)
                        tv = tv + inc
                    end
                end
            end
        end
    end
end)

--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Ensures an animation dictionary is loaded
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

--[[
    -- Type: Thread
    -- Name: Holster Animations
    -- Use: Plays holster/unholster animations for pistols
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
            local current = GetSelectedPedWeapon(ped)
            if isHolsterWeapon(current) then
                if holstered then
                    loadAnimDict('rcmjosh4')
                    loadAnimDict('weapons@pistol@')
                    TaskPlayAnim(ped, 'rcmjosh4', 'josh_leadout_cop2', 8.0, 2.0, -1, 48, 0, false, false, false)
                    Wait(600)
                    ClearPedTasks(ped)
                    holstered = false
                end
            else
                if not holstered then
                    loadAnimDict('weapons@pistol@')
                    TaskPlayAnim(ped, 'weapons@pistol@', 'aim_2_holster', 8.0, 2.0, -1, 48, 0, false, false, false)
                    Wait(500)
                    ClearPedTasks(ped)
                    holstered = true
                end
            end
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: Disable Melee While Armed
    -- Use: Prevents melee actions when armed
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
        end
    end
end)
