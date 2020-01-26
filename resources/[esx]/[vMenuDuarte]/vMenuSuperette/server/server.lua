--||@SuperCoolDuarte.||--

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('mrv_robapu:rewards')
AddEventHandler('mrv_robapu:rewards', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local rewards = 12500

    xPlayer.addMoney(rewards)
end)

RegisterServerEvent('mrv_robapu:rewardsfood')
AddEventHandler('mrv_robapu:rewardsfood', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local items = {"bread", "water", "tel", "chips"}

    xPlayer.addInventoryItem(items[math.random(#items)], 1)
end)

RegisterServerEvent('mrv_robapu:callPolice')
AddEventHandler('mrv_robapu:callPolice', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

        for i = 1, #xPlayers, 1 do
        if xPlayer.job.name == 'police' then
        TriggerClientEvent('esx:showNotification', xPlayers[i], 'Un civil vous a envoyé un message : une superette se fait ~r~braquer~s~ !')
        end
    end
end)

RegisterServerEvent('buyWater')
AddEventHandler('buyWater', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('water')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('water', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)



RegisterServerEvent('buyPain')
AddEventHandler('buyPain', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('bread')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('bread', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)



RegisterServerEvent('buyCoca')
AddEventHandler('buyCoca', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('cocacola')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('cocacola', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)

RegisterServerEvent('buyChips')
AddEventHandler('buyChips', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('chips')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('chips', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)

RegisterServerEvent('buyTel')
AddEventHandler('buyTel', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('tel')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('tel', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)

RegisterServerEvent('buySim')
AddEventHandler('buySim', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem('sim')

	amount = ESX.Math.Round(amount)

	-- get price
	local price = 2

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, "~r~ Inventaire complet ~w~!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem('sim', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Merci de votre achat~w~.")
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent ~w~!")
	end
end)