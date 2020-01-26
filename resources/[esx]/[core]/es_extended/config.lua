Config = {}
Config.Locale = 'fr'

Config.Accounts = { 'bank', 'black_money' }
Config.AccountLabels = { bank = _U('bank'), black_money = _U('black_money') }

Config.EnableSocietyPayouts = true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud = false
Config.PaycheckInterval = 10 * 60000
Config.PaycheckFactionInterval = 10 * 60000

--Config.MaxPlayers = GetConvarInt('sv_maxclients', 255) -- set this value to 255 if you're running OneSync

Config.EnableDebug = false