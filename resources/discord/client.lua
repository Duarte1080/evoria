Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(668461432668684299)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('evoria')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('🌴Evoria🌴')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('discord')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('https://discord.gg/gaCMdZq')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		players = {}
		for i = 0, 31 do
			if NetworkIsPlayerActive( i ) then
				table.insert( players, i )
			end
		end
		SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. #players .. "/32")
	end
end)