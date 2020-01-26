local oldPos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(PlayerPedId())

		if(oldPos ~= pos)then
			TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)
			oldPos = pos
		end
	end
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	TriggerServerEvent('playerSpawn')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerId = PlayerId()
		if GetPlayerWantedLevel(playerId) ~= 0 then
			SetPlayerWantedLevel(playerId, 0, false)
			SetPlayerWantedLevelNow(playerId, false)
		end
	end
end)