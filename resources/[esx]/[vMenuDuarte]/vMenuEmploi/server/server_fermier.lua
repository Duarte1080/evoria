--||@SuperCoolDuarte.||--
local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESX.RegisterServerCallback('fermier:getItemAmount', function(source, cb, item)

        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)

ESX.RegisterServerCallback('fermier:getItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemQty = xPlayer.getInventoryItem(item).count
    cb(itemQty)
end)


RegisterServerEvent('fermier:GiveOne')
AddEventHandler('fermier:GiveOne', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemQuantity = xPlayer.getInventoryItem('herbe').count

	if itemQuantity >= 100 then
		TriggerClientEvent('vMenu:TextInventoryFull', source)
		return
	else
		xPlayer.addInventoryItem('herbe', 1)
	end
end)

RegisterServerEvent('fermier:SellOne')
AddEventHandler('fermier:SellOne', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemQuantity = xPlayer.getInventoryItem('herbe').count
	local price = 2 --A CHANGER

	if itemQuantity < 1 then
		TriggerClientEvent('vMenu:noSell', source)
		return
	end

	xPlayer.removeInventoryItem('herbe', 1)
	TriggerClientEvent('vMenu:Selling', source)
	price = ESX.Math.Round(price)
	xPlayer.addMoney(price)
end)