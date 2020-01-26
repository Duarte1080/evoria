ESX              = nil
local PlayerData = {}
pBreaking = false
local Time = 10 * 1000 -- Time for each stage (ms)


local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local vehicle
function disableEngine()
	Citizen.CreateThread(function()
		while hotwiring do
			SetVehicleEngineOn(vehicle, false, true, false)
			if not hotwiring then
				break
			end
			Citizen.Wait(0)
		end
	end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

RegisterNetEvent('nfwlock:onUse')
AddEventHandler('nfwlock:onUse', function()
	local playerPed		= GetPlayerPed(-1)
  local coords		= GetEntityCoords(playerPed)
    

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = nil
    pBreaking = true

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if GetVehicleDoorLockStatus(vehicle) == 1 then
		ShowNotif('~g~La porte du véhicule n\'est pas verrouillée', 5000)
      pBreaking = false
      return
    end

		if DoesEntityExist(vehicle) then
			TriggerServerEvent('nfwlock:removeKit')
		end

    Citizen.Wait(1000)

	  RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.CreateThread(function()
      exports['progressBars']:startUI(30000, "Lockpicking...")

      Citizen.Wait(30000)
      alarmChance = math.random(100)
      if alarmChance <= cfg.alarmPercent then
        local pPed = GetPlayerPed(-1)
        local pPos = GetEntityCoords(pPed)
        local sPlates = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('Grand Theft Auto in progress. Plates: ' .. sPlates), pPos, {

          PlayerCoords = { x = pPos.x, y = pPos.y, z = pPos.z },
        })
        Citizen.Wait(2000)
        SetVehicleAlarm(vehicle, true)
		    SetVehicleAlarmTimeLeft(vehicle, 30 * 1000)
		    SetVehicleDoorsLocked(vehicle, 1)
		    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
      else
        SetVehicleDoorsLocked(vehicle, 1)
		    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
      end
    end)			
  end
end)	


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    if pBreaking then
      local veh = GetVehiclePedIsIn(playerPed, false)
      local vehPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "bonnet"))
      if IsPedInAnyVehicle(playerPed, false) then
        DrawText3Ds(vehPos.x, vehPos.y, vehPos.z, "Press [H] to hotwire")
        if IsControlJustPressed(0, 304) then
          SetVehicleNeedsToBeHotwired(veh, true)
          hotWire(veh)
        end
      end
    end
  end
end)

function hotWire(vehicle)
  if IsVehicleNeedsToBeHotwired(vehicle) then
    disableEngine()
    hotwiring = true
    pBreaking = false
    loadAnimDict(animDict)
    ClearPedTasks(player_entity)
    TaskPlayAnim(player_entity, animDict, anim, 3.0, 1.0, 2000, flags, -1, 0, 0, 0)
    if hotwiring then
      exports['progressBars']:startUI(Time, "Hotwiring Vehicle...")
      Citizen.Wait(Time+500)
    end
    hotwiring = false
    StopAnimTask(player_entity, animDict, anim, 1.0)
    Citizen.Wait(1000)
    TriggerEvent('EngineToggle:Engine')
    SetVehicleJetEngineOn(vehicle, true)
    RemoveAnimDict(animDict)
    if not Radio then
      SetVehicleRadioEnabled(vehicle, false)
    end
  end
end

local vehicles = {}; RPWorking = true

RegisterNetEvent('EngineToggle:Engine')
AddEventHandler('EngineToggle:Engine', function()
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	Citizen.Wait(1500)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
		if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
			vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
      if vehicles[StateIndex][2] then
		ShowNotif('~g~Moteur allumé!', 5000)
			end
		end 
  end 
end)

function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
  end
		
function isPlayerJobPolice()
	for k,v in pairs(ESX.GetPlayerData()) do
		for k,v in pairs(k) do
			print(v)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		-- gets if player is entering vehicle
		if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			-- gets vehicle player is trying to enter and its lock status
			local xPlayer = ESX.GetPlayerData()
			local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
			local lock = GetVehicleDoorLockStatus(veh)
				
				-- Get the conductor door angle, open if value > 0.0
				local doorAngle = GetVehicleDoorAngleRatio(veh, 0)
			
				-- normalizes chance
				if cfg.chance > 100 then
					cfg.chance = 100
				elseif cfg.chance < 0 then
					cfg.chance = 0
				end
			
				-- check if got lucky
				local lucky = (math.random(100) < cfg.chance)
			
				-- Set lucky if conductor door is open
				if doorAngle > 0.0 then
					lucky = true
				end
			
				-- check if vehicle is in blacklist
				local blacklisted = false
				for k,model in pairs(cfg.blacklist) do
					if IsVehicleModel(veh, GetHashKey(model)) then
						blacklisted = true
					end
				end

				-- gets ped that is driving the vehicle
				local pedd = GetPedInVehicleSeat(veh, -1)
				local plate = GetVehicleNumberPlateText(veh)
				-- lock doors if not lucky or blacklisted
				if ((lock == 7) or (pedd ~= 0 )) then
					if has_value(cfg.job_whitelist, xPlayer.job.name) then
						TriggerServerEvent('nfwlock:setVehicleDoorsForEveryone', {veh, 1, plate})
					else
						if not lucky or blacklisted then
							TriggerServerEvent('nfwlock:setVehicleDoorsForEveryone', {veh, 2, plate})
						else
							TriggerServerEvent('nfwlock:setVehicleDoorsForEveryone', {veh, 1, plate})
						end
					end
				end
			end
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('nfwlock:setVehicleDoors')
AddEventHandler('nfwlock:setVehicleDoors', function(veh, doors)
  SetVehicleDoorsLocked(veh, doors)
  SetVehicleNeedsToBeHotwired(veh, false)
end)
