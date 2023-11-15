fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'rx'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    'config.lua',
  }

  client_scripts {
    'client/*.lua'
  }

server_scripts {
	'server/*.lua'
}