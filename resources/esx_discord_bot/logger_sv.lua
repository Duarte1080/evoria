local logs = "https://discordapp.com/api/webhooks/549186910329896971/ZEg0FJ1D4qh3WsKiDzARyQqxGwFrN_vFhFDa5TZnzYFlNkFSpUI1tDcdWuRyMrjGsSsk"

AddEventHandler('playerConnecting', function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local connect = {
        {
            ["color"] = "8421504",
            ["title"] = "Connection",
            ["description"] = "Joueur: **"..name.."**\nIP: **"..ip.."**\n Steam ID: **"..steamhex.."**",
	        ["footer"]=  {
                ["text"]= "Evoria !",
            },
        }
    }

PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Evoria !", embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function(reason)
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local disconnect = {
        {
            ["color"] = "8421504",
            ["title"] = "Déconnection",
            ["description"] = "Joueur: **"..name.."** \nRaison: **"..reason.."**\nIP: **"..ip.."**\n Steam ID: **"..steamhex.."**",
	        ["footer"]=  {
                ["text"]= "Evoria !",
            },
        }
    }
    
PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Evoria !", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end)
