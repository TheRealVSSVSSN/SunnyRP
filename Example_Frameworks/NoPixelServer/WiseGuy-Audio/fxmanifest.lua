--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Registers custom vehicle audio configuration files for WiseGuy imports
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'WiseGuy custom vehicle audio'

files {
    -- Sultan RS V8
    'audioconfig/sultanrsv8_game.dat151',
    'audioconfig/sultanrsv8_game.dat151.nametable',
    'audioconfig/sultanrsv8_game.dat151.rel',
    'audioconfig/sultanrsv8_sounds.dat54',
    'audioconfig/sultanrsv8_sounds.dat54.nametable',
    'audioconfig/sultanrsv8_sounds.dat54.rel',
    'sfx/dlc_v8sultanrs/v8sultanrs.awc',
    'sfx/dlc_v8sultanrs/v8sultanrs_npc.awc',

    -- Sentinel SG4
    'audioconfig/sentinelsg4_game.dat151',
    'audioconfig/sentinelsg4_game.dat151.nametable',
    'audioconfig/sentinelsg4_game.dat151.rel',
    'audioconfig/sentinelsg4_sounds.dat54',
    'audioconfig/sentinelsg4_sounds.dat54.nametable',
    'audioconfig/sentinelsg4_sounds.dat54.rel',
    'sfx/dlc_sentinelsg4/sentinelsg4.awc',
    'sfx/dlc_sentinelsg4/sentinelsg4_npc.awc',

    -- Elegy X
    'audioconfig/elegyx_game.dat151',
    'audioconfig/elegyx_game.dat151.nametable',
    'audioconfig/elegyx_game.dat151.rel',
    'audioconfig/elegyx_sounds.dat54',
    'audioconfig/elegyx_sounds.dat54.nametable',
    'audioconfig/elegyx_sounds.dat54.rel',
    'sfx/dlc_elegyx/elegyx.awc',
    'sfx/dlc_elegyx/elegyx_npc.awc',

    -- Majima LM
    'audioconfig/majimalm_game.dat151',
    'audioconfig/majimalm_game.dat151.rel',
    'audioconfig/majimalm_sounds.dat54',
    'audioconfig/majimalm_sounds.dat54.rel',
    'sfx/dlc_majimagt/majimagt.awc',
    'sfx/dlc_majimagt/majimagt_npc.awc',

    -- Stratum C
    'audioconfig/stratumc_amp.dat10',
    'audioconfig/stratumc_amp.dat10.nametable',
    'audioconfig/stratumc_amp.dat10.rel',
    'audioconfig/stratumc_game.dat151',
    'audioconfig/stratumc_game.dat151.nametable',
    'audioconfig/stratumc_game.dat151.rel',
    'audioconfig/stratumc_sounds.dat54',
    'audioconfig/stratumc_sounds.dat54.nametable',
    'audioconfig/stratumc_sounds.dat54.rel',
    'sfx/dlc_zircoflow/stratumc.awc',
    'sfx/dlc_zircoflow/stratumc_npc.awc',

    -- Trumpet ZRC/ZR
    'audioconfig/trumpetzrc_game.dat151',
    'audioconfig/trumpetzrc_game.dat151.nametable',
    'audioconfig/trumpetzrc_game.dat151.rel',
    'audioconfig/trumpetzrc_sounds.dat54',
    'audioconfig/trumpetzrc_sounds.dat54.nametable',
    'audioconfig/trumpetzrc_sounds.dat54.rel',
    'audioconfig/trumpetzr_game.dat151',
    'audioconfig/trumpetzr_game.dat151.nametable',
    'audioconfig/trumpetzr_game.dat151.rel',
    'audioconfig/trumpetzr_sounds.dat54',
    'audioconfig/trumpetzr_sounds.dat54.nametable',
    'audioconfig/trumpetzr_sounds.dat54.rel',
    'sfx/dlc_trumpetzr/trumpetzr.awc',
    'sfx/dlc_trumpetzr/trumpetzr_npc.awc',

    -- CW 2019
    'audioconfig/cw2019_game.dat151',
    'audioconfig/cw2019_game.dat151.nametable',
    'audioconfig/cw2019_game.dat151.rel',
    'audioconfig/cw2019_sounds.dat54',
    'audioconfig/cw2019_sounds.dat54.nametable',
    'audioconfig/cw2019_sounds.dat54.rel',
    'sfx/dlc_cw2019/cw2019.awc',
    'sfx/dlc_cw2019/cw2019_npc.awc'
}

data_file 'AUDIO_GAMEDATA' 'audioconfig/sentinelsg4_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sentinelsg4_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_sentinelsg4'

data_file 'AUDIO_GAMEDATA' 'audioconfig/elegyx_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/elegyx_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_elegyx'

data_file 'AUDIO_GAMEDATA' 'audioconfig/majimalm_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/majimalm_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_majimagt'

data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzrc_game.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/trumpetzr_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzrc_sounds.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/trumpetzr_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_trumpetzr'

data_file 'AUDIO_GAMEDATA' 'audioconfig/cw2019_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/cw2019_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_cw2019'

data_file 'AUDIO_GAMEDATA' 'audioconfig/sultanrsv8_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sultanrsv8_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_v8sultanrs'

data_file 'AUDIO_SYNTHDATA' 'audioconfig/stratumc_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/stratumc_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/stratumc_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_zircoflow'

client_scripts {
    'vehicle_names.lua'
}

