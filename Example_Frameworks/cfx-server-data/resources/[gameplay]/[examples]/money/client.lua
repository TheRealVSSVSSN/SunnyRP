local STAT_HASHES = {
    cash = `MP0_WALLET_BALANCE`,
    bank = `BANK_BALANCE`
}

--[[
    -- Type: Function
    -- Name: updateDisplay
    -- Use: Updates the HUD money stats for the given type.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
local function updateDisplay(moneyType, amount)
    local stat = STAT_HASHES[moneyType]
    if not stat then return end
    StatSetInt(stat, math.floor(amount))
end

RegisterNetEvent('money:displayUpdate', updateDisplay)

-- request initial amounts from server
TriggerServerEvent('money:requestDisplay')

local HUD_DISPLAY_TIME = 4000

--[[
    -- Type: Function
    -- Name: toggleMoneyHud
    -- Use: Shows wallet and bank cash temporarily on key press.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
local function toggleMoneyHud()
    SetMultiplayerBankCash()
    SetMultiplayerWalletCash()

    Wait(HUD_DISPLAY_TIME)

    RemoveMultiplayerBankCash()
    RemoveMultiplayerWalletCash()
end

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 20) then
            toggleMoneyHud()
        end
    end
end)
