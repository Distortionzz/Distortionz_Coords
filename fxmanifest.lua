fx_version 'cerulean'
game 'gta5'

author 'Distortionz'
description 'Distortionz Coords - dev laser tool: point at anything and read/copy its coords (vec3 / vec4 / heading / entity).'
version '1.1.4'
repository 'https://github.com/Distortionzz/Distortionz_Coords'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua',
    'version_check.lua'
}

dependencies {
    'ox_lib'
}
