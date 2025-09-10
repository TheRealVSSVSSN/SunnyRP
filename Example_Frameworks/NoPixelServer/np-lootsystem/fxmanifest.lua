fx_version 'cerulean'
game 'gta5'

description 'Loot System'

lua54 'yes'

server_scripts {
    'server/*.lua'
}

if GetConvar('sv_environment', 'prod') == 'debug' then
    server_script 'tests/sv_*.lua'
    client_script 'tests/cl_*.lua'
end
