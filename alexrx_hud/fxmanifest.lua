fx_version 'cerulean'
games { 'gta5' }
author 'Medinaa#7364'

ui_page 'html/ui.html'

files {
    'html/*.html',
    'html/js/*.js',
    'html/css/*.css'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

shared_scripts {
    'config.lua'
}