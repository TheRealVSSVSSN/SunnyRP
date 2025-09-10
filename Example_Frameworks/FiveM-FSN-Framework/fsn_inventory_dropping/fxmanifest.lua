--[[
    -- Type: Manifest
    -- Name: fxmanifest
    -- Use: Registers inventory drop scripts
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script '@fsn_main/cl_utils.lua'
server_script '@fsn_main/sv_utils.lua'
shared_script '@fsn_main/server_settings/sh_settings.lua'

client_script 'cl_dropping.lua'
server_script 'sv_dropping.lua'
