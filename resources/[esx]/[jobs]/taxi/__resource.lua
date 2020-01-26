resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'taxi'

version 'V1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}