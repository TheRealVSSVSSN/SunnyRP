-- Altering or recreating for local use only is strongly discouraged.

fx_version 'cerulean'
games { 'gta5', 'rdr3' }

author 'Cfx.re <root@cfx.re>'
description 'Handles old-style server player management commands.'
version '1.0.0'
repository 'https://github.com/citizenfx/cfx-server-data'

client_script 'rconlog_client.lua'
server_script 'rconlog_server.lua'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
