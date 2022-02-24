--[[
──────────────────────────────────────────────────────────────────

	Support: https://discord.gg/eKFb5QM3YF
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────────
]]--
fx_version "cerulean"
games {"gta5"}

title "Death System"
description "Dojrp based death system"
author "Andyyy#7666, Edited by Kayne#8814 to integrate Pulse"
version "v1.0"

client_script {
	"config.lua",
	"client.lua",
	"functions.lua",
}

server_script 'server.lua'
