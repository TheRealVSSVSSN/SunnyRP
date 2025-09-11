--[[/   :FSN:   \]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script '@fsn_main/cl_utils.lua'
server_script '@fsn_main/sv_utils.lua'
shared_script '@fsn_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/   :FSN:   \]]--

client_script 'client.lua'
server_script 'server.lua'
