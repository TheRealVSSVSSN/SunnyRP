--[[
    -- Type: Manifest
    -- Resource: koillove
    -- Description: Loads custom timecycle files for enhanced weather visuals
    -- Updated: 10 Sep 2025
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

local timecycleFiles = {
    'timecycle_mods_4.xml',
    'w_blizzard.xml',
    'w_clear.xml',
    'w_clearing.xml',
    'w_clouds.xml',
    'w_extrasunny.xml',
    'w_foggy.xml',
    'w_neutral.xml',
    'w_overcast.xml',
    'w_rain.xml',
    'w_smog.xml',
    'w_snow.xml',
    'w_snowlight.xml',
    'w_thunder.xml',
    'w_xmas.xml'
}

for _, file in ipairs(timecycleFiles) do
    data_file('TIMECYCLEMOD_FILE', file)
end

files(timecycleFiles)

