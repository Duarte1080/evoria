ESX = nil
local spawn = {}
local ZoneDeSpawnHeli = {coords = vector3(481.699, -982.20, 41.008)}
local MaxRenfort = 0
local renfortList = {}
local renfortBlip = {}
local renfortPed = {}
local renfortHelico = {}
local renfortHelicoPed = {}
local patrouilleMolduVeh = {}
local patrouilleMolduBlip = {}
local patrouilleMolduPed = {}
local vehicle = "police2"

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

_menuPool4 = NativeUI.CreatePool()
RenfortPNJMenu = NativeUI.CreateMenu("Menu véhicule", "~b~Sortir un véhicule de service.")
_menuPool4:Add(RenfortPNJMenu)
_menuPool4:WidthOffset(-50)


function SetVehicleMaxMods(vehicle)
    local props = {
        modEngine       = 3,
        modBrakes       = 3,
        modTransmission = 3,
        modSuspension   = 3,
        modTurbo        = true,
        windowTint = 2,
        modLivery = 2,
        plateIndex = 1,
    }
    SetVehicleDirtLevel(vehicle, 0.1)
    

    ESX.Game.SetVehicleProperties(vehicle, props)

end

local vehicule = {
    "police2",
    "police3",
    "police5",
    "police6",
    "police9",
    "police10",
    "police12",
    "police13",
    "police18",
}
local ZoneDeSpawn = {coords = vector3(454.56, -1023.92, 28.47)}

function RenfortPNJ(menu)
    local vehicule = NativeUI.CreateListItem("Véhicule pour patrouille", vehicule, 1, "Permet de choisir en quels véhicule les renfort vont venir")
    menu:AddItem(vehicule)
    local renfortSUV = NativeUI.CreateItem("Demande de renfort", "~b~Arrière")
    menu:AddItem(renfortSUV)
    local patrouille = NativeUI.CreateItem("Déployer une patrouille moldu", "~b~Permet de déployer une patrouille moldu")
    menu:AddItem(patrouille)
    local renfortHELI = NativeUI.CreateItem("Demande de renfort HELICO", "")
    menu:AddItem(renfortHELI)
    local renfortSireneOn = NativeUI.CreateItem("Renfort sirène ~g~ON", "")
    menu:AddItem(renfortSireneOn)
    local renfortSireneOff = NativeUI.CreateItem("Renfort sirène ~r~OFF", "")
    menu:AddItem(renfortSireneOff)
    local sortirVehicle = NativeUI.CreateItem("~r~Sortir ~w~des véhicules", "")
    menu:AddItem(sortirVehicle)
    local EntrerVehicule = NativeUI.CreateItem("~g~Entrer ~w~dans les véhicules", "Vous devez etre en véhicule")
    menu:AddItem(EntrerVehicule)
    local renfortTerminer = NativeUI.CreateItem("Annulé la demande de renfort", "")
    menu:AddItem(renfortTerminer)
    local patrouilleTermine = NativeUI.CreateItem("Terminer toutes les patrouilles", "")
    menu:AddItem(patrouilleTermine)
    menu.OnListChange = function(sender, item, index)
        if item == vehicule then
            local currentSelectedIndex = item:IndexToItem(index)
            vehicle = currentSelectedIndex
            --print(vehicle)
        end
    end

    

    menu.OnItemSelect = function(sender, item, index)
        if item == renfortSUV then
            --if MaxRenfort <= 1 then
                MaxRenfort = MaxRenfort + 1
                renfort = true
                local pedPlayer = GetPlayerPed(-1)
                local inVeh = IsPedInAnyVehicle(pedPlayer, false)
                if inVeh then
                    veh = GetVehiclePedIsIn(pedPlayer, false)
                    local clear = ESX.Game.IsSpawnPointClear(ZoneDeSpawn.coords, 8)

                    while not clear do
                        clear = ESX.Game.IsSpawnPointClear(ZoneDeSpawn.coords, 8)
                        ESX.ShowNotification("Point de spawn bloqué.")
                        Wait(100)
                    end

                    ESX.Game.SpawnVehicle(vehicle, ZoneDeSpawn.coords, 95.0, function(vehicule)
                        SetVehicleMaxMods(vehicule)
                        ped = CreatePedInsideVehicle(vehicule, 1, GetHashKey("s_m_y_cop_01"), -1, true, true)
                        TaskSetBlockingOfNonTemporaryEvents(ped, true)
                        TaskVehicleEscort(ped, vehicule, veh, -1, 320.0, 2883621, 1.0, 1, 30.0)

                        -- AI
                        SetCanAttackFriendly(ped, false, true)
                        SetPedAsCop(ped, true)
                        SetPedCombatAbility(ped, 0)
                        SetPedCombatAttributes(ped, 0, 1)
                        SetPedCombatAttributes(ped, 1, 1)
                        SetPedCombatAttributes(ped, 3, 0)
                        SetPedCombatAttributes(ped, 5, 0)
                        SetPedCombatAttributes(ped, 20, 1)
                        SetPedCombatAttributes(ped, 46, 0)
                        SetPedCombatAttributes(ped, 52, 0)
                        SetPedCombatRange(ped, 0)

                        SetVehicleDoorsLocked(vehicule, 4)

                        -- WEAPON FUN

                        --SetPedCombatAbility(ped, 100)
                        --SetPedCombatAttributes(ped, 1424, 1)
                        --GiveWeaponToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), math.random(20, 100), true, false)
                        --SetPedAmmo(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), math.random(20, 100))
                        --SetCurrentPedWeapon(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), true)
                        --SetPedAccuracy(ped, 100)
                        --SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_COMBATPISTOL"))
                        --GiveWeaponToPed(ped, GetHashKey("WEAPON_COMBATPISTOL"), math.random(20, 100), true, false)
                        --SetPedAmmo(ped, GetHashKey("WEAPON_COMBATPISTOL"), math.random(20, 100))
                        --SetCurrentPedWeapon(ped, GetHashKey("WEAPON_COMBATPISTOL"), true)
                        --SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_COMBATPISTOL"))
                        --SetPedTalk(ped)

                        blip = AddBlipForEntity(vehicule)
                        SetBlipSprite(blip, 56)
                        ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
                        SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
                        SetBlipScale(blip, 0.65) -- set scale
                        SetBlipShowCone(blip, true)
                        SetBlipShrink(blip, true)
                        ShowFriendIndicatorOnBlip(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("~b~Patrouille moldu.")
                        EndTextCommandSetBlipName(blip)

                        table.insert(renfortList, vehicule)
                        table.insert(renfortBlip, blip) 
                        table.insert(renfortPed, ped) 
                    end)
                    ESX.ShowNotification("Renfort moldu en approche.")
                   --_menuPool4:CloseAllMenus()
                else
                    ESX.ShowNotification("Tu doit etre en véhicule pour te faire éscorter.")
                end
            --else
            --    ESX.ShowNotification("Vous avez demandez trop d'unité.")
            --end
        elseif item == patrouille then
            local pedPlayer = GetPlayerPed(-1)
            --VehBlock = ESX.Game.GetVehiclesInArea(ZoneDeSpawn.coords, 6)
            --for _, voiture in pairs(VehBlock) do
			--	ESX.Game.DeleteVehicle(voiture)
            --end

            local clear = ESX.Game.IsSpawnPointClear(ZoneDeSpawn.coords, 8)

            while not clear do
                clear = ESX.Game.IsSpawnPointClear(ZoneDeSpawn.coords, 8)
                Wait(100)
            end
            --if not spawn == "non" then
                ESX.Game.SpawnVehicle(vehicle, ZoneDeSpawn.coords, 95.0, function(vehicule)
                    SetVehicleMaxMods(vehicule)
                    ped = CreatePedInsideVehicle(vehicule, 1, GetHashKey("s_m_y_cop_01"), -1, true, true)
                    TaskVehicleDriveWander(ped, vehicule, 50.0, 786603)

                    -- AI
                    SetCanAttackFriendly(ped, false, true)
                    SetPedAsCop(ped, true)
                    SetPedCombatAbility(ped, 0)
                    SetPedCombatAttributes(ped, 0, 1)
                    SetPedCombatAttributes(ped, 1, 1)
                    SetPedCombatAttributes(ped, 3, 0)
                    SetPedCombatAttributes(ped, 5, 0)
                    SetPedCombatAttributes(ped, 20, 1)
                    SetPedCombatAttributes(ped, 46, 0)
                    SetPedCombatAttributes(ped, 52, 0)
                    SetPedCombatRange(ped, 0)

                    SetVehicleDoorsLocked(vehicule, 4)

                   
                    blip = AddBlipForEntity(vehicule)
                    SetBlipSprite(blip, 1)
                    ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
                    SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
                    SetBlipScale(blip, 0.65) -- set scale
                    SetBlipShowCone(blip, true)
                    SetBlipShrink(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("~b~Patrouille moldu.")
                    EndTextCommandSetBlipName(blip)

                    --table.insert(patrouilleMolduVeh, vehicule)
                    table.insert(patrouilleMolduBlip, blip) 
                    table.insert(patrouilleMolduPed, ped) 
                    TriggerServerEvent('police:GetTableServeur', patrouilleMolduVeh)
                end)
                ESX.ShowNotification("Patrouille déployé.")
            --else
            --    ESX.ShowNotification("Pas de spawn possible.")
            --end
        elseif item == renfortHELI then
                renfort = true
                local pedPlayer = GetPlayerPed(-1)
                local inVeh = IsPedInAnyVehicle(pedPlayer, false)
                if inVeh then
                    veh = GetVehiclePedIsIn(pedPlayer, false)
                    VehBlock = ESX.Game.GetVehiclesInArea(ZoneDeSpawnHeli.coords, 10)
                    for _, voiture in pairs(VehBlock) do
                        ESX.Game.DeleteVehicle(voiture)
                    end
    
                    ESX.Game.SpawnVehicle("frogger2", ZoneDeSpawnHeli.coords, 95.0, function(vehicule)
                        SetVehicleMaxMods(vehicule)
                        ped = CreatePedInsideVehicle(vehicule, 6, GetHashKey("s_m_y_cop_01"), -1, true, false)
                        --TaskVehicleEscort(ped, vehicule, veh, -1, 320.0, 1074528293, 1.0, 1, 30.0)
                        SetCanAttackFriendly(ped, false, true)
                        TaskHeliChase(ped, veh, 0.0, 0.0, 80.0)
                        SetVehicleSearchlight(vehicule, true, false)
    
                        blip = AddBlipForEntity(vehicule)
                        SetBlipSprite(blip, 15)
                        ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
                        SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
                        SetBlipScale(blip, 0.65) -- set scale
                        SetBlipShowCone(blip, true)
                        SetBlipShrink(blip, true)
                        SetBlipCategory(blip, 7)
                        ShowFriendIndicatorOnBlip(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("~b~Patrouille moldu.")
                        EndTextCommandSetBlipName(blip)
    
                        table.insert(renfortHelico, vehicule)
                        table.insert(renfortBlip, blip) 
                        table.insert(renfortHelicoPed, ped) 
                    end)
                    ESX.ShowNotification("Renfort moldu en approche.")
                    _menuPool4:CloseAllMenus()
                else
                    ESX.ShowNotification("Tu doit etre en véhicule pour te faire éscorter.")
                end
        elseif item == renfortSireneOn then  
            for _, voiture in pairs(renfortList) do
                SetVehicleSiren(voiture, true)
            end
        elseif item == renfortSireneOff then  
            for _, voiture in pairs(renfortList) do
                SetVehicleSiren(voiture, false)
            end
        elseif item == renfortTerminer then  
            for _, voiture in pairs(renfortList) do
                --ESX.Game.DeleteVehicle(voiture)
                ped = GetPedInVehicleSeat(voiture, -1)
                TaskVehicleDriveWander(ped, voiture, 85.0, 786603)
                SetVehicleAsNoLongerNeeded(voiture)
                SetPedAsNoLongerNeeded(ped)
            end
            for _, blip in pairs(renfortBlip) do
                RemoveBlip(blip)
            end
            for _, heli in pairs(renfortHelico) do
                DeleteEntity(heli)
            end
            for _, ped in pairs(renfortHelicoPed) do
                DeleteEntity(ped)
            end
            renfortList = {}
            renfortBlip = {}
            renfortPed = {}
            renfortHelico = {}
            renfortHelicoPed = {}
            MaxRenfort = 0
        elseif item == patrouilleTermine then  
            for _, voiture in pairs(patrouilleMolduVeh) do
                --ESX.Game.DeleteVehicle(voiture)
                ped = GetPedInVehicleSeat(voiture, -1)
                TaskVehicleDriveWander(ped, voiture, 85.0, 786603)
                SetVehicleAsNoLongerNeeded(voiture)
                SetPedAsNoLongerNeeded(ped)
            end
            for _, blip in pairs(patrouilleMolduBlip) do
                RemoveBlip(blip)
            end
            patrouilleMolduVeh = {}
            patrouilleMolduBlip = {}
            TriggerServerEvent('police:GetTableServeur', patrouilleMolduVeh)
        elseif item == sortirVehicle then 
            for _, ped in pairs(renfortPed) do
                TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 256)
                TaskWanderStandard(ped, 10.0, 10)
                SetVehicleAsNoLongerNeeded(GetVehiclePedIsIn(ped, false))
                SetPedAsNoLongerNeeded(ped)
            end
        elseif item == EntrerVehicule then 
            local PlayerPed = GetPlayerPed(-1)
            for _, ped in pairs(renfortPed) do
                TaskEnterVehicle(ped, GetVehiclePedIsIn(ped, true), 1, -1, 2.0, 1, 0)
                Wait(1000)
                TaskVehicleEscort(ped, GetVehiclePedIsIn(ped, true), GetVehiclePedIsIn(PlayerPed, false), -1, 320.0, 2883621, 1.0, 1, 30.0)
            end
        end
    end
end



local count = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        while ESX == nil do
            Citizen.Wait(10)
        end
        _menuPool4:ProcessMenus()
        if count == 0 then
            RenfortPNJ(RenfortPNJMenu)
            count = 1
        end
    end
end)


_menuPool4:RefreshIndex()
_menuPool4:MouseControlsEnabled (false);
_menuPool4:MouseEdgeEnabled (false);
_menuPool4:ControlDisablingEnabled(false);

function OpenRenfortPNJMenu(station)
    RenfortPNJMenu:Visible(not RenfortPNJMenu:Visible())
end







RegisterNetEvent("police:GetTable")
AddEventHandler("police:GetTable", function()
    local veh = ESX.Game.GetClosestVehicle(ZoneDeSpawn.coords)
    table.insert(patrouilleMolduVeh, veh)
    print("Vehicule: "..veh.." ajouté à la table")
    print(patrouilleMolduVeh)
end)


-- IA EN COURS DE DEV, NE JAMAIS TOUCHER 


--Citizen.CreateThread(function()
--    while true do
--        Citizen.Wait(1000)
--        local ped = GetPlayerPed(-1)
--        if IsPedInAnyVehicle(ped, false) then
--            local PlayerCoords = GetEntityCoords(ped, true)
--            local veh = GetVehiclePedIsIn(ped)
--            local speed = GetEntitySpeed(veh)
--            local speed2 = speed*3.6
--            --print("Oui ça marche bien: \nVeh:"..veh.."\nSpeed: "..speed2.."Kmh")
--            if speed2 >= 100.0 then
--                for _, voiture in pairs(patrouilleMolduVeh) do
--                    local coordsModlu = GetEntityCoords(voiture, true)
--                    local distanceNPC = GetDistanceBetweenCoords(PlayerCoords, coordsModlu, true)
--                    if distanceNPC <= 20.0 then
--                        --print("^1Yes")
--                        ESX.ShowNotification("~b~Exès de vitesse\n~w~Flashé à: ~r~"..speed2.."Kmh ~w~\nVous êtes poursuivie par la ~b~LSPD.")
--                        poursuiteEngager(voiture, veh)
--                        break
--                    end
--                end
--            end
--        end
--    end
--end)