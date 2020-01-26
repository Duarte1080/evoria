ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getMaximumGrade(jobname)
	local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;", {
		['@jobname'] = jobname
	})

	if result[1] ~= nil then
		return result[1].grade
	end

	return nil
end

ESX.RegisterServerCallback('vMenuDuarte:Bill_getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('vMenuDuarte:Admin_getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local playerGroup = xPlayer.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb(nil)
        end
	else
		cb(nil)
	end
end)

-- Weapon Menu --

RegisterServerEvent("vMenuDuarte:Weapon_addAmmoToPedS")
AddEventHandler("vMenuDuarte:Weapon_addAmmoToPedS", function(plyId, value, quantity)
	TriggerClientEvent('vMenuDuarte:Weapon_addAmmoToPedC', plyId, value, quantity)
end)

-- Admin Menu --

RegisterServerEvent("vMenuDuarte:Admin_BringS")
AddEventHandler("vMenuDuarte:Admin_BringS", function(plyId, plyPedCoords)
	TriggerClientEvent('vMenuDuarte:Admin_BringC', plyId, plyPedCoords)
end)

-- Grade Menu --

RegisterServerEvent('vMenuDuarte:Boss_promouvoirplayer')
AddEventHandler('vMenuDuarte:Boss_promouvoirplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1

	if (targetXPlayer.job.grade == maximumgrade) then
		TriggerClientEvent('esx:showNotification', _source, "Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) + 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~promu par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('vMenuDuarte:Boss_destituerplayer')
AddEventHandler('vMenuDuarte:Boss_destituerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) - 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('vMenuDuarte:Boss_recruterplayer')
AddEventHandler('vMenuDuarte:Boss_recruterplayer', function(target, job, grade)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	targetXPlayer.setJob(job, grade)

	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('vMenuDuarte:Boss_virerplayer')
AddEventHandler('vMenuDuarte:Boss_virerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"

	if (sourceXPlayer.job.name == targetXPlayer.job.name) then

		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

RegisterServerEvent('vMenuDuarte:Boss_promouvoirplayer2')
AddEventHandler('vMenuDuarte:Boss_promouvoirplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.faction.name)) -1

	if (targetXPlayer.faction.grade == maximumgrade) then
		TriggerClientEvent('esx:showNotification', _source, "Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
			local grade2 = tonumber(targetXPlayer.faction.grade) + 1
			local faction = targetXPlayer.faction.name

			targetXPlayer.setfaction(faction, grade2)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~promu par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('vMenuDuarte:Boss_destituerplayer2')
AddEventHandler('vMenuDuarte:Boss_destituerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.faction.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
	else
		if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
			local grade2 = tonumber(targetXPlayer.faction.grade) - 1
			local faction = targetXPlayer.faction.name

			targetXPlayer.setfaction(faction, grade2)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('vMenuDuarte:Boss_recruterplayer2')
AddEventHandler('vMenuDuarte:Boss_recruterplayer2', function(target, faction, grade2)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	targetXPlayer.setfaction(faction, grade2)

	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('vMenuDuarte:Boss_virerplayer2')
AddEventHandler('vMenuDuarte:Boss_virerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local faction = "unemployed2"
	local grade2 = "0"

	if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
		targetXPlayer.setfaction(faction, grade2)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

-- HANDSUP --

RegisterServerEvent('vMenuDuarte:getSurrenderStatus')
AddEventHandler('vMenuDuarte:getSurrenderStatus', function(event, targetID)
	TriggerClientEvent(event, targetID, event, source)
end)

RegisterServerEvent('vMenuDuarte:sendSurrenderStatus')
AddEventHandler('vMenuDuarte:sendSurrenderStatus', function(event, targetID, handsup)
	TriggerClientEvent(event, targetID, handsup)
end)

RegisterServerEvent('vMenuDuarte:reSendSurrenderStatus')
AddEventHandler('vMenuDuarte:reSendSurrenderStatus', function(event, targetID, handsup)
	TriggerClientEvent(event, targetID, handsup)
end)


----------------menote-----------------------
RegisterServerEvent("nPolice:MenotterServer")
AddEventHandler("nPolice:MenotterServer", function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('vMenuNotif:showNotification', targetid, "Une personne vous à menotter.")

	TriggerClientEvent('nPolice:Cgetarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('nPolice:Cdoarrested', _source)
end)

RegisterServerEvent('nPolice:Srequestrelease')
AddEventHandler('nPolice:Srequestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('nPolice:Cgetuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('nPolice:Cdouncuffing', _source)
end)

RegisterServerEvent("nPolice:sfouilleweapons")
AddEventHandler('nPolice:sfouilleweapons', function(NearestPlayerSID, weapons)
	TriggerClientEvent('vMenuNotif:showNotification', NearestPlayerSID,"Armes trouvé: " ..weapons)
end)



RegisterServerEvent("nPolice:Sfouille")
AddEventHandler('nPolice:Sfouille', function(NearestPlayerSID)
	local source = source
	items = {}
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local result = MySQL.Sync.fetchAll("SELECT count,label,item FROM user_inventory JOIN items ON `user_inventory`.`item` = `items`.`name` WHERE identifier = @username", { ['@username'] = targetid})
	
	for k,v in pairs(result) do 
		local item = ESX.Items[result[k].item]
		if item then
			items[result[k].item] = { ["count"] = result[k].count,  ["item"] = result[k].item,  ["label"] = result[k].label}
		end
	end
	
	TriggerClientEvent('nPolice:Cfouilleweapons', NearestPlayerSID, source)
	TriggerClientEvent('nPolice:Cfouille', source, NearestPlayerSID, items)
	TriggerClientEvent('vMenuNotif:showNotification', NearestPlayerSID, "Une personne vous fouille.")
end)
