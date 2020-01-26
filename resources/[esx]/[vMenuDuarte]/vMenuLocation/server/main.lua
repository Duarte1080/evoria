--||@SuperCoolDuarte.||--

ESX              = nil
local PlayerData = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_joblisting:setJobMiner')
AddEventHandler('esx_joblisting:setJobMiner', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("fermier", 0)	
end)


RegisterServerEvent('esx_joblisting:setJobChome')
AddEventHandler('esx_joblisting:setJobChome', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("rsa", 0)	
end)

RegisterServerEvent('esx_joblisting:setJobMedics')
AddEventHandler('esx_joblisting:setJobMedics', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("ambulance", 0)	
end)