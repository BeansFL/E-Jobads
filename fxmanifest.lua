fx_version 'cerulean'
game 'gta5'
author 'Evolved Studios'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/assets/img/*.png',
    'html/src/*.js',
    'html/styles/*.css',
    'html/styles/*.scss'
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
} 


client_scripts {
    'client/client.lua'
}

server_scripts {
    'Webhook.lua',
    'server/server.lua' 
}

