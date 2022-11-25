fx_version 'cerulean'
game 'gta5'

server_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

shared_script {
    '@qb-core/shared/locale.lua',
    'config.lua',
    'locales/en.lua',
    'locales/*.lua'
}

lua54 'yes'

escrow_ignore {
	'config.lua',
    'server/*.lua',
	'locales/*.lua',
}