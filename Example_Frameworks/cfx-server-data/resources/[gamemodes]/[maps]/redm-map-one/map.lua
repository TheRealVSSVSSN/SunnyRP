--[[
    -- Type: Script
    -- Name: map.lua
    -- Use: Registers spawn points for RedM
    -- Updated: 2025-02-14
    -- By: VSSVSSN
--]]

local spawnPoints = {
    { model = 'player_three', coords = vector4(-262.849, 793.404, 118.087, 180.0) },
    { model = 'player_zero',  coords = vector4(-262.849, 793.404, 118.087, 180.0) }
}

for _, sp in ipairs(spawnPoints) do
    spawnpoint(sp.model, {
        x = sp.coords.x,
        y = sp.coords.y,
        z = sp.coords.z,
        heading = sp.coords.w
    })
end

