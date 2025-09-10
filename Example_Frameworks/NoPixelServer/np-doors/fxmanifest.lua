fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'whitewingz'
description 'One City Doors'
version '1.0.0'

dependency 'ghmattimysql'

shared_script 'shared/sh_doors.lua'
client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client/cl_doors.lua'
}
server_script 'server/sv_doors.lua'

server_export 'isDoorLocked'