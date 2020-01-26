ESX = nil
--local ZoneDeSpawn = {coords = vector3(452.04, -997.05, 25.76)}
--local cameraCoords = {coords = vector3(445.26, -994.35, 25.997)}
local couleurVeh = "blanc"

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



local endroit = "M"
local previewCoords = {}
local pointDeSpawn = {}
local cameraCoords = {}
local heading = 0
Citizen.CreateThread(function()
    while true do
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1), true)
        local MissionRowCoords = {coords = vector3(452.04, -997.05, 25.76)}
        local PaletoBeaCoords = {coords = vector3(-455.246, 6019.278, 31.490)}
        local distanceMissionRow = GetDistanceBetweenCoords(PlayerCoords, MissionRowCoords.coords, true)
        local distancePaletoBea = GetDistanceBetweenCoords(PlayerCoords, PaletoBeaCoords.coords, true)

        if distanceMissionRow < distancePaletoBea then
            endroit = "M"
            previewCoords = {coords = vector3(447.51, -997.02, 25.76)}
            pointDeSpawn = {coords = vector3(431.27, -997.62, 24.77)}
            cameraCoords = {coords = vector3(449.69, -999.67, 27.72)}
            heading = 180.0
        else
            endroit = "P"
            previewCoords = {coords = vector3(-365.178, 6065.46, 31.50)}
            pointDeSpawn = {coords = vector3(-472.02, 6034.90, 31.34)}
            cameraCoords = {coords = vector3(-363.72, 6069.79, 33.49)}
            heading = 230.0
        end
        Wait(10000)
    end
end)

_menuPool3 = NativeUI.CreatePool()
NatveVehMenu = NativeUI.CreateMenu(" ", "~b~Sortir un véhicule de service.")
_menuPool3:Add(NatveVehMenu)
_menuPool3:WidthOffset(0)


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
    SetVehicleDirtLevel(vehicle, 0.0)
    

    ESX.Game.SetVehicleProperties(vehicle, props)

end

function couleurVehicule(veh)
    --print(couleurVeh)
    if couleurVeh == "blanc" then
        -- Preview
        SetVehicleCustomPrimaryColour(previewVeh, 255, 255, 255)
        SetVehicleCustomSecondaryColour(previewVeh, 255, 255, 255)
        -- Vrais véhicule
        SetVehicleCustomPrimaryColour(veh, 255, 255, 255)
        SetVehicleCustomSecondaryColour(veh, 255, 255, 255)
    elseif couleurVeh == "noir" then
        SetVehicleCustomPrimaryColour(previewVeh, 0, 0, 0)
        SetVehicleCustomSecondaryColour(previewVeh, 0, 0, 0)
        SetVehicleCustomPrimaryColour(veh, 0, 0, 0)
        SetVehicleCustomSecondaryColour(veh, 0, 0, 0)
    elseif couleurVeh == "rouge" then
        SetVehicleCustomPrimaryColour(previewVeh, 255, 0, 0)
        SetVehicleCustomSecondaryColour(previewVeh, 255, 0, 0)
        SetVehicleCustomPrimaryColour(veh, 255, 0, 0)
        SetVehicleCustomSecondaryColour(veh, 255, 0, 0)
    elseif couleurVeh == "gris" then
        SetVehicleCustomPrimaryColour(previewVeh, 79, 79, 79)
        SetVehicleCustomSecondaryColour(previewVeh, 79, 79, 79)
        SetVehicleCustomPrimaryColour(veh, 79, 79, 79)
        SetVehicleCustomSecondaryColour(veh, 79, 79, 79)
    end
end


function menuVeh(menu)

    
    local Cadet = NativeUI.CreateItem("Voiture Cadet", "")
    local StatCadet = NativeUI.CreateStatisticsPanel()
    StatCadet:AddStatistics("Vitesse")
    StatCadet:SetPercentage(1, 70)
    
    StatCadet:AddStatistics("Maniabilité")
    StatCadet:SetPercentage(2, 80)
    
    StatCadet:AddStatistics("Nombre de place")
    StatCadet:SetPercentage(3, 80)
    
    Cadet:AddPanel(StatCadet)
    menu:AddItem(Cadet)
    
    local Buffalo = NativeUI.CreateItem("Buffalo Police", "")
    local StatBuffalo = NativeUI.CreateStatisticsPanel()
    StatBuffalo:AddStatistics("Vitesse")
    StatBuffalo:SetPercentage(1, 80)
    
    StatBuffalo:AddStatistics("Maniabilité")
    StatBuffalo:SetPercentage(2, 90)
    
    StatBuffalo:AddStatistics("Nombre de place")
    StatBuffalo:SetPercentage(3, 80)
    
    Buffalo:AddPanel(StatBuffalo)
    menu:AddItem(Buffalo)

    local Interceptor = NativeUI.CreateItem("Interceptor Police", "")
    local StatInterceptor = NativeUI.CreateStatisticsPanel()
    StatInterceptor:AddStatistics("Vitesse")
    StatInterceptor:SetPercentage(1, 90)
    
    StatInterceptor:AddStatistics("Maniabilité")
    StatInterceptor:SetPercentage(2, 75)
    
    StatInterceptor:AddStatistics("Nombre de place")
    StatInterceptor:SetPercentage(3, 80)
    
    Interceptor:AddPanel(StatInterceptor)
    menu:AddItem(Interceptor)
    local Moto = NativeUI.CreateItem("Moto Police", "")
    local StatMoto = NativeUI.CreateStatisticsPanel()
    StatMoto:AddStatistics("Vitesse")
    StatMoto:SetPercentage(1, 80)
    
    StatMoto:AddStatistics("Maniabilité")
    StatMoto:SetPercentage(2, 60)
    
    StatMoto:AddStatistics("Nombre de place")
    StatMoto:SetPercentage(3, 20)
    
    Moto:AddPanel(StatMoto)
    menu:AddItem(Moto)
    local Cruiser = NativeUI.CreateItem("Cruiser Unmarked", "")
    local StatCruiser = NativeUI.CreateStatisticsPanel()
    StatCruiser:AddStatistics("Vitesse")
    StatCruiser:SetPercentage(1, 90)
    
    StatCruiser:AddStatistics("Maniabilité")
    StatCruiser:SetPercentage(2, 90)
    
    StatCruiser:AddStatistics("Nombre de place")
    StatCruiser:SetPercentage(3, 80)
    
    Cruiser:AddPanel(StatCruiser)
    menu:AddItem(Cruiser)
    local BuffaloUnmark = NativeUI.CreateItem("Buffalo Unmarked", " ")
    local StatBuffalo = NativeUI.CreateStatisticsPanel()
    StatBuffalo:AddStatistics("Vitesse")
    StatBuffalo:SetPercentage(1, 90)
    
    StatBuffalo:AddStatistics("Maniabilité")
    StatBuffalo:SetPercentage(2, 90)
    
    StatBuffalo:AddStatistics("Nombre de place")
    StatBuffalo:SetPercentage(3, 80)
    
    BuffaloUnmark:AddPanel(StatBuffalo)
    menu:AddItem(BuffaloUnmark)
    local Pickup = NativeUI.CreateItem("Pickup Unmarked", "")
    local StatPickup = NativeUI.CreateStatisticsPanel()
    StatPickup:AddStatistics("Vitesse")
    StatPickup:SetPercentage(1, 90)
    
    StatPickup:AddStatistics("Maniabilité")
    StatPickup:SetPercentage(2, 90)
    
    StatPickup:AddStatistics("Nombre de place")
    StatPickup:SetPercentage(3, 80)
    
    Pickup:AddPanel(StatPickup)
    menu:AddItem(Pickup)
    
    local couleur = {
        "blanc",
        "noir",
        "rouge",
        "gris",
    }

    local couleur = NativeUI.CreateListItem("Couleur véhicule", couleur, 1, "Permet de choisir la couleur de son véhicule")
    menu:AddItem(couleur)
    menu.OnListChange = function(sender, item, index)
        if item == couleur then
            local currentSelectedIndex = item:IndexToItem(index)
            if currentSelectedIndex == "blanc" then
                couleurVeh = "blanc"
                couleurVehicule(previewVeh)
            elseif currentSelectedIndex == "noir" then
                couleurVeh = "noir"
                couleurVehicule(previewVeh)
            elseif currentSelectedIndex == "rouge" then
                couleurVeh = "rouge"
                couleurVehicule(previewVeh)
            elseif currentSelectedIndex == "gris" then
                couleurVeh = "gris"
                couleurVehicule(previewVeh)
            end
        end
    end

    menu.OnIndexChange = function(menu, newindex)
        --print(newindex)
        if newindex == 1 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("police")) then
                RequestModel(GetHashKey("police"))
                while not HasModelLoaded(GetHashKey("police")) do
                    Wait(10)
                end
            end 
            previewVeh = CreateVehicle(GetHashKey("police"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 2 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("police2")) then
                RequestModel(GetHashKey("police2"))
                while not HasModelLoaded(GetHashKey("police2")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("police2"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 3 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("police3")) then
                RequestModel(GetHashKey("police3"))
                while not HasModelLoaded(GetHashKey("police3")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("police3"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 4 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("policeb")) then
                RequestModel(GetHashKey("policeb"))
                while not HasModelLoaded(GetHashKey("policeb")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("policeb"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 5 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("police4")) then
                RequestModel(GetHashKey("police4"))
                while not HasModelLoaded(GetHashKey("police4")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("police4"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 6 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("fbi")) then
                RequestModel(GetHashKey("fbi"))
                while not HasModelLoaded(GetHashKey("fbi")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("fbi"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        elseif newindex == 7 then
            DeleteEntity(previewVeh)
            if not HasModelLoaded(GetHashKey("fbi2")) then
                RequestModel(GetHashKey("fbi2"))
                while not HasModelLoaded(GetHashKey("fbi2")) do
                    Wait(10)
                end
            end
            previewVeh = CreateVehicle(GetHashKey("fbi2"), previewCoords.coords, heading, false, 0)
            PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
            SetVehicleMaxMods(previewVeh)
            couleurVehicule(previewVeh)
            SetVehicleOnGroundProperly(previewVeh)
            FreezeEntityPosition(previewVeh, true)
            SetEntityCollision(previewVeh, false, false)
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == Cadet then
            spawnVeh("Mission row", "police")
        elseif item == Buffalo then
            spawnVeh("Mission row", "police2")
        elseif item == Interceptor then
            spawnVeh("Mission row", "police3")
        elseif item == Moto then
            spawnVeh("Mission row", "policeb")
        elseif item == Cruiser then
            spawnVeh("Mission row", "police4")
        elseif item == BuffaloUnmark then
            spawnVeh("Mission row", "fbi")
        end
    end
end


function spawnVeh(zone, vehicle)
    if endroit == "M" then
        VehBlock = ESX.Game.GetVehiclesInArea(pointDeSpawn.coords, 10)
        for _, voiture in pairs(VehBlock) do
	    	ESX.Game.DeleteVehicle(voiture)
        end
        local ped = GetPlayerPed(-1)
        ESX.Game.SpawnVehicle(vehicle, pointDeSpawn.coords, heading, function(veh)
            local plate = 'LSPD' .. math.random(100, 900)
            SetVehicleNumberPlateText(veh, plate)
            TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
            SetVehicleMaxMods(veh)
            blip = AddBlipForEntity(veh)
            SetBlipSprite(blip, 56)
            ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
            --SetBlipNameToPlayerName(blip, id) -- update blip name
            SetBlipScale(blip, 0.65) -- set scale
            --SetBlipAsShortRange(blip, true)
            SetBlipShowCone(blip, true)
            SetBlipShrink(blip, true)
            ShowFriendIndicatorOnBlip(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("~b~Véhicule de service.")
            EndTextCommandSetBlipName(blip)
            couleurVehicule(veh)
            exports["esx_legacyfuel"]:SetFuel(veh, 100)
            

            ESX.ShowAdvancedNotification("Centrale", "~b~Garage LSPD", "Votre véhicule de service est en train d'etre sortie.", "CHAR_CALL911", 8)

            local ped = CreatePedInsideVehicle(veh, 6, GetHashKey("s_m_y_cop_01"), -1, true, false)
            TaskVehicleDriveToCoord(ped, veh, 431.34, -1016.34, 28.05, 5.0, 1.0, GetHashKey(GetVehiclePedIsIn(ped, false)), 786603, 1.0, 1.0)
            local pedCoord = GetEntityCoords(ped, true)
            local voiture = GetVehiclePedIsIn(ped, false)
            local model = GetEntityModel(voiture)
            print(voiture)
            local name = GetDisplayNameFromVehicleModel(model)
            print(name)
            
            if name == "1200RT" then
                ModifyVehicleTopSpeed(voiture, 25*130.0)
                ModifyVehicleTopSpeed(veh, 25*130.0)
            end
            SetVehicleDirtLevel(voiture, 0.1)
            WashDecalsFromVehicle(voiture, 1.0)
            local distance = GetDistanceBetweenCoords(pedCoord, 431.34, -1015.81, 28.05, true)
            while distance > 3.0 do
                pedCoord = GetEntityCoords(ped, true)
                distance = GetDistanceBetweenCoords(pedCoord, 431.34, -1015.81, 28.05, true)
                if not IsPedInAnyVehicle(ped, false) then
                    break
                end
                Wait(100)
            end
            DeleteEntity(ped)
            ESX.ShowAdvancedNotification("Centrale", "~b~Garage LSPD", "Votre véhicule de service à été sortie.", "CHAR_CALL911", 8)
        end)
    else
        VehBlock = ESX.Game.GetVehiclesInArea(pointDeSpawn.coords, 10)
        for _, voiture in pairs(VehBlock) do
	    	ESX.Game.DeleteVehicle(voiture)
        end
        local ped = GetPlayerPed(-1)
        ESX.Game.SpawnVehicle(vehicle, pointDeSpawn.coords, heading, function(veh)
            local plate = 'LSPD' .. math.random(100, 900)
            SetVehicleNumberPlateText(veh, plate)
            TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
            SetVehicleMaxMods(veh)
            blip = AddBlipForEntity(veh)
            SetBlipSprite(blip, 56)
            ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
            --SetBlipNameToPlayerName(blip, id) -- update blip name
            SetBlipScale(blip, 0.65) -- set scale
            --SetBlipAsShortRange(blip, true)
            SetBlipShowCone(blip, true)
            SetBlipShrink(blip, true)
            ShowFriendIndicatorOnBlip(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("~b~Véhicule de service.")
            EndTextCommandSetBlipName(blip)
            couleurVehicule(veh)
            exports["esx_legacyfuel"]:SetFuel(veh, 100)
            

            ESX.ShowAdvancedNotification("Centrale", "~b~Garage LSPD", "Votre véhicule de service est en train d'etre sortie.", "CHAR_CALL911", 8)
            if name == "1200RT" then
                ModifyVehicleTopSpeed(voiture, 25*130.0)
                ModifyVehicleTopSpeed(veh, 25*130.0)
            end
            SetVehicleDirtLevel(voiture, 0.1)
            WashDecalsFromVehicle(voiture, 1.0)
        end)
    end
    _menuPool3:CloseAllMenus()
    RenderScriptCams(0, 1, 1500, 1, 1)
    DestroyCam(camera, true)
end


local count = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        while ESX == nil do
            Citizen.Wait(10)
        end
        _menuPool3:ProcessMenus()
        if count == 0 then
            menuVeh(NatveVehMenu)
            count = 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if not _menuPool3:IsAnyMenuOpen() and open == 1 then
            RenderScriptCams(0, 1, 1500, 1, 1)
            DestroyCam(camera, true)
            DeleteEntity(previewVeh)
            open = 0
        end
        Wait(400)
    end
end)


_menuPool3:RefreshIndex()
_menuPool3:MouseControlsEnabled (false);
_menuPool3:MouseEdgeEnabled (false);
_menuPool3:ControlDisablingEnabled(false);

function OpenVehicleSpawnerMenu(station)

    open = 1
    NatveVehMenu:Visible(not NatveVehMenu:Visible())


    DeleteEntity(previewVeh)
    if not HasModelLoaded(GetHashKey("police")) then
        RequestModel(GetHashKey("police"))
        while not HasModelLoaded(GetHashKey("police")) do
            Wait(10)
        end
    end 
    previewVeh = CreateVehicle(GetHashKey("police"), previewCoords.coords, heading, false, 0)
    PointCamAtEntity(camera, previewVeh, 0, 0, 0, 1)
    SetVehicleMaxMods(previewVeh)
    couleurVehicule(previewVeh)
    SetVehicleOnGroundProperly(previewVeh)
    FreezeEntityPosition(previewVeh, true)
    SetEntityCollision(previewVeh, false, false)

    local veh = ESX.Game.GetClosestVehicle(cameraCoords.coords)

    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(camera, cameraCoords.coords)
    PointCamAtEntity(camera, veh, 0, 0, 0, 1)
    SetCamNearDof(camera, 10)
    RenderScriptCams(1, 1, 2000, 1, 1)
    SetCamShakeAmplitude(camera, 13.0)
end