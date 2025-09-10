fx_version 'cerulean'

game 'gta5'

lua54 'yes'

description 'NoPixel logging module'

dependency 'np-base'

client_script '@np-errorlog/client/cl_errorlog.lua'

server_script 'server/sv_log.lua'

server_exports {
    'AddLog'
}
