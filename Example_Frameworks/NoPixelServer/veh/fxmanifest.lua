fx_version 'cerulean'
game 'gta5'

client_script '@np-errorlog/client/cl_errorlog.lua'

server_script 'server.lua'
client_script 'client.lua'

exports {
    'checkPlayerOwnedVehicle',
    'setPlayerOwnedVehicle',
    'trackVehicleHealth'
}
