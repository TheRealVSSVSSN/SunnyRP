fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'GABZ'
description 'MRPD'
version '1.0.0'

this_is_a_map 'yes'

files {
    'gabz_mrpd_timecycle.xml',
    'interiorproxies.meta'
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

client_scripts {
    'gabz_mrpd_entitysets.lua'
}