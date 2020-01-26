resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'vMenuDuarte'
version '1.0'

dependency 'es_extended'

	server_scripts {
		'@mysql-async/lib/MySQL.lua',
		'server/main.lua',
	}

client_scripts {
	"NativeUILua_Reloaded/Wrapper/Utility.lua",
	
	"NativeUILua_Reloaded/UIElements/UIVisual.lua",
	"NativeUILua_Reloaded/UIElements/UIResRectangle.lua",
	"NativeUILua_Reloaded/UIElements/UIResText.lua",
	"NativeUILua_Reloaded/UIElements/Sprite.lua",

	"NativeUILua_Reloaded/UIMenu/elements/Badge.lua",
	"NativeUILua_Reloaded/UIMenu/elements/Colours.lua",
	"NativeUILua_Reloaded/UIMenu/elements/StringMeasurer.lua",
	"NativeUILua_Reloaded/UIMenu/items/UIMenuItem.lua",
	"NativeUILua_Reloaded/UIMenu/items/UIMenuCheckboxItem.lua",
	"NativeUILua_Reloaded/UIMenu/items/UIMenuListItem.lua",
	"NativeUILua_Reloaded/UIMenu/UIMenu.lua",
	"NativeUILua_Reloaded/UIMenu/MenuPool.lua",

	"NativeUILua_Reloaded/NativeUI.lua",
}

client_scripts {
	'client/police.lua',
	'client/main.lua',
	'client/radar.lua',
}