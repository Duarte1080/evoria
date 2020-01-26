ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job = xPlayer.job.grade_name
			local salary = xPlayer.job.grade_salary
			local prime = 15
			local boss = xPlayer.job.grade_name == 'boss'

			if job == 'unemployed' then -- unemployed
				xPlayer.addAccountMoney('bank', salary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
			elseif Config.EnableSocietyPayouts then -- possibly a society
				TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
					if society ~= nil then -- verified society
						TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
							if account.money >= salary then -- does the society money to pay its employees?
								xPlayer.addAccountMoney('bank', salary)
								account.removeMoney(salary)
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
								
								if not boss then
									xPlayer.addAccountMoney('bank', prime)
									TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu votre prime d\'activité: ~g~15$~s~')	
								end						
							else
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
								if not boss then
									xPlayer.addAccountMoney('bank', prime)
									TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu votre prime d\'activité: ~g~15$~s~')	
								end
							end
						end)
					else -- not a society
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
						if not boss then
							xPlayer.addAccountMoney('bank', prime)
							TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu votre prime d\'activité: ~g~15$~s~')	
						end
					end
				end)
			else -- generic job
				xPlayer.addAccountMoney('bank', salary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
				if not boss then
					xPlayer.addAccountMoney('bank', prime)
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu votre prime d\'activité: ~g~15$~s~')	
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end

ESX.StartPayCheckFaction = function()

	function payCheckFaction()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local faction = xPlayer.faction.grade_name
			local salary = xPlayer.faction.grade_salary

			if salary > 0 then
				if faction == 'resid' then -- Civil
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheckfaction'), _U('received_faction', salary), 'CHAR_BANK_MAZE', 9)
				elseif Config.EnableFactionPayouts then -- possibly a faction
					TriggerEvent('esx_faction:getFaction', xPlayer.faction.name, function (faction)
						if faction ~= nil then -- verified faction
							TriggerEvent('esx_addonaccount:getSharedAccount', faction.account, function (account)
								if account.money >= salary then -- does the faction money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)
	
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheckfaction'), _U('received_salary_faction', salary), 'CHAR_BANK_MAZE', 9)
								else
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('companyfaction_nomoney'), 'CHAR_BANK_MAZE', 1)
								end
							end)
						else -- not a faction
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheckfaction'), _U('received_salary_faction', salary), 'CHAR_BANK_MAZE', 9)
						end
					end)
				else -- generic faction
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheckfaction'), _U('received_salary_faction', salary), 'CHAR_BANK_MAZE', 9)
				end
			end

		end

		SetTimeout(Config.PaycheckFactionInterval, payCheckFaction)

	end

	SetTimeout(Config.PaycheckFactionInterval, payCheckFaction)

end