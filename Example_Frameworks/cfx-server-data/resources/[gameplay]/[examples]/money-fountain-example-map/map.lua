--[[
    -- Type: Money Fountain Map
    -- Name: test_fountain
    -- Use: Defines spawn location and payout for sample money fountain
    -- Created: 2024-05-02
    -- By: VSSVSSN
--]]

-- coordinates for the example money fountain
local fountainCoords = vec3(97.334, -973.621, 29.36)

money_fountain 'test_fountain' {
    fountainCoords,
    amount = 75
}
