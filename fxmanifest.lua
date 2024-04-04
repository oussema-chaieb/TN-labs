fx_version 'cerulean'
game 'gta5'
author 'DON'
version '1.0.0'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
ui_page 'ui/index.html'
files {
    'ui/app.js',
    'ui/index.html',
    'ui/style.css',
    'stream/mw_props.ytyp'
}
data_file 'DLC_ITYP_REQUEST' 'stream/mw_props.ytyp'
lua54 'yes'