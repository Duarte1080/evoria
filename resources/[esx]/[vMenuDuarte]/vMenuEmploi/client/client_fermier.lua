--||@SuperCoolDuarte.||--

--------------------------||MES VARIABLES||---------------------------
ESX = nil
local PlayerData = {}
nbblejob = 0
nbpainjob = 0
inrecoltfarm = false
intraitosfarm = false
inreventefarm = false
onJobFermier = 0
local MyVeh = nil
local MyVeh2 = nil
local MyVeh3 = nil
local recolteveh = 0
local traitosveh = 0
lastvehfarm = nil
local inService = false
local isCarOut = false
local vacheFollow = false


local CurrentActionMsgEquiper        = '~INPUT_CONTEXT~ pour vous ~b~équiper~w~.'
local CurrentActionMsgControllerEquiper = '~INPUT_CELLPHONE_RIGHT~ pour vous ~b~équiper~w~.'
local CurrentActionMsgTracteur        = '~INPUT_CONTEXT~ pour ~g~sortir ~w~votre ~b~Tracteur~w~.'
local CurrentActionMsgControllerTracteur = '~INPUT_CELLPHONE_RIGHT~ pour ~g~sortir ~w~votre ~b~Tracteur~w~.'
local CurrentActionMsgRangerTracteur        = '~INPUT_CONTEXT~ pour ~r~ranger ~w~votre ~b~Tracteur~w~.'
local CurrentActionMsgControllerRangerTracteur = '~INPUT_CELLPHONE_RIGHT~ pour ~r~ranger ~w~votre ~b~Tracteur~w~.'
local CurrentActionMsgNourrirVaches      = '~INPUT_CONTEXT~  pour nourrir vos vaches.'
local CurrentActionMsgControllerNourrirVaches = '~INPUT_CELLPHONE_RIGHT~  pour nourrir vos vaches.'
local CurrentActionMsgStopNourrirVaches      = '~INPUT_CONTEXT~  pour ~r~arrêter~w~ de nourrir vos vaches.'
local CurrentActionMsgControllerStopNourrirVaches = '~INPUT_CELLPHONE_RIGHT~  pour ~r~arrêter~w~ de nourrir vos vaches.'
local CurrentActionMsgRecolter        = '~INPUT_CONTEXT~ pour récolter.'
local CurrentActionMsgControllerRecolter = '~INPUT_CELLPHONE_RIGHT~ pour récolter.'
local CurrentActionMsgStopRecolter        = '~INPUT_CONTEXT~ pour ~r~arrêter~w~ la récolte.'
local CurrentActionMsgControllerStopRecolter  = '~INPUT_CELLPHONE_RIGHT~ pour ~r~arrêter~w~ la récolte.'
local CurrentActionMsgCallVaches = '~INPUT_CONTEXT~ pour ~b~appelez~w~ les vaches.'
local CurrentActionMsgControllerCallVaches = '~INPUT_CELLPHONE_RIGHT~ pour ~b~appelez~w~ les vaches.'


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

function myNotification(title, subject, msg)

	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
  
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
  
	UnregisterPedheadshot(mugshot)
end

--------------------------------||MES FUNCTION||---------------------------
function deleteCar( entity )
	SetEntityAsMissionEntity(entity,true,true)
	Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
end

function HelpText(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
  end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function IsJobTrue()
  if PlayerData ~= nil then
      local IsJobTrue = false
      if PlayerData.job ~= nil and PlayerData.job.name == 'fermier' then
          IsJobTrue = true
      end
      return IsJobTrue
  end
end

--------------------------------||MES EVENT||---------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


RegisterNetEvent('vMenu:TextInventoryFull')
AddEventHandler('vMenu:TextInventoryFull', function()
	DrawMissionTextFermier("~h~~r~Inventaire Complet", 10000)
	changeEtape()
end)

RegisterNetEvent('vMenu:noSell')
AddEventHandler('vMenu:noSell', function()
	DrawMissionTextFermier("~h~~r~Vous n'avez plus rien à donner aux vaches", 10000)
end)

RegisterNetEvent('vMenu:Selling')
AddEventHandler('vMenu:Selling', function()
	local playerPed = PlayerPedId()
	local grabAni = "mp_common"
	RequestAnimDict(grabAni)
	while not HasAnimDictLoaded(grabAni) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(playerPed, grabAni, "givetake1_a", 8.0, 8.0, -1, 50, 0, false, false, false)
	Citizen.Wait(2500)
	ClearPedTasks(playerPed)

	PlaySoundFrontend(-1, 'Goon_Paid_Small', 'GTAO_Boss_Goons_FM_Soundset', false)
	DrawMissionTextFermier("~h~Vous avez reçu: + ~g~ 2$", 2500) --A CHANGER LE PRIX
end)

--------------------------------||FERMIER FUNCTION||---------------------------
local Fermier = {
	opened = false,
	title = "Fermier",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 155, g = 155, b = 255, a = 200, type = 25 },
}

local Fermier_locations = {
	{enteringFermier = {2243.444,5154.241,56.88712}, innutile4 = {474.3488,-1951.734,23.63132}, outsideFermier = {2234.762,5160.827,57.96405}},
}

local Fermier_blips ={}
local inrangeofFermier = false
local inrangeofFermier3 = false
local inrangeofFermier4 = false
local currentlocation = nil
local boughtcar = false

local function LocalPed()
return GetPlayerPed(-1)
end

function drawTxtFermier(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

function IsPlayerInRangeOfFermier()
return inrangeofFermier
end

function IsPlayerInRangeOfFermier3()
return inrangeofFermier3
end

function IsPlayerInRangeOfFermier4()
return inrangeofFermier4
end

function ShowFermierBlips(bool)
	if bool and #Fermier_blips == 0 then
		for station,pos in pairs(Fermier_locations) do
			local loc = pos
			pos = pos.outsideFermier
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			SetBlipSprite(blip,88)
			SetBlipColour(blip, 17)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Fermes')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(Fermier_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #Fermier_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				local inrange4 = false
				for i,b in ipairs(Fermier_blips) do
					if IsJobTrue() and Fermier.opened == false and  GetDistanceBetweenCoords(b.pos.enteringFermier[1],b.pos.enteringFermier[2],b.pos.enteringFermier[3],GetEntityCoords(LocalPed()),true) > 0 then
						DrawMarker(0,b.pos.enteringFermier[1],b.pos.enteringFermier[2],b.pos.enteringFermier[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						currentlocation = b
						if GetDistanceBetweenCoords(b.pos.enteringFermier[1],b.pos.enteringFermier[2],b.pos.enteringFermier[3],GetEntityCoords(LocalPed()),true) < 3 then
							inrange = true
							if GetLastInputMethod(0) then
								ShowInfoJobFermier(CurrentActionMsgEquiper)
							else
								ShowInfoJobFermier(CurrentActionMsgControllerEquiper)
							end					
						end
					end
					if inService == true and IsJobTrue() and Fermier.opened == false and  GetDistanceBetweenCoords(b.pos.enteringFermier[1],b.pos.enteringFermier[2],b.pos.enteringFermier[3],GetEntityCoords(LocalPed()),true) > 0 then
						DrawMarker(0,2237.99,5166.377,58.96447,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						currentlocation = b
						if GetDistanceBetweenCoords(2237.99,5166.377,58.96447,GetEntityCoords(LocalPed()),true) < 5 then
							inrange4 = true
							if isCarOut == false then
								if GetLastInputMethod(0) then
									ShowInfoJobFermier(CurrentActionMsgTracteur)
								else
									ShowInfoJobFermier(CurrentActionMsgControllerTracteur)
								end
							else
								if GetLastInputMethod(0) then
									ShowInfoJobFermier(CurrentActionMsgRangerTracteur)
								else
									ShowInfoJobFermier(CurrentActionMsgControllerRangerTracteur)
								end
							end
						end
					end
				end
				inrangeofFermier = inrange
				inrangeofFermier4 = inrange4
			end
		end)
	elseif bool == false and #Fermier_blips > 0 then
		for i,b in ipairs(Fermier_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		Fermier_blips = {}
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and inrangeofFermier then
			toogleService()
        end
    end
end)

function toogleService()
	inService = not inService
	if inService then
		SetPedPropIndex(GetPlayerPed(-1), 0, 64, 3, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
		SetPedComponentVariation(GetPlayerPed(-1), 4, 39, 1, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 6, 39, 0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(GetPlayerPed(-1), 11, 66, 1, 2)

		inrangeofFermier = false
		inrange = false
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and inrangeofFermier4 then
        if recolteveh == 0 and isCarOut == false then
			local carid = GetHashKey("tractor2")
			local playerPed = GetPlayerPed(-1)
			if playerPed and playerPed ~= -1 then
            RequestModel(carid)
            while not HasModelLoaded(carid) do
                Citizen.Wait(0)
            end
			
			if(lastvehfarm2 ~= nil)then				
				deleteCar(lastvehfarm2)
			end
			if(lastvehfarm ~= nil)then				
				deleteCar(lastvehfarm)
			end
			if(MyVeh2 ~= nil)then				
				deleteCar(MyVeh2)
			end
			if(MyVeh3 ~= nil)then				
				deleteCar(MyVeh3)
			end
			
			local playerCoords = GetEntityCoords(playerPed)
            playerCoords = playerCoords + vector3(0, 2, 0)
			
            lastvehfarm = CreateVehicle(carid, 2239.606,5181.026,60.23108, 0.0, true, false)
			
			end
			myNotification("Fermier", "", "Vous avez sortie votre ~b~Tracteur~w~.")
			
			inrangeofFermier4 = false
			inrange4 = false
			recolteveh = 1
			isCarOut = true
		else
			deleteCar(lastvehfarm2)
			deleteCar(lastvehfarm)
			isCarOut = false
		end
		if recolteveh == 1 then
			
			local carid = GetHashKey("GrainTrailer")
			local playerPed = GetPlayerPed(-1)
			if playerPed and playerPed ~= -1 then
            RequestModel(carid)
            while not HasModelLoaded(carid) do
                Citizen.Wait(0)
            end
			
			local playerCoords = GetEntityCoords(playerPed)
            playerCoords = playerCoords + vector3(0, 2, 0)
			
            remorquespawn = CreateVehicle(carid, 2232.481,5172.816,59.26372, 0.0, true, false)
			MyVeh2 = remorquespawn
			
			end
			
			myNotification("Fermier", "", "Vous avez sortie votre ~b~remorque~w~.")
			recolteveh = 0
		end
        end
    end
end)

function StartJobFermier(jobid)

		if jobid == 1 then -- Fermier Camion
			showLoadingPromtFermier("~g~Chargement des coordonnées ~y~GPS ~w~.", 2000, 3)
			MyVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
			onJobFermier = 1
		end

		if jobid == 2 and inService == true then -- Fermier Tracteur
			showLoadingPromtFermier("~g~Chargement des coordonnées ~y~GPS ~w~.", 2000, 3)
			MyVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
			onJobFermier = 3
			MyVeh22 = remorquespawn		
		end
end

function DrawMissionTextFermier(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function showLoadingPromtFermier(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Citizen.Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end

function ShowInfoJobFermier(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function DrawMissionTextBrasseur(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end


function StopJobFermier(jobid)
	if jobid == 1 then
		if FermierTraitos ~= nil and DoesBlipExist(FermierTraitos) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(FermierTraitos))
			FermierTraitos = nil
		end
		if FermierRevente ~= nil and DoesBlipExist(FermierRevente) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(FermierRevente))
			FermierRevente = nil
		end
		onJobFermier = 0
		intraitosfarm = false
		inreventefarm = false
		MyVeh = nil
		MyVeh33 = nil
	end
	if jobid == 2 then
		if FermierChamps ~= nil and DoesBlipExist(FermierChamps) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(FermierChamps))
			FermierChamps = nil
		end
		onJobFermier = 0
		inrecoltfarm = false
		MyVeh = nil
		MyVeh22 = nil
	end
end

function changeEtape()
	DrawMissionTextFermier("~h~Allez nourrir vos ~y~vaches ~w~ pour terminer votre ~g~journée ~w~.", 10000)
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
		----------------------------||Detecte la distance entre le joueur et le point finale||-----------------------------------
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2380.98,5052.58,46.4446, true) > 20.0001 then
			DrawMarker(25, 2380.98,5052.58,46.4446-1.1001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			inrangeofreventefarm = false
		else
			inrangeofreventefarm = true
				if vacheFollow == false then
					if GetLastInputMethod(0) then
						ShowInfoJobFermier(CurrentActionMsgCallVaches)
					else
						ShowInfoJobFermier(CurrentActionMsgControllerCallVaches)
					end	
				else
					if (inreventefarm == false) then
						if GetLastInputMethod(0) then
							ShowInfoJobFermier(CurrentActionMsgNourrirVaches)
						else
							ShowInfoJobFermier(CurrentActionMsgControllerNourrirVaches)
						end	
					end
				if (inreventefarm == true) then
					if GetLastInputMethod(0) then
						ShowInfoJobFermier(CurrentActionMsgStopNourrirVaches)
					else
						ShowInfoJobFermier(CurrentActionMsgControllerStopNourrirVaches)
					end	
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if onJobFermier == 0 then
			if IsJobTrue() then -- JOB Fermier
				if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
					if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("tractor2", _r)) and inService == true then
						StartJobFermier(2)
					end
				end
			end
        elseif onJobFermier == 3 and inService == true then
					FermierChamps = AddBlipForCoord(2011.6,4895.89,42.8089)
					SetBlipSprite(FermierChamps,416)		
			        SetBlipColour(FermierChamps, 1)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("CHAMP D'HERBE POUR VACHES")
					EndTextCommandSetBlipName(FermierChamps)

									----------------------------||AFFICHE LE BLIP POUR DONNER A MANGER AU VACHES||-----------------------------------
					FermierRevente = AddBlipForCoord(2380.98,5052.58,46.4446)
					SetBlipSprite(FermierRevente,416)
					SetBlipColour(FermierRevente, 3)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString('Vacherie')
					EndTextCommandSetBlipName(FermierRevente)
					
					onJobFermier = 4
		elseif onJobFermier == 4 and inService == true then
			if DoesEntityExist(MyVeh) and IsVehicleDriveable(MyVeh, 0) then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2011.6,4895.89,42.8089, true) > 40.0001 then
						DrawMarker(25, 2011.6,4895.89,42.8089-1.1001, 0, 0, 0, 0, 0, 0, 40.0, 40.0, 3.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
					    inrangeofchampsFermier = false
					else
						inrangeofchampsFermier = true
						if (inrecoltfarm == false) then

							if GetLastInputMethod(0) then
								ShowInfoJobFermier(CurrentActionMsgRecolter)
							else
								ShowInfoJobFermier(CurrentActionMsgControllerRecolter)
							end	
						end
						if (inrecoltfarm == true) then
							if GetLastInputMethod(0) then
								ShowInfoJobFermier(CurrentActionMsgStopRecolter)
							else
								ShowInfoJobFermier(CurrentActionMsgControllerStopRecolter)
							end	
						end
					end
					
				    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(MyVeh22), true) > 30.0001 then
						StopJobFermier(2)
					end					
			else
				StopJobFermier(2)
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (inrecoltfarm == true) then
			if (inrangeofchampsFermier == true) then
				DrawMissionTextFermier("~h~~b~Récolte~w~ en cours...", 3000)
				Wait(2500)
				TriggerServerEvent('fermier:GiveOne')
			else
				inrecoltfarm = false
			end
		end

		if (inreventefarm == true) then
			if (inrangeofreventefarm == true) then
				TriggerServerEvent('fermier:SellOne')
				Wait(3000)
			else
				inreventefarm = false
			end
		end
	end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        if IsJobTrue() and (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (inrangeofchampsFermier == true) and (inrecoltfarm == false) then
		   inrecoltfarm = true
        elseif IsJobTrue() and (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
		   inrecoltfarm = false
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsJobTrue() then
          ShowFermierBlips(true)
        else
          ShowFermierBlips(false)
		end
	
		if IsJobTrue() and (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (inrangeofreventefarm == true) and (inreventefarm == false) then
		   if IsPedInAnyVehicle(LocalPed(), true) == false then
			callVachest()
		   inreventefarm = true
		   else
		       DrawMissionTextBrasseur("~h~~r~Descendez de votre véhicule pour nourrir vos vaches.", 2000)
		   end
        elseif IsJobTrue() and (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and (inrangeofreventefarm == true) and (inreventefarm == true) then
		   inreventefarm = false
        end
    end
end)

function callVachest()
	for i=1, #Config.Locations do
        local mesVaches = Config.Locations[i]["mesVaches"]
        if DoesEntityExist(mesVaches["entity"]) then
			TaskGoToEntity(mesVaches["entity"], GetPlayerPed(-1), -1, 1.0, 10.0, 1073741824.0, 0)
        end
	end
	local playerPed = PlayerPedId()
	local grabAni = "rcmnigel1c"
	RequestAnimDict(grabAni)
	while not HasAnimDictLoaded(grabAni) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(playerPed, grabAni, "hailing_whistle_waive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
	Citizen.Wait(2500)
	ClearPedTasks(playerPed)
	Wait(1000)
	vacheFollow = true
end



_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end
Citizen.CreateThread(function()
    local defaultHash = -50684386
    for i=1, #Config.Locations do
        local mesVaches = Config.Locations[i]["mesVaches"]
        if mesVaches then
            mesVaches["hash"] = mesVaches["hash"] or defaultHash
            _RequestModel(mesVaches["hash"])
            if not DoesEntityExist(mesVaches["entity"]) then
                mesVaches["entity"] = CreatePed(4, mesVaches["hash"], mesVaches["x"], mesVaches["y"], mesVaches["z"], mesVaches["h"], true, true)
                SetEntityAsMissionEntity(mesVaches["entity"])
                SetBlockingOfNonTemporaryEvents(mesVaches["entity"], true)
                FreezeEntityPosition(mesVaches["entity"], false)
				SetEntityInvincible(mesVaches["entity"], true)
				SetPedDiesWhenInjured(mesVaches["entity"], false)
				SetPedCanPlayAmbientAnims(mesVaches["entity"], true)
				SetPedCanRagdollFromPlayerImpact(mesVaches["entity"], false)
            end
            SetModelAsNoLongerNeeded(mesVaches["hash"])
        end
    end
end)

DeleteMyVaches = function()
    for i=1, #Config.Locations do
        local mesVaches = Config.Locations[i]["mesVaches"]
        if DoesEntityExist(mesVaches["entity"]) then
            DeletePed(mesVaches["entity"])
            SetPedAsNoLongerNeeded(mesVaches["entity"])
        end
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteMyVaches()
    end
end)