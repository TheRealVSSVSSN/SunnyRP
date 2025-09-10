--[[
    -- Type: Thread
    -- Name: HideFramesLoop
    -- Use: Continuously hides HUD elements and adjusts player settings
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]

local hiddenComponents = {
    1, -- Weapon icon
    6, -- Vehicle name
    7, -- Area name
    9  -- Street name
}

CreateThread(function()
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    SetPedMinGroundTimeForStungun(PlayerPedId(), 6000)

    while true do
        Wait(0)

        local ped = PlayerPedId()

        if not IsAimCamActive() and not IsFirstPersonAimCamActive() then
            HideHudComponentThisFrame(14)
        end

        for _, component in ipairs(hiddenComponents) do
            HideHudComponentThisFrame(component)
        end

        if not IsPedInAnyVehicle(ped, true) then
            HideHudComponentThisFrame(0)
        end

        DisplayHud(IsControlPressed(0, 44))
    end
end)

