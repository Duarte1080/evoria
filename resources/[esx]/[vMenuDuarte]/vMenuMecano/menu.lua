
---- --||@SuperCoolNinja.& Duarte||-- ----

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("~w~Macano","")
_menuPool:Add(mainMenu)

ESX = nil
local PlayerData = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local function fullReparationVeh()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then 
        local pos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.02, 0.0)
        local h = GetEntityHeading(myPed)
        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BUM_BIN", 0, true)
        exports['progressBars']:startUI(20000, "")
        Citizen.Wait(20000)
        ClearPedTasks(myPed)
        local vehicleHealth = GetEntityHealth(vehicle)
        if vehicleHealth >= 0 then
            Citizen.Wait(250)
            ClearPedTasks(myPed)
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetEntityHealth(vehicle,1000)
            SetVehiclePetrolTankHealth(vehicle,1000.0)
            SetVehicleEngineOn(vehicle, 0, 0, 0)
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            ShowNotif('~g~Le véhicule est comme neuf', 5000)
         end
    else
          ShowNotif("~r~Placer vous devant un véhicule", 5000)
   end
end

local function nettoyerVeh()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then 
        local pos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.02, 0.0)
        local h = GetEntityHeading(myPed)
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
        exports['progressBars']:startUI(20000, "")
        Citizen.Wait(20000)
        ClearPedTasks(myPed)
        local vehicleHealth = GetEntityHealth(vehicle)
        if vehicleHealth >= 0 then
             Citizen.Wait(250)
             ClearPedTasks(myPed)
             SetVehicleDirtLevel(vehicle, 0)
             ShowNotif('véhicule ~g~néttoyé', 5000)
        end
    else
        ShowNotif("~r~Placer vous devant un véhicule", 5000)
    end
end
        
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
 end
          
 function GetVehicleLookByPlayer(ped, dist)
   local playerPos = GetEntityCoords(ped, 1)
   local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, dist, 0.0 )
   return GetVehicleInDirection( playerPos, inFrontOfPlayer )
 end
          
 function getVehicleInDirection2(coordFrom, coordTo)
     local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
     local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
     return vehicle
 end

AddMenumacano = function(menu)
    local mecanoMenu = _menuPool:AddSubMenu(menu, "Les outils", "")

	local fixFullCarOption = NativeUI.CreateItem("Réparation Complète", "")
	mecanoMenu.SubMenu:AddItem(fixFullCarOption)

	local nettoyer = NativeUI.CreateItem("Nettoyer la voiture", "")
	mecanoMenu.SubMenu:AddItem(nettoyer)

	--------------||Selection LISTE JOBS||----------------
	mecanoMenu.SubMenu.OnItemSelect = function(sender, item, index)
            if item == fixFullCarOption then
			fullReparationVeh()
		elseif item == nettoyer then
			nettoyerVeh()
        end
    end
end
            
        
AddMenumacano(mainMenu)
_menuPool:RefreshIndex()


function ShowNotif(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

local jobss = {
    {x = 734.1746, y = -1088.8370, z = 22.198},
    {x = 702.2014, y = -1103.9046, z = 22.450},
}

Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

        for k in pairs(jobss) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, jobss[k].x, jobss[k].y, jobss[k].z) 

            if dist <= 1 then
                    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then    
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour accéder au Garage~s~")
                        if IsControlJustPressed(1,51) then
                            mainMenu:Visible(not mainMenu:Visible())
                        end
                    end
                end    
            end
        end
    end)
