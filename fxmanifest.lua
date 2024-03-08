fx_version 'cerulean'
game 'gta5'
author 'DON'
version '1.0.0'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/en.lua',
    'locales/*.lua'
}
client_scripts {
    'client/main.lua',
    'client/meth.lua',
    'client/coke.lua',
    'client/weed.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/meth.lua',
    'server/coke.lua',
    'server/weed.lua'
}
ui_page 'ui/index.html'
files {
    'ui/app.js',
    'ui/index.html',
    'ui/style.css'
}