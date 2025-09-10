local hasHuntingRifle = false
local isFreeAiming = false

--[[
    -- Type: Function
    -- Name: processScope
    -- Use: Toggles the custom sniper scope UI when aiming
    -- Created: 2024-06-10
    -- By: VSSVSSN
--]]
local function processScope(freeAiming)
    if not isFreeAiming and freeAiming then
        isFreeAiming = true
        exports["np-ui"]:sendAppEvent("sniper-scope", { show = true })
    elseif isFreeAiming and not freeAiming then
        isFreeAiming = false
        exports["np-ui"]:sendAppEvent("sniper-scope", { show = false })
    end
end

local blockShotActive = false
--[[
    -- Type: Function
    -- Name: blockShooting
    -- Use: Prevents firing the hunting rifle at invalid targets
    -- Created: 2024-06-10
    -- By: VSSVSSN
--]]
local function blockShooting()
    if blockShotActive then return end
    blockShotActive = true
    CreateThread(function()
        while hasHuntingRifle do
            local ply = PlayerId()
            local ped = PlayerPedId()
            local _, ent = GetEntityPlayerIsFreeAimingAt(ply)
            local freeAiming = IsPlayerFreeAiming(ply)
            processScope(freeAiming)
            local et = GetEntityType(ent)
            if not freeAiming
                or IsPedAPlayer(ent)
                or et == 2
                or (et == 1 and IsPedInAnyVehicle(ent))
            then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(ped, true)
            end
            Wait(0)
        end
        blockShotActive = false
        processScope(false)
    end)
end

--[[
    -- Type: Thread
    -- Name: monitorHuntingRifle
    -- Use: Activates blocking when the hunting rifle is equipped
    -- Created: 2024-06-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    local huntingRifleHash = `weapon_sniperrifle2` -- -646649097

    while true do
        if GetSelectedPedWeapon(PlayerPedId()) == huntingRifleHash then
            hasHuntingRifle = true
            blockShooting()
        else
            hasHuntingRifle = false
        end
        Wait(1000)
    end
end)
