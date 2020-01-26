--||@SuperCoolNinja.||--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_bankerjob:customerDeposit')
AddEventHandler('esx_bankerjob:customerDeposit', function (target, amount)
  local xPlayer = ESX.GetPlayerFromId(target)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'montant invalide')
    end
  end)
end)


RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		-- advanced notification with bank icon
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Maze Bank', 'Account Notification', 'Invalid amount.', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeMoney(amount)
		TriggerEvent('esx_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function (account)
			account.addMoney(amount)
		  end)
                -- advanced notification with bank icon
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Maze Bank', 'Account Notification', 'You have deposited: ~g~$' .. amount .. '~s~', 'CHAR_BANK_MAZE', 9)
	end
end)
--------------et en haut c'est bank_savings-----------------------------------------
---------en bas c'est les function es-----------------------------------------------
RegisterServerEvent("nMenuBanque:DeposerArgent")
AddEventHandler("nMenuBanque:DeposerArgent", function(amount)
	local source = source
	local xPlayer = GetPlayerIdentifiers(source)[1]
	local rounded = tonumber(amount)

	TriggerEvent('esx:playerLoaded', source, function(user)
		
		if(tonumber(rounded) <= tonumber(user.getMoney())) then
			user.removeMoney(rounded)
			user.addBank(rounded)
			local myNewCash = tonumber(user.getMoney())
			TriggerEvent('esx_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function (account)
				account.addMoney(amount)
			  end)
			TriggerClientEvent('nMenuNotif:showNotification', source, "Vous avez déposer : ~g~$:" ..rounded)
			TriggerClientEvent('nArgent:DisplayCashValue', source, myNewCash)
			TriggerClientEvent('nArgent:DisplayBankValue', source, myNewBank)
		else
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Vous n'avez pas cette somme d'argent sur vous !")
		end
	end)
end)

RegisterServerEvent('nArgent:AddCash')
AddEventHandler('nArgent:AddCash', function(value)
	local src = source
	local license = GetPlayerIdentifiers(src)[1]
	TriggerEvent('es:getPlayerFromId', src, function(user)
	local newValue = user.getMoney() + value
	local CashResult = MySQL.Sync.fetchScalar("SELECT money FROM users WHERE license = @license", { ['license'] = license})
		if CashResult then
			local newCashValue = CashResult + value
			MySQL.Sync.execute("UPDATE users SET money=@value WHERE license = @license", {['license'] = license, ['value'] = tostring(newCashValue)})
			TriggerClientEvent('nArgent:DisplayCashValue', src, newCashValue)
			CashResult = nil
		end
	end)
end)

RegisterServerEvent('nArgent:AddBank')
AddEventHandler('nArgent:AddBank', function(value)
	local src = source
	local license = GetPlayerIdentifiers(src)[1]
	TriggerEvent('es:getPlayerFromId', src, function(user)
	local newValue = user.getBank() + value
	local result = MySQL.Sync.fetchScalar("SELECT bank FROM users WHERE license = @license", { ['license'] = license})
		if result then
			newBankvalue = result + value
			TriggerClientEvent('nArgent:DisplayBankValue', src, newBankvalue)
			MySQL.Sync.execute("UPDATE users SET bank=@value WHERE license = @license", {['license'] = license, ['value'] = tostring(newBankvalue)})
			local result = nil
		end
	end)
end)

RegisterServerEvent('nArgent:ClearCash')
AddEventHandler('nArgent:ClearCash', function(value)
	local src = source
	local license = GetPlayerIdentifiers(src)[1]
	TriggerEvent('es:getPlayerFromId', src, function(user)
		local newClearCashValue = user.getMoney() - value
		MySQL.Sync.execute("UPDATE users SET money=@value WHERE license = @license", {['license'] = license, ['value'] = tostring(newClearCashValue)})
		TriggerClientEvent('nArgent:DisplayCashValue', src, newClearCashValue)
	end)
end)

RegisterServerEvent('nArgent:ClearBank')
AddEventHandler('nArgent:ClearBank', function(value)
	local src = source
	local license = GetPlayerIdentifiers(src)[1]
	TriggerEvent('es:getPlayerFromId', src, function(user)
		local newValue = user.getBank() - value
		MySQL.Sync.execute("UPDATE users SET bank=@value WHERE license = @license", {['license'] = license, ['value'] = tostring(newValue)})
		TriggerClientEvent('nArgent:DisplayBankValue', src, newValue)
	end)
end)


RegisterServerEvent('nBanqueSolde:SRender')
AddEventHandler('nBanqueSolde:SRender', function()
	local player = GetPlayerIdentifiers(source)[1]
	local source = source	
	TriggerClientEvent('nBanqueSolde:CRender', source)
end)