_interactNPC = NativeUI.CreatePool()
interactMenu = NativeUI.CreateMenu("NPC Intéraction", "~b~Intéraction NPC")
_interactNPC:Add(interactMenu)
_interactNPC:WidthOffset(0)


local VehiculeDuPNJ = nil
local PNJActuel = nil

function InteractMenuItem(menu) 

    local suivre = NativeUI.CreateItem("Ordonner la voiture de suivre", "~g~Ordonne à la voiture (NPC) de devant de vous suivre.")
    menu:AddItem(suivre)
    local identite = NativeUI.CreateItem("Demander pièce identité", "~g~Demander au PNJ de donner ça pièce d'identité.")
    menu:AddItem(identite)
    local verifVeh = NativeUI.CreateItem("Vérifié le véhicule", "~g~Vérifier le véhicule.")
    menu:AddItem(verifVeh)
    local verifCoffre = NativeUI.CreateItem("Vérifié le coffre du véhicule", "~g~Vérifier le coffre du véhicule.")
    menu:AddItem(verifCoffre)
    local amende = NativeUI.CreateItem("Amender le PNJ", "~g~Donner une amende au PNJ.")
    menu:AddItem(amende)
    local laisser = NativeUI.CreateItem("Laisser partir le PNJ", "~g~Ordonne au PNJ de partir.")
    menu:AddItem(laisser)

    local actionNPC = _interactNPC:AddSubMenu(menu, "Action NPC ~g~>")
    local descendre = NativeUI.CreateItem("Descendre + Suivre", "~b~Faire déscendre le NPC + faire en sorte qu'il vous suis.")
    actionNPC.SubMenu:AddItem(descendre)
    local descendreMain = NativeUI.CreateItem("Descendre + lever les mains", "~b~Faire déscendre le NPC + lever les mains.")
    actionNPC.SubMenu:AddItem(descendreMain)
    local genoux = NativeUI.CreateItem("Se mettre à genoux", "~b~Faire mettre le PNJ à genoux.")
    actionNPC.SubMenu:AddItem(genoux)
    local monter = NativeUI.CreateItem("Remonter dans véhicule", "~b~Faire remonter le PNJ dans son véhicule.")
    actionNPC.SubMenu:AddItem(monter)
    local prison = NativeUI.CreateItem("Demander envoie prison", "~b~Faire envoyé le PNJ en prison.")
    actionNPC.SubMenu:AddItem(prison)


    actionNPC.SubMenu.OnItemSelect = function(sender, item, index)
        if item == descendre then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local NpcPed = GetPedInVehicleSeat(NpcVeh, -1)

            RequestControl(NpcPed)
            RequestControl(NpcVeh)

            TaskSetBlockingOfNonTemporaryEvents(NpcPed, 1)
            VehiculeDuPNJ = NpcVeh
            PNJActuel = NpcPed

            ClearPedTasks(NpcPed)
            TaskLeaveAnyVehicle(NpcPed, 1, 1)
            
            TaskGoToEntity(NpcPed, GetPlayerPed(-1), -1, 0.0001, 1.0, 1073741824.0, 0)
        elseif item == descendreMain then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local NpcPed = GetPedInVehicleSeat(NpcVeh, -1)

            RequestControl(NpcPed)
            RequestControl(NpcVeh)

            TaskSetBlockingOfNonTemporaryEvents(NpcPed, 1)
            VehiculeDuPNJ = NpcVeh
            PNJActuel = NpcPed

            ClearPedTasks(NpcPed)
            TaskLeaveAnyVehicle(NpcPed, 1, 1)
            Wait(2000)
            TaskHandsUp(NpcPed, -1, GetPlayerPed(-1), -1, 0)
        elseif item == monter then
            RequestControl(PNJActuel)
            RequestControl(VehiculeDuPNJ)
            TaskEnterVehicle(PNJActuel, VehiculeDuPNJ, 5000, -1, 1.0, 1, 0)
        elseif item == genoux then
            RequestControl(PNJActuel)
            loadAnimDict("random@arrests")
            loadAnimDict("random@arrests@busted")
            ClearPedTasksImmediately(PNJActuel)
            ClearPedTasks(PNJActuel)
            ClearPedSecondaryTask(PNJActuel)
            TaskPlayAnim(PNJActuel, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(PNJActuel, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(1000)
            TaskPlayAnim(PNJActuel, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)     
        elseif item == prison then     
            RequestControl(PNJActuel)
            TriggerEvent("LSPDFR:Prison", PNJActuel)
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == suivre then
            local Pveh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local NpcPed = GetPedInVehicleSeat(NpcVeh, -1)
            SetEntityAsMissionEntity(NpcVeh, 1, 1)
            SetEntityAsMissionEntity(NpcPed, 1, 1)

            RequestControl(NpcVeh)

            RequestControl(NpcPed)   

            if not IsPedAPlayer(NpcPed) then
                if NpcVeh ~= Pveh then
                    if NpcVeh ~= nil then
                        TaskVehicleEscort(NpcPed, NpcVeh, Pveh, 0, 30.0, 1074528293, 7.0, 10.0, 100.0)
                        SetVehicleSiren(Pveh, 1)
                        local NetId = NetworkGetNetworkIdFromEntity(Pveh)
                        TriggerServerEvent("siren:sync", 1, NetId)
                    end
                end
            end
        elseif item == laisser then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                Pveh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            else
                Pveh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
            end
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local VehPed = GetPedInVehicleSeat(NpcVeh, -1)

            RequestControl(NpcVeh)

            RequestControl(VehPed) 


            if not IsPedAPlayer(VehPed) then
                if NpcVeh ~= Pveh then
                    ClearPedTasks(VehPed)
                    TaskVehicleDriveWander(VehPed, NpcVeh, 15.0, 786603)
                    SetVehicleAsNoLongerNeeded(NpcVeh)
                    SetPedAsNoLongerNeeded(VehPed)
                    SetVehicleSiren(Pveh, 0)
                end
            end
        elseif item == amende then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local VehPed = GetPedInVehicleSeat(NpcVeh, -1)
            if VehPed == nil then
                RequestControl(PNJActuel)
                VehPed = PNJActuel
            end
            DonnerPNJamende(VehPed)
        elseif item == identite then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            local VehPed = GetPedInVehicleSeat(NpcVeh, -1)
            print(VehPed)
            if VehPed == 0 then
                RequestControl(PNJActuel)
                VehPed = PNJActuel
            end
            DemandePNJIdentite(VehPed)
        elseif item == verifVeh then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            DemandePNJVerifVeh(NpcVeh)
        elseif item == verifCoffre then
            local Zone = GetZoneDevant()
            local NpcVeh = ESX.Game.GetClosestVehicle(Zone)
            DemandePNJCoffre(NpcVeh)
        end

    end
end
 

function RequestControl(ent)
    while not NetworkHasControlOfEntity(ent) do
        NetworkRequestControlOfEntity(ent)
        Citizen.Wait(1)
    end
end


function GetZoneDevant()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    else
        veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    end
	local backwardPosition = GetOffsetFromEntityInWorldCoords(veh, 0, 8.0, 0 )
	return backwardPosition
end

function GetZoneArriere()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    else
        veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    end
	local backwardPosition = GetOffsetFromEntityInWorldCoords(veh, 0, -8.0, 0 )
	return backwardPosition
end

function DonnerPNJamende(ped)
    TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(GetPlayerPed(-1))
    Citizen.Wait(9000)
    if IsPedInAnyVehicle(ped, false) then
        VehPed = GetVehiclePedIsIn(ped, false)
    else
        VehPed = VehiculeDuPNJ
    end
    print(VehPed)
    RequestControl(VehPed)
    RequestControl(ped)
    ClearPedTasks(ped)
    
    TaskEnterVehicle(ped, VehPed, 5000, -1, 1.0, 1, 0)
    Wait(5000)

    TaskVehicleDriveWander(VehPed, ped, 15.0, 786603)
    SetVehicleAsNoLongerNeeded(ped)
    SetPedAsNoLongerNeeded(VehPed)    
end

function DemandePNJIdentite(ped)
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
    ESX.ShowNotification("~b~La personne cherche ça carte ...")

    Citizen.Wait(5000)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(ped)

    local nom = {
        "ABIGAIL",
        "AMANDA",
        "ANDREAS",
        "ANTONIA",
        "ASHLEY",
        "BARRY",
        "BEVERLY",
        "ALEX",
        "BENOIT",
        "GERARD",
        "BERTRAND",
    }
    local i = GetRandomIntInRange(1, #nom)
    local nomFinal = nom[i]
    local age = math.random(18, 60)
    local jours = math.random(1, 30)
    local mois = math.random(1, 12)
    local annee = 2018 - age

    ESX.ShowAdvancedNotification("LSPD", "~b~Carte d'identité", "Nom: ~b~"..nomFinal.."\n~w~Age: ~b~"..age.."\n~w~DOB: ~b~"..jours.."/"..mois.."/"..annee, mugshotStr, 8)
    UnregisterPedheadshot(mugshot)
    ClearPedTasks(GetPlayerPed(-1))
end

function DemandePNJVerifVeh(veh)
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetEntityModel(veh)
    local modelName = GetDisplayNameFromVehicleModel(model)
    local ped = GetPlayerPed(-1)
    ESX.ShowNotification("~b~Vous sortez votre radio ...")
    Wait(100)
    loadAnimDict( "random@arrests" )
    TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
    ESX.ShowAdvancedNotification("LSPD", "~b~LSPD RADIO", "Demande de vérification pour la plaque: ~b~"..plate, "CHAR_CALL911", 8)
    Wait(5000)
    ESX.ShowAdvancedNotification("LSPD", "~b~LSPD RADIO", "~g~Information\n~w~Plaque: ~b~"..plate.."\n~w~Modèle: ~b~"..modelName.."\n~w~Recherché: ~r~Non", "CHAR_CALL911", 8)

    local damage = IsVehicleDamaged(veh)
    if damage then
        ESX.ShowNotification("~b~Le véhicule semble avoir des dommages.")
    else
        ESX.ShowNotification("~b~Le véhicule n'a aucun problème.")
    end
    ClearPedTasks(ped)
end

function DemandePNJCoffre(veh)
    ESX.ShowNotification("~b~La personne ouvre le coffre ...")
    NetworkRequestControlOfEntity(veh)
    while not NetworkHasControlOfEntity(veh) do
        NetworkRequestControlOfEntity(veh)
        Citizen.Wait(1)
    end
    Wait(1000)
    SetVehicleDoorOpen(veh, 5, false, false)
    local bone = GetOffsetFromEntityInWorldCoords(veh, 0, -5.0, 0 )
    local fouille = false
    while not fouille do
        Citizen.Wait(1)
        DrawMarker(32, bone.x, bone.y, bone.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), bone, true)
        if distance <= 2.0 then
            fouille = true
        end
    end
    ESX.ShowNotification("~b~Vous fouillez le coffre ...")
    Wait(5000)
    SetVehicleDoorShut(veh, 5, 1)
    local random = math.random(1, 10)
    if random <= 8 then
        ESX.ShowNotification("~b~Il n'y à que des affaires personnel.")
    else
        ESX.ShowNotification("~b~Vous avez trouvé des stupéfiants.")
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        while ESX == nil do
            Citizen.Wait(10)
        end
        _interactNPC:ProcessMenus()
        if count == 0 then
            InteractMenuItem(interactMenu)
            count = 1
        end
    end
end)


_interactNPC:RefreshIndex()
_interactNPC:MouseControlsEnabled (false);
_interactNPC:MouseEdgeEnabled (false);
_interactNPC:ControlDisablingEnabled(false);
function OpenInteractNPC()
    interactMenu:Clear()
    InteractMenuItem(interactMenu)
    Wait(100)
    interactMenu:Visible(not interactMenu:Visible())
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if _interactNPC:IsAnyMenuOpen() then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local ActualVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local ZoneArriere = GetZoneDevant()
                local voiture = ESX.Game.GetClosestVehicle(ZoneArriere)
                local voitureCoords = GetEntityCoords(voiture)
                local distance = GetDistanceBetweenCoords(ZoneArriere, voitureCoords, true)

                if voiture ~= nil then
                    if voiture ~= ActualVeh then
                        DrawMarker(27, voitureCoords["x"], voitureCoords["y"], voitureCoords["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0, 255, 0, 270, false, false, 2, true, nil, nil, nil)
                    end
                end
            end
        end
    end
end)










-- prison





AddEventHandler("LSPDFR:Prison", function(ped)
    player = GetPlayerPed(-1)
    playerPos = GetEntityCoords(player)
    
    local targetVeh = ped

    local driverhash = GetHashKey("s_f_y_cop_01")
    RequestModel(driverhash)
    local vehhash = GetHashKey("police")
    RequestModel(vehhash)

    loadAnimDict("cellphone@")

    while not HasModelLoaded(driverhash) and RequestModel(driverhash) or not HasModelLoaded(vehhash) and RequestModel(vehhash) do
        RequestModel(driverhash)
        RequestModel(vehhash)
        Citizen.Wait(0)
    end

    if DoesEntityExist(targetVeh) then
    	if DoesEntityExist(mechVeh) then
			DeleteVeh(mechVeh, mechPed)
			SpawnVehicle(playerPos.x, playerPos.y, playerPos.x, vehhash, driverhash)
		else
			SpawnVehicle(playerPos.x, playerPos.y, playerPos.x, vehhash, driverhash)
		end
		playRadioAnim(player)
		GoToTarget(GetEntityCoords(targetVeh).x, GetEntityCoords(targetVeh).y, GetEntityCoords(targetVeh).z, mechVeh, mechPed, vehhash, targetVeh)
    end
end)

function SpawnVehicle(x, y, z, vehhash, driverhash)                                                     --Spawning Function
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(x + math.random(-100, 100), y + math.random(-100, 100), z, 0, 3, 0)

    if found and HasModelLoaded(vehhash) and HasModelLoaded(vehhash) then
        mechVeh = CreateVehicle(vehhash, spawnPos, spawnHeading, true, false)                           --Car Spawning.
        ClearAreaOfVehicles(GetEntityCoords(mechVeh), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(mechVeh)
        --SetVehicleColours(mechVeh, mechPedPick.colour, mechPedPick.colour)
        SetVehicleSiren(mechVeh, true)
        
        mechPed = CreatePedInsideVehicle(mechVeh, 26, driverhash, -1, true, false)  
        SetBlockingOfNonTemporaryEvents(mechPed, true)            		--Driver Spawning.
        SetEntityInvincible(mechPed, true)

        mechBlip = AddBlipForEntity(mechVeh)                                                        	--Blip Spawning.
        SetBlipFlashes(mechBlip, true)  
        SetBlipColour(mechBlip, 5)
    end
end

function DeleteVeh(vehicle, driver)
    SetEntityAsMissionEntity(vehicle, false, false)                                            			--Car Removal
    DeleteEntity(vehicle)
    SetEntityAsMissionEntity(driver, false, false)                                              		--Driver Removal
    DeleteEntity(driver)
    RemoveBlip(mechBlip)                                                                    			--Blip Removal
end

function GoToTarget(x, y, z, vehicle, driver, vehhash, target)
    TaskVehicleDriveToCoord(driver, vehicle, x, y, z, 13.0, 0, vehhash, 2883621, 1, true)
    ShowAdvancedNotification("CHAR_CALL911", "LSPD CENTRAL", "~b~Central LSPD information", "Un véhicule à été ~g~envoyé ~w~sur votre position.")
    enroute = true
    while enroute do
        Citizen.Wait(500)
        distanceToTarget = GetDistanceBetweenCoords(GetEntityCoords(target), GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z, true)
        if distanceToTarget < 20 then
            GoToTargetWalking(target, vehicle, driver)
        end
    end
end

function GoToTargetWalking(target, vehicle, driver)
    while enroute do
        Citizen.Wait(500)
        engine = GetEntityCoords(target, true)
        TaskGoToCoordAnyMeans(driver, engine, 2.0, 0, 0, 786603, 0xbf800000)
        distanceToTarget = GetDistanceBetweenCoords(engine, GetEntityCoords(driver).x, GetEntityCoords(driver).y, GetEntityCoords(driver).z, true)
        norunrange = false 
        if distanceToTarget <= 10 and not norunrange then -- stops ai from sprinting when close
            TaskGoToCoordAnyMeans(driver, engine, 1.0, 0, 0, 786603, 0xbf800000)
            norunrange = true
        end
        if distanceToTarget <= 2 then
            NetworkRequestControlOfEntity(target)
            while not NetworkHasControlOfEntity(target) do
                NetworkRequestControlOfEntity(target)
                Citizen.Wait(1)
            end
            --SetVehicleUndriveable(target, true)
            TaskTurnPedToFaceCoord(driver, engine, -1)
            Citizen.Wait(1000)
            ClearPedTasks(target)
            RequestAnimDict("mp_arresting")
            while not HasAnimDictLoaded("mp_arresting") do
                Citizen.Wait(0)
            end

            TaskStartScenarioInPlace(driver, "WORLD_HUMAN_COP_IDLES", 0, true)
            TaskPlayAnim(target, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(4500)
            ClearPedTasks(driver)
            RepairVehicle(target, vehicle, driver)
        end
        
    end
end

function RepairVehicle(target, vehicle, driver)
	enroute = false
    norunrange = false
    NetworkRequestControlOfEntity(target)
    while not NetworkHasControlOfEntity(target) do
        NetworkRequestControlOfEntity(target)
        Citizen.Wait(1)
    end
    RequestControl(target)
    RequestControl(vehicle)
    TaskEnterVehicle(target, vehicle, 5000, 2, 1.0, 1, 0)
    TaskEnterVehicle(driver, vehicle, 5000, -1, 1.0, 1, 0)
    SetPedAsNoLongerNeeded(target)
    Wait(5000)
	LeaveTarget(vehicle, driver, target)
end

function LeaveTarget(vehicle, driver, target)
	TaskVehicleDriveWander(driver, vehicle, 17.0, drivingStyle)
	SetEntityAsNoLongerNeeded(vehicle)
	SetPedAsNoLongerNeeded(driver)
    RemoveBlip(mechBlip)
	mechVeh = nil
	mechPed = nil
    targetVeh = nil
    Wait(60000)
    DeleteEntity(vehicle)
    DeleteEntity(driver)
    DeleteEntity(target)
end



function playRadioAnim(player)
    Citizen.CreateThread(function()
        RequestAnimDict(arrests)
        TaskPlayAnim(player, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
        Citizen.Wait(6000)
        ClearPedTasks(player)
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end