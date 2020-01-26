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
	
	xPlayer.setJob("unemployed", 0)	
end)

RegisterServerEvent('esx_joblisting:setJobslaughterer')
AddEventHandler('esx_joblisting:setJobslaughterer', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("slaughterer", 0)	
end)

RegisterServerEvent('esx_joblisting:setJobminer')
AddEventHandler('esx_joblisting:setJobminer', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("miner", 0)
end)

RegisterServerEvent('esx_joblisting:setJobtextil')
AddEventHandler('esx_joblisting:setJobtextil', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.setJob("textil", 0)
end)