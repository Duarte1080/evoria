local all_weapons = {
	{name = "WEAPON_Knife", pname = "Couteau"},
	{name = "WEAPON_HAMMER", pname = "Marteau"},
	{name = "WEAPON_Bat", pname = "Batte"},
	{name = "WEAPON_Bottle", pname = "Bouteille"},
	{name = "WEAPON_Dagger", pname = "Poignard"},
	{name = "WEAPON_Hatchet", pname = "Hachette"},
	{name = "WEAPON_KNUCKLE", pname = "Poing Américain"},
	{name = "WEAPON_Machete", pname = "Machette"},
	{name = "WEAPON_Flashlight", pname = "Lampe de poche"},
	{name = "WEAPON_Pistol", pname = "Pistolet"},
	{name = "WEAPON_CombatPistol", pname = "Pistolet de Combat"},
	{name = "WEAPON_PISTOL50", pname = "Pistolet .50"},
	{name = "WEAPON_HeavyPistol", pname = "Pistolet Lourd"},
	{name = "WEAPON_VintagePistol", pname = "Pistolet Vintage"},
	{name = "WEAPON_APPistol", pname = "Pistolet perforant"},
	{name = "WEAPON_FlareGun", pname = "Pistolet de détresse"},
	{name = "WEAPON_MicroSMG", pname = "Uzi"},
	{name = "WEAPON_MachinePistol", pname = "TEC-9"},
	{name = "WEAPON_SMG", pname = "MP5A3"},
	{name = "WEAPON_AssaultSMG", pname = "Magpul PDR"},
	{name = "WEAPON_CombatPDW", pname = "MPX"},
	{name = "WEAPON_Gusenberg", pname = "Gusenberg"},
	{name = "WEAPON_PumpShotgun", pname = "Fusil à Pompe"},
	{name = "WEAPON_SawnoffShotgun", pname = "Fusil à canon scié"},
	{name = "WEAPON_AssaultRifle", pname = "AK-47"},
	{name = "WEAPON_CarbineRifle", pname = "M4A4"},
	{name = "WEAPON_AdvancedRifle", pname = "TAR-21"},
	{name = "WEAPON_SpecialCarbine", pname = "G36C"},
	{name = "WEAPON_BullpupRifle", pname = "QBZ-95"},
	{name = "WEAPON_BZGas", pname = "Gas BZ"},
	{name = "WEAPON_Molotov", pname = "Molotov"},
	{name = "WEAPON_FireExtinguisher", pname = "Extincteur"},
	{name = "WEAPON_PetrolCan", pname = "Jerrican"},
	{name = "WEAPON_Flare", pname = "Flare"},
}

RegisterNetEvent("nPolice:Cfouille")
AddEventHandler("nPolice:Cfouille", function(NearestPlayerSID, THEITEMSFOUILLE)
	ITEMSFOUILLE = {}
    ITEMSFOUILLE = THEITEMSFOUILLE
	myNotification("Police: ", "", "Inventaire de " ..GetOwnerName(NearestPlayerSID) .. " : ")
	local count = 0
	for k, v in pairs(THEITEMSFOUILLE) do
		if v.count >= 1 then
			myNotification("Police: ", "", "" ..v.count .. " " ..v.label)
			count = count + v.count
		end
	end

	if count == 0 then
        myNotification("Police: ", "", "La personne n'a rien dans son inventaire")
	end
end)

local function GetPedWeapons(ped)
	weapons_list = ""
	weapons_count = 0
	for k,v in pairs(all_weapons) do
		local hash = GetHashKey(v.name)
		if HasPedGotWeapon(ped, hash, false) then
			if weapons_list == "" then
				weapons_list = v.pname
			else
				weapons_list = weapons_list .. ", " .. v.pname
			end
			weapons_count = weapons_count + 1
		end
	end
	if weapons_count == 0 then
		return "Aucune armes"
	else
		return "Armes : " .. weapons_list
	end
end

RegisterNetEvent('nMenuNotif:showNotification')
AddEventHandler('nMenuNotif:showNotification', function(msg)
	ShowNotification(msg)
end)

function ShowNotification(text)
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

RegisterNetEvent('nPolice:Cfouilleweapons')
AddEventHandler('nPolice:Cfouilleweapons', function(NearestPlayerSID)
	TriggerServerEvent("nPolice:sfouilleweapons", NearestPlayerSID, GetPedWeapons(GetPlayerPed(-1)))
end)

-----------------||MES THREAD||-----------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
			isCuffed = true
		elseif isCuffed then
			TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,268,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,271,true)
			SetPedCurrentWeaponVisible(GetPlayerPed(-1), false, true, false, false)
		end
	end
end)


--------||ANIMATIONS||--------
function playAnim(dict, name)
    local ped = GetPlayerPed(-1)
    loadanimdict(dict)
    TaskPlayAnim(ped, dict, name, 8.0, 1.0, -1, 2, 0, 0, 0, 0)
end

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

RegisterNetEvent('nPolice:Cgetarrested')
AddEventHandler('nPolice:Cgetarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	isCuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	SetPedComponentVariation(GetPlayerPed(-1), 7, 41, 0 ,0)
end)

RegisterNetEvent('nPolice:Cdoarrested')
AddEventHandler('nPolice:Cdoarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end)

RegisterNetEvent('nPolice:Cdouncuffing')
AddEventHandler('nPolice:Cdouncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('nPolice:Cgetuncuffed')
AddEventHandler('nPolice:Cgetuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z = table.unpack(playercoords + playerlocation)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0 ,0)
	Citizen.Wait(5500)
	isCuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)

function MenotterCivil()
    player, distance = GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(player)
    TriggerServerEvent('nPolice:MenotterServer', target_id, playerheading, playerCoords, playerlocation)
    myNotification("Police: ", "", "~h~Vous avez menotté une personne.")
end

function DemenotterCivil()
    player, distance = GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(player)
    TriggerServerEvent('nPolice:Srequestrelease', target_id, playerheading, playerCoords, playerlocation)
    myNotification("Police: ", "", "~h~Vous avez demenotter une personne.")
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetOwnerName(id)
    local playername = 0

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            if GetPlayerServerId(i) == id then
				playername = GetPlayerName(i)
			end
        end
    end
    return playername
end