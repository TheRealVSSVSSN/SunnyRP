fx_version 'cerulean'
game 'gta5'

lua54 'yes'

dependencies {
    'np-base',
    'ghmattimysql'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client/cl_storage.lua'
}

exports {
    'tryGet',
    'remove',
    'set'
}
