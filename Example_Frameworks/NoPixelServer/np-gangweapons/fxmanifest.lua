fx_version 'cerulean'
game 'gta5'

shared_script 'config.lua'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'weashop.lua'
}

server_script 'sv_weashop.lua'

lua54 'yes'

exports {
    'ShowWeashopBlips'
}
