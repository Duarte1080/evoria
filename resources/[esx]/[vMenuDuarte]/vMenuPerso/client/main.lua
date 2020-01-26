--||@SuperCoolNinja.& Duarte||--

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

function notification(title, subject, msg)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
	UnregisterPedheadshot(mugshot)
end

_menuPool = nil
local personalmenu = {}
local invItem, wepItem, billItem, mainMenu, itemMenu, weaponItemMenu = {}, {}, {}, nil, nil, nil
local isDead, inAnim = false, false
local playerGroup, noclip, godmode, visible = nil, false, false, false
local societymoney, societymoney2 = nil, nil
local wepList = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

		while ESX.GetPlayerData().faction == nil do
			Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while playerGroup == nil do
		ESX.TriggerServerCallback('vMenuDuarte:Admin_getUsergroup', function(group) playerGroup = group end)
		Citizen.Wait(10)
	end

	RefreshMoney()

	RefreshMoney2()

	wepList = ESX.GetWeaponList()

	_menuPool = NativeUI.CreatePool()

	mainMenu = NativeUI.CreateMenu("Menu Personnel", "~b~MENU INTERACTION")
	itemMenu = NativeUI.CreateMenu("Menu Personnel", "Inventaire: Action")
	weaponItemMenu = NativeUI.CreateMenu("Menu Personnel", "Armes: Action")
	_menuPool:Add(mainMenu)
	_menuPool:Add(itemMenu)
	_menuPool:Add(weaponItemMenu)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	_menuPool:CloseAllMenus()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

--AddEventHandler('esx_ambulancejob:multicharacter', function()
--	isDead = false
--end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setfaction')
AddEventHandler('esx:setfaction', function(faction)
	ESX.PlayerData.faction = faction
	RefreshMoney2()
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSociety2Money(money)
		end, ESX.PlayerData.faction.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' and 'society_' .. ESX.PlayerData.faction.name == society then
		UpdateSociety2Money(money)
	end
end)

function UpdateSocietyMoney(money)
	societymoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	societymoney2 = ESX.Math.GroupDigits(money)
end

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function myNotification(title, subject, msg)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
	UnregisterPedheadshot(mugshot)
end

function ShowNotif(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

-- Weapon Menu --
RegisterNetEvent("vMenuDuarte:Weapon_addAmmoToPedC")
AddEventHandler("vMenuDuarte:Weapon_addAmmoToPedC", function(value, quantity)
	local weaponHash = GetHashKey(value)
	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

-- Admin Menu --
RegisterNetEvent('vMenuDuarte:Admin_BringC')
AddEventHandler('vMenuDuarte:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", 'ID du Joueur (8 Caractères Maximum):', "", 8)
	if plyId ~= nil then
		plyId = tonumber(plyId)
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", 'ID du Joueur (8 Caractères Maximum):', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('vMenuDuarte:Admin_BringS', plyId, plyPedCoords)
		end
	end
end
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput("KORIOZ_BOX_XYZ", 'Position XYZ (50 Caractères Maximum):', "", 50)
	if pos ~= nil and pos ~= '' then
		local _, _, x, y, z = string.find(pos, "([%d%.]+) ([%d%.]+) ([%d%.]+)")
		if x ~= nil and y ~= nil and z ~= nil then
			SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
		end
	end
end
-- FIN TP A POSITION

-- FONCTION NOCLIP 
function admin_no_clip()
	noclip = not noclip
	if noclip then
		SetEntityInvincible(plyPed, true)
		SetEntityVisible(plyPed, false, false)
		notification("NoClip", "Administration", "NoClip ~g~Activé")
	else
		SetEntityInvincible(plyPed, false)
		SetEntityVisible(plyPed, true, false)
		notification("NoClip", "Administration", "NoClip ~r~Désactivé")
	end
end

function getPosition()
	local x, y, z = table.unpack(GetEntityCoords(plyPed, true))
	return x, y, z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local x = -math.sin(heading * math.pi/180.0)
	local y = math.cos(heading * math.pi/180.0)
	local z = math.sin(pitch * math.pi/180.0)

	local len = math.sqrt(x * x + y * y + z * z)

	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x, y, z
end

function isNoclip()
	return noclip
end
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		notification("GodMode", "Administration", "GodMode ~g~Activé")
	else
		SetEntityInvincible(plyPed, false)
		notification("GodMode", "Administration", "GodMode ~r~Désactivé")
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		notification("Invisible", "Administration", "Mode Fantôme ~g~Activé")
	else
		SetEntityVisible(plyPed, true, false)
		notification("Invisible", "Administration", "Mode Fantôme ~r~Désactivé")
	end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KORIOZ_BOX_VEHICLE_NAME",'Nom du Véhicule (50 Caractères Maximum):', "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords['x'], plyCoords['y'], plyCoords['z'], 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)

	notification("Flip Véhicule", "Administration", "Retournement du véhicule ~g~effectué")
end
-- FIN flipVehicle

-- Afficher Coord
function modo_showcoord()
	showcoord = not showcoord
end
-- FIN Afficher Coord

-- Afficher Nom
function modo_showname()
	showname = not showname
end
-- FIN Afficher Nom

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end
			Citizen.Wait(0)
		end
		notification("Téléportation", "Administration", "Téléportation ~g~Effectuée")
	else
		notification("Téléportation", "Administration", "Aucun ~r~Marqueur")
	end
end
-- FIN TP MARKER

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", 'ID', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esx_ambulancejob:revive', plyId)
		end
	end
end
-- FIN HEAL JOUEUR

function startAttitude(lib, anim)
	Citizen.CreateThread(function()
		RequestAnimSet(anim)

		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(0)
		end

		SetPedMotionBlur(plyPed, false) 
		SetPedMovementClipset(plyPed, anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(plyPed, anim, 0, false)
end

function AddMenuInventoryMenu(menu)
	inventorymenu = _menuPool:AddSubMenu(menu, 'Votre ~p~Inventaire')
	local invCount = {}

	for i=1, #ESX.PlayerData.inventory, 1 do
		local count = ESX.PlayerData.inventory[i].count

		if count > 0 then
			local label = ESX.PlayerData.inventory[i].label
			local value = ESX.PlayerData.inventory[i].name

			invCount = {}

			for i = 1, count, 1 do
				table.insert(invCount, i)
			end
			
			table.insert(invItem, value)

			invItem[value] = NativeUI.CreateListItem(label .. " (" .. count .. ")", invCount, 1)
			inventorymenu.SubMenu:AddItem(invItem[value])
		end
	end

	local useItem = NativeUI.CreateItem('Utiliser', "")
	itemMenu:AddItem(useItem)

	local giveItem = NativeUI.CreateItem('Donner', "")
	itemMenu:AddItem(giveItem)

	local dropItem = NativeUI.CreateItem('Jeter', "")
	dropItem:SetRightBadge(4)
	itemMenu:AddItem(dropItem)

	inventorymenu.SubMenu.OnListSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		itemMenu:Visible(true)

		for i = 1, #ESX.PlayerData.inventory, 1 do
			local label	    = ESX.PlayerData.inventory[i].label
			local count	    = ESX.PlayerData.inventory[i].count
			local value	    = ESX.PlayerData.inventory[i].name
			local usable	= ESX.PlayerData.inventory[i].usable
			local canRemove = ESX.PlayerData.inventory[i].canRemove
			local quantity  = index

			if item == invItem[value] then
				itemMenu.OnItemSelect = function(sender, item, index)
					if item == useItem then
						if usable then
							TriggerServerEvent('esx:useItem', value)
						else
							notification("Inventaire", "Notification", 'n\'est pas utilisable', label)
						end
						_menuPool:CloseAllMenus(false)
	 	                itemMenu:Visible(false)
					elseif item == giveItem then
						local foundPlayers = false
						personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

						if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
			 				foundPlayers = true
						end

						if foundPlayers == true then
							local closestPed = GetPlayerPed(personalmenu.closestPlayer)

							if not IsPedSittingInAnyVehicle(closestPed) then
								if quantity ~= nil and count > 0 then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									notification("Inventaire", "Notification", 'Montant Invalide')
								end
							else
								notification("Inventaire", "Notification", 'Impossible de donner dans un véhicule', label)
							end
						else
							notification("Inventaire", "Notification", 'Aucun joueur à proximité')
						end
					elseif item == dropItem then
						if canRemove then
							if not IsPedSittingInAnyVehicle(plyPed) then
								if quantity ~= nil then
									TriggerServerEvent('esx:removeInventoryItem', 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									notification("Inventaire", "Notification", 'Montant Invalide')
								end
							else
								notification("Téléportation", "Notification", 'Impossible de jeter dans un véhicule !', label)
							end
						else
							notification("Téléportation", "Notification", 'n\'est pas jetable', label)
						end
					end
				end
			end
		end
	end
end

function AddMenuWeaponMenu(menu)
	weaponMenu = _menuPool:AddSubMenu(menu, 'Vos ~t~Armes')
	for i = 1, #wepList, 1 do
		local weaponHash = GetHashKey(wepList[i].name)

		if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
			local ammo 		= GetAmmoInPedWeapon(plyPed, weaponHash)
			local label	    = wepList[i].label .. ' [' .. ammo .. ']'
			local value	    = wepList[i].name

			wepItem[value] = NativeUI.CreateItem(label, "")
			weaponMenu.SubMenu:AddItem(wepItem[value])
		end
	end

	local giveItem = NativeUI.CreateItem('Donner', "")
	weaponItemMenu:AddItem(giveItem)

	local giveMunItem = NativeUI.CreateItem('Donner Munitions', "")
	weaponItemMenu:AddItem(giveMunItem)

	local dropItem = NativeUI.CreateItem('Jeter', "")
	dropItem:SetRightBadge(4)
	weaponItemMenu:AddItem(dropItem)

	weaponMenu.SubMenu.OnItemSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		weaponItemMenu:Visible(true)
		for i = 1, #wepList, 1 do
			local weaponHash = GetHashKey(wepList[i].name)
			if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
				local ammo 		= GetAmmoInPedWeapon(plyPed, weaponHash)
				local value	    = wepList[i].name
				local label	    = wepList[i].label

				if item == wepItem[value] then
					weaponItemMenu.OnItemSelect = function(sender, item, index)
						if item == giveItem then
							local foundPlayers = false
							personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

							if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 				foundPlayers = true
							end

							if foundPlayers == true then
								local closestPed = GetPlayerPed(personalmenu.closestPlayer)

								if not IsPedSittingInAnyVehicle(closestPed) then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_weapon', value, ammo)
									_menuPool:CloseAllMenus()
								else
									notification("Gestions Armes", "Notification", 'Impossible de donner dans un véhicule', label)
								end
							else
								notification("Gestions Armes", "Notification", 'Aucun joueur à proximité')
							end
						elseif item == giveMunItem then
							local quantity = KeyboardInput("KORIOZ_BOX_AMMO_AMOUNT", 'Montant Invalide', "", 8)

							if quantity ~= nil then
								local post = true
								quantity = tonumber(quantity)

								if type(quantity) == 'number' then
									quantity = ESX.Math.Round(quantity)

									if quantity <= 0 then
										post = false
									end
								end

								local foundPlayers = false
								personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

								if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 					foundPlayers = true
								end

								if foundPlayers == true then
									local closestPed = GetPlayerPed(personalmenu.closestPlayer)

									if not IsPedSittingInAnyVehicle(closestPed) then
										if ammo > 0 then
											if post == true then
												if quantity <= ammo and quantity >= 0 then
													local finalAmmo = math.floor(ammo - quantity)
													SetPedAmmo(plyPed, value, finalAmmo)
													TriggerServerEvent('vMenuDuarte:Weapon_addAmmoToPedS', GetPlayerServerId(personalmenu.closestPlayer), value, quantity)

													ESX.ShowNotification('Vous avez donné x%s munitions à %s', quantity, GetPlayerName(personalmenu.closestPlayer))
													_menuPool:CloseAllMenus()
												else
													notification("Gestions Armes", "Notification",'Vous ne possédez pas autant de munitions')
												end
											else
												notification("Gestions Armes", "Notification", 'Montant Invalide')
											end
										else
											notification("Gestions Armes", "Notification", 'Vous ne possédez pas autant de munitions')
										end
									else
										notification("Gestions Armes", "Notification", 'Impossible de donner dans un véhicule', label)
									end
								else
									notification("Gestions Armes", "Notification", 'Aucun joueur à proximité')
								end
							end
						elseif item == dropItem then
							if not IsPedSittingInAnyVehicle(plyPed) then
								TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', value)
								_menuPool:CloseAllMenus()
							else
								notification("Gestions Armes", "Notification", 'Aucun joueur à proximité', label)
							end
						end
					end
				end
			end
		end
	end
end

function AddMenuWalletMenu(menu)
	personalmenu.moneyOption = {
		'Donner',
		'Jeter'
	}

	walletmenu = _menuPool:AddSubMenu(menu, 'Votre ~r~Portefeuilles')

	local walletJob = NativeUI.CreateItem( 'Métier:~b~ ' ..ESX.PlayerData.job.label.. ' : ' ..ESX.PlayerData.job.grade_label.. "")
	walletmenu.SubMenu:AddItem(walletJob)

	local walletfaction = NativeUI.CreateItem('Organisation:~y~  ' ..ESX.PlayerData.faction.label.. ' : ' ..ESX.PlayerData.faction.grade_label, "")
		walletmenu.SubMenu:AddItem(walletfaction)

	local walletMoney = NativeUI.CreateListItem('Argent:~g~ ' ..ESX.Math.GroupDigits(ESX.PlayerData.money), personalmenu.moneyOption, 1)
	walletmenu.SubMenu:AddItem(walletMoney)

	local walletdirtyMoney = nil

    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
            walletdirtyMoney = NativeUI.CreateListItem("Argent Sale: " .. "~r~" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money), personalmenu.moneyOption, 1)
            walletmenu.SubMenu:AddItem(walletdirtyMoney)
        end
    end
	
	local montrerIdentite = nil
	local regarderIdentite = nil
		montrerIdentite = NativeUI.CreateItem('Montrer sa carte d\'identité', "")
		walletmenu.SubMenu:AddItem(montrerIdentite)

		regarderIdentite = NativeUI.CreateItem('Regarder sa carte d\'identité', "")
		walletmenu.SubMenu:AddItem(regarderIdentite)
       
		simcard = NativeUI.CreateItem("Voir ma carte sim", "")
        walletmenu.SubMenu:AddItem(simcard)

	walletmenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == montrerIdentite then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
				else
					notification("Portefeuilles", "Notification", 'Aucun joueur à proximité')
				end
			elseif item == regarderIdentite then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			elseif item == simcard then
                exports["gcphone"]:OpenMenu()
                _menuPool:CloseAllMenus()
			end

	end

	walletmenu.SubMenu.OnListSelect = function(sender, item, index)
		if index == 1 then
            _menuPool:CloseAllMenus()
            local quantity = KeyboardInput("Montant", "Montant (8 Caractères Maximum):", "", 8)

            if quantity ~= nil then
                local post = true
                quantity = tonumber(quantity)

                if type(quantity) == 'number' then
                    quantity = ESX.Math.Round(quantity)

                    if quantity <= 0 then
                        post = false
                    end
                end

                local foundPlayers = false
                personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

                if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
                    foundPlayers = true
                end

                if foundPlayers == true then
                    local closestPed = GetPlayerPed(personalmenu.closestPlayer)

                    if not IsPedSittingInAnyVehicle(closestPed) then
                        if post == true then
                            if item == walletMoney then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_money', 'money', quantity)
                                _menuPool:CloseAllMenus()
                            elseif item == walletdirtyMoney then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_account', 'black_money', quantity)
                                _menuPool:CloseAllMenus()
                            end
                        else
                            myNotification("Argent", "", "~r~Montant Invalide !")
                        end
                    else
                        if item == walletMoney then
                            myNotification("Argent", "", "")
                        elseif item == walletdirtyMoney then
                            myNotification("Argent", "", "Impossible de donner dans un véhicule")
                        end
                    end
                else
                    myNotification("", "", "Aucun joueur à proximité")
                end
            end
        elseif index == 2 then
             _menuPool:CloseAllMenus()
            local quantity = KeyboardInput("Montant", "Montant (8 Caractères Maximum):", "", 8)

            if quantity ~= nil then
                local post = true
                quantity = tonumber(quantity)

                if type(quantity) == 'number' then
                    quantity = ESX.Math.Round(quantity)

                    if quantity <= 0 then
                        post = false
                    end
                end

                if not IsPedSittingInAnyVehicle(plyPed) then
                    if post == true then
                        if item == walletMoney then
                            local dropAni = "anim@move_m@trash"
                            RequestAnimDict(dropAni)
                            while not HasAnimDictLoaded(dropAni) do
                                Citizen.Wait(100)
                            end
                            --DuarteV.showProgressBarTimer(900, "Patientez ...")
                            TaskPlayAnim(PlayerPedId(), dropAni, "pickup", 8.0, 8.0, -1, 50, 0, false, false, false)
                            Citizen.Wait(900)
                            ClearPedTasks(PlayerPedId())
                            PlaySoundFrontend(-1, 'Object_Collect_Player', 'GTAO_FM_Events_Soundset', false)
                            TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'money', quantity)
                            _menuPool:CloseAllMenus()
                        elseif item == walletdirtyMoney then
                            local dropAni = "anim@move_m@trash"
                            RequestAnimDict(dropAni)
                            while not HasAnimDictLoaded(dropAni) do
                                Citizen.Wait(100)
                            end
                            --DuarteV.showProgressBarTimer(900, "Patientez ...")
                            TaskPlayAnim(PlayerPedId(), dropAni, "pickup", 8.0, 8.0, -1, 50, 0, false, false, false)
                            Citizen.Wait(900)
                            ClearPedTasks(PlayerPedId())
                            PlaySoundFrontend(-1, 'Object_Collect_Player', 'GTAO_FM_Events_Soundset', false)
                            TriggerServerEvent('esx:removeInventoryItem', 'item_account', 'black_money', quantity)
                            _menuPool:CloseAllMenus()
                        end
                    else
                        myNotification("Argent", "", "Montant Invalide")
                    end
                else
                    if item == walletMoney then
                        myNotification("Argent", "", "Impossible de jeter dans un véhicule")
                    elseif item == walletdirtyMoney then
                        myNotification("Argent", "", "Impossible de jeter dans un véhicule")
                    end
                end
            end
        end
    end
end



function AddMenuCleMenu(menu)
	cleMenu = _menuPool:AddSubMenu(menu, 'Vos ~q~Clés')

	local cleItem = NativeUI.CreateItem('Gestion des clés', "")
	cleMenu.SubMenu:AddItem(cleItem)

	cleMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == cleItem then
			TriggerEvent("esx_menu:key")
			_menuPool:CloseAllMenus()
		end
	end
end

-- Hide/Show HUD
local interface = false
local source = true

function openInterface()
	interface = not interface
	if not interface then -- hide
  		TriggerEvent('ui:toggle', source,false)
	elseif interface then -- show
	  	TriggerEvent('ui:toggle', source,true)
	end
  end

  local ragdoll = false
  function setRagdoll(flag)
	ragdoll = flag
  end
  Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if ragdoll then
		SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
	  end
	end
  end)
  
  ragdol = true
  RegisterNetEvent("Ragdoll")
  AddEventHandler("Ragdoll", function()
	  if ( ragdol ) then
		  setRagdoll(true)
		  ragdol = false
	  else
		  setRagdoll(false)
		  ragdol = true
	  end
  end)

  function Ragdoll()
	TriggerEvent("Ragdoll", source)
end



function AddMenuDiversMenu(menu)
	DiversMenu = _menuPool:AddSubMenu(menu, 'Votre ~r~HUD')
	
	local Description = "Afficher ou Cacher l'HUD"
	local Description1 = "Dormir ou Se Réveiller"
	
    local hudItem = NativeUI.CreateCheckboxItem("Afficher | Cacher l'HUD", Hud, Description, 1)
	DiversMenu.SubMenu:AddItem(hudItem)
	local ragdollItem = NativeUI.CreateItem(('Dormir | Se Réveiller'), Description1)
	DiversMenu.SubMenu:AddItem(ragdollItem)
	
    DiversMenu.SubMenu.OnCheckboxChange = function(sender, item, checked_)
	    if item == hudItem then
			source = checked_
			openInterface()
		end
	end

DiversMenu.SubMenu.OnItemSelect = function(sender, item, index)
	if item == ragdollItem then
		Ragdoll()
		end
	end
end

function AddMenuFacturesMenu(menu)
	billMenu = _menuPool:AddSubMenu(menu, 'Vos ~o~Factures')
	billItem = {}

	ESX.TriggerServerCallback('vMenuDuarte:Bill_getBills', function(bills)
		for i = 1, #bills, 1 do
			local label = bills[i].label
			local amount = bills[i].amount
			local value = bills[i].id

			table.insert(billItem, value)

			billItem[value] = NativeUI.CreateItem(label, "")
			billItem[value]:RightLabel("$" .. ESX.Math.GroupDigits(amount))
			billMenu.SubMenu:AddItem(billItem[value])
		end

		billMenu.SubMenu.OnItemSelect = function(sender, item, index)
			for i = 1, #bills, 1 do
				local label  = bills[i].label
				local value = bills[i].id

				if item == billItem[value] then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						_menuPool:CloseAllMenus()
					end, value)
				end
			end
		end
	end)
end

function AddMenuVehicleMenu(menu)
	personalmenu.frontLeftDoorOpen = false
	personalmenu.frontRightDoorOpen = false
	personalmenu.backLeftDoorOpen = false
	personalmenu.backRightDoorOpen = false
	personalmenu.hoodDoorOpen = false
	personalmenu.trunkDoorOpen = false
	personalmenu.doorList = {
		'Avant Gauche',
		'Avant Droite',
		'Arrière Gauche',
		'Arrière Droite'
	}

	vehicleMenu = _menuPool:AddSubMenu(menu, 'Gestion Véhicule')

	local vehEngineItem = NativeUI.CreateItem('Allumer/Eteindre le Moteur', "")
	vehicleMenu.SubMenu:AddItem(vehEngineItem)
	local vehDoorListItem = NativeUI.CreateListItem('Ouvrir/Fermer Porte', personalmenu.doorList, 1)
	vehicleMenu.SubMenu:AddItem(vehDoorListItem)
	local vehHoodItem = NativeUI.CreateItem('Ouvrir/Fermer Capot', "")
	vehicleMenu.SubMenu:AddItem(vehHoodItem)
	local vehTrunkItem = NativeUI.CreateItem('Ouvrir/Fermer Coffre', "")
	vehicleMenu.SubMenu:AddItem(vehTrunkItem)

	vehicleMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehEngineItem then
				if GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, false, false, true)
					SetVehicleUndriveable(plyVehicle, true)
				elseif not GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, true, false, true)
					SetVehicleUndriveable(plyVehicle, false)
				end
			elseif item == vehHoodItem then
				if not personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 4, false, false)
				elseif personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 4, false, false)
				end
			elseif item == vehTrunkItem then
				if not personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 5, false, false)
				elseif personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 5, false, false)
				end
			end
		end
	end

	vehicleMenu.SubMenu.OnListSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehDoorListItem then
				if index == 1 then
					if not personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 0, false, false)
					elseif personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 0, false, false)
					end
				elseif index == 2 then
					if not personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 1, false, false)
					elseif personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 1, false, false)
					end
				elseif index == 3 then
					if not personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 2, false, false)
					elseif personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 2, false, false)
					end
				elseif index == 4 then
					if not personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 3, false, false)
					elseif personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 3, false, false)
					end
				end
			end
		end
	end
end

function AddMenuBossMenu(menu)
	bossMenu = _menuPool:AddSubMenu(menu, 'Votre ~b~Gestions: ' ..ESX.PlayerData.job.label)
	local coffreItem = nil

	if societymoney ~= nil then
		coffreItem = NativeUI.CreateItem('Coffre Entreprise: ', "")
		coffreItem:RightLabel("$" .. societymoney)
		bossMenu.SubMenu:AddItem(coffreItem)
	end

	local recruterItem = NativeUI.CreateItem('Recruter', "")
	bossMenu.SubMenu:AddItem(recruterItem)
	local virerItem = NativeUI.CreateItem('Virer', "")
	bossMenu.SubMenu:AddItem(virerItem)
	local promouvoirItem = NativeUI.CreateItem('Promouvoir', "")
	bossMenu.SubMenu:AddItem(promouvoirItem)
	local destituerItem = NativeUI.CreateItem('Destituer', "")
	bossMenu.SubMenu:AddItem(destituerItem)

	bossMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruterItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_recruterplayer', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.job.name, 0)
				end
			else
				notification("Entreprise", "Notification", 'Vous n\'avez pas les ~r~droits~w~')
			end
		elseif item == virerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_virerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		elseif item == promouvoirItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_promouvoirplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		elseif item == destituerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_destituerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		end
	end
end

function AddMenuBossMenu2(menu)
	bossMenu2 = _menuPool:AddSubMenu(menu, 'Votre ~y~Gestions: ' ..ESX.PlayerData.faction.label)

	local coffre2Item = nil

	if societymoney2 ~= nil then
		coffre2Item = NativeUI.CreateItem('Coffre Organisation:', "")
		coffre2Item:RightLabel("$" .. societymoney2)
		bossMenu2.SubMenu:AddItem(coffre2Item)
	end

	local recruter2Item = NativeUI.CreateItem('Recruter', "")
	bossMenu2.SubMenu:AddItem(recruter2Item)
	local virer2Item = NativeUI.CreateItem('Virer', "")
	bossMenu2.SubMenu:AddItem(virer2Item)
	local promouvoir2Item = NativeUI.CreateItem('Promouvoir', "")
	bossMenu2.SubMenu:AddItem(promouvoir2Item)
	local destituer2Item = NativeUI.CreateItem('Destituer', "")
	bossMenu2.SubMenu:AddItem(destituer2Item)

	bossMenu2.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruter2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_recruterplayer2', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.faction.name, 0)
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		elseif item == virer2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_virerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		elseif item == promouvoir2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_promouvoirplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		elseif item == destituer2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					notification("Entreprise", "Notification", 'Aucun joueur à proximité')
				else
					TriggerServerEvent('vMenuDuarte:Boss_destituerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				notification("Entreprise", "Notification", 'vous avez pas les droits')
			end
		end
	end
end

function AddMenuAdminMenu(menu)
	adminMenu = _menuPool:AddSubMenu(menu, 'Administration')

	if playerGroup == 'mod' then
		local tptoPlrItem = NativeUI.CreateItem('TP sur Joueur', "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem('~b~TP Joueur sur moi', "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem('~g~NoClip', "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local showXYZItem = NativeUI.CreateItem('~p~Afficher/Cacher Coordonnées', "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem('~b~Afficher/Cacher Noms des Joueurs', "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			end
		end
	elseif playerGroup == 'admin' then
		local tptoPlrItem = NativeUI.CreateItem('TP sur Joueur', "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem('~b~TP Joueur sur moi', "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem('~g~NoClip', "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local repairVehItem = NativeUI.CreateItem('~b~Réparer Véhicule', "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem('~o~Retourner le véhicule', "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem('~p~Afficher/Cacher Coordonnées', "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem('~b~Afficher/Cacher Noms des Joueurs', "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem('~o~TP sur le Marqueur', "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem('~g~Réanimer un Joueur', "")
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	elseif playerGroup == 'superadmin' or playerGroup == 'owner' then
		local tptoPlrItem = NativeUI.CreateItem('TP sur Joueur', "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem('~b~TP Joueur sur moi', "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local tptoXYZItem = NativeUI.CreateItem('~o~TP sur Coordonées', "")
		adminMenu.SubMenu:AddItem(tptoXYZItem)
		local noclipItem = NativeUI.CreateItem('~g~NoClip', "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local godmodeItem = NativeUI.CreateItem('~r~Mode Invincible', "")
		adminMenu.SubMenu:AddItem(godmodeItem)
		local ghostmodeItem = NativeUI.CreateItem('~q~Mode Fantôme', "")
		adminMenu.SubMenu:AddItem(ghostmodeItem)
		local spawnVehItem = NativeUI.CreateItem('~p~Faire apparaître un Véhicule', "")
		adminMenu.SubMenu:AddItem(spawnVehItem)
		local repairVehItem = NativeUI.CreateItem('~b~Réparer Véhicule', "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem('retouné le véhicule', "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem('~p~Afficher/Cacher Coordonnées', "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem('~b~Afficher/Cacher Noms des Joueurs', "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem('~o~TP sur le Marqueur', "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem('~g~Réanimer un Joueur', "")
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == tptoXYZItem then
				admin_tp_pos()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == godmodeItem then
				admin_godmode()
			elseif item == ghostmodeItem then
				admin_mode_fantome()
			elseif item == spawnVehItem then
				admin_vehicle_spawn()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	end
end
-----------------------------------------------------------------------------les jobs 
-------------------------------------------------------------------Medic------------------------------------------f
function AddMenuMedic(menu)
    personalmenu.factureOption = {
        "Facturer"
    }
    
    medicMenu = _menuPool:AddSubMenu(menu, "Menu ~f~Medic")
	
	local factureItem = NativeUI.CreateListItem("Types de facturation:  ", personalmenu.factureOption, 1)
    medicMenu.SubMenu:AddItem(factureItem)

    local soinItem = NativeUI.CreateItem("Sac medic", "")
	medicMenu.SubMenu:AddItem(soinItem)

	medicMenu.SubMenu.OnListSelect = function(sender, item, index)
	    if index == 1 then
            _menuPool:CloseAllMenus()
            local quantity = KeyboardInput("Montant", "Montant (1000000$ Maximum):", "", 1000000)

            if quantity ~= nil then
                local post = true
                quantity = tonumber(quantity)

                if type(quantity) == 'number' then
                    quantity = ESX.Math.Round(quantity)

                    if quantity <= 0 then
                        post = false
                    end
                end

                local foundPlayers = false
                personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

                if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
                    foundPlayers = true
                end

                if foundPlayers == true then
                    local closestPed = GetPlayerPed(personalmenu.closestPlayer)

                    if not IsPedSittingInAnyVehicle(closestPed) then
                        if post == true then
                            if item == factureItem then
							----ENVOIE UNE FACTURATION
								local giveFact = "amb@code_human_in_car_mp_actions@grab_crotch@std@rps@base"
								RequestAnimDict(giveFact)
								while not HasAnimDictLoaded(giveFact) do
									Citizen.Wait(100)
								end
								TaskPlayAnim(ped, giveFact, "enter", 8.0, 8.0, -1, 50, 0, false, false, false)
								Citizen.Wait(1200)
								ClearPedTasks(ped)
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(personalmenu.closestPlayer), 'society_ambulance', 'ambulance', quantity) --A TESTER
                                _menuPool:CloseAllMenus()
                            end
                        else
                            myNotification("Facturation: ", "", "~r~Montant Invalide !")
                        end
                    else
                        if item == factureItem then
                            myNotification("Facturation: ", "", "")
                        end
                    end
                else
                    myNotification("Facturation: ", "", "Aucun joueur à proximité")
                end
            end
        end
	end
	
	medicMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == soinItem then
			opensacmedic()
			_menuPool:CloseAllMenus()
		end
	end
end
-------------------------------------------------------------------medic------------------------------------------

-------------------------------------------------mecano -----------------------------------------------------------
------local c est pour une seul function qui si je enléve c est pour plusier function
local function petiteReparationVeh()
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
			SetEntityHealth(vehicle, 1000.0)
			SetVehiclePetrolTankHealth(vehicle, 0.1)
            SetVehicleEngineOn(vehicle, 0, 0, 0)
			SetVehicleBodyHealth(vehicle, 1000.0)
			--SetVehicleFixed(vehicle, 0.0)
            --SetVehicleDeformationFixed(vehicle, 0.0001)
            SetVehicleUndriveable(vehicle, false)
			ShowNotif("~g~Le véhicule a subit une petite réparation", 5000)
			ShowNotif("~r~Mais vous devez passer au garage ~w~Pour recevoir une réparation complète.",8000)
        end
    else
         ShowNotif("~r~Placer vous devant un véhicule", 5000)
    end
end

local function CustomVehicleDommage()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(myPed, 0)
    if vehicle ~= 0 then
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local vehicleHealth = GetEntityHealth(vehicle)
        local petrolTankeHealth = GetVehiclePetrolTankHealth(vehicle)
        local total = engineHealth + vehicleHealth + petrolTankeHealth
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        if total < 2800 and engineHealth >= 1 then
        if vehicleHealth + petrolTankeHealth < 1800 or vehicleHealth < 750 then
            SetVehicleEngineHealth(vehicle, -1.0)
            SetVehicleEngineOn(vehicle, 0, 0, 0)
            SetVehicleBodyHealth(vehicle, vehicleHealth * 0.1 )
        else
            SetVehicleEngineHealth(vehicle, 0.0)
            SetVehicleEngineOn(vehicle, 0, 0, 0)
        end
        end
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

local function getStatsVehicle()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    local p = GetEntityCoords(vehicle, 0)
    local h = GetEntityHeading(vehicle)
    if vehicle ~= 0 then
        Citizen.CreateThread(function()
        TaskStartScenarioInPlace(myPed, 'PROP_HUMAN_BUM_SHOPPING_CART', 0, true)
        exports['progressBars']:startUI(8000, "")
        Citizen.Wait(8000)
        ClearPedTasks(myPed)
        local engineHealth = GetVehicleEngineHealth(vehicle)
        if engineHealth >= 0 then
            ShowNotif('~g~Aucun problème technique',8000)
        elseif engineHealth >= 100 then
            ShowNotif('~o~Le véhicule est endommagé, ~w~ il doit recevoir une réparation rapide.',8000)
        else
            ShowNotif("~r~Véhicule HS, ~w~ ce véhicule doit recevoir une réparation complète.",8000)
        end
        end)
    else
        ShowNotif("~r~Placez-vous devant un véhicule", 8000)
    end
end

local function factureCarFixRapide()
    local foundPlayers = false
    personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

    if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
        foundPlayers = true
    end

    if foundPlayers == true then
        local closestPed = GetPlayerPed(personalmenu.closestPlayer)
        _menuPool:CloseAllMenus()
        local prixReparation = 2500
        local giveFact = "amb@code_human_in_car_mp_actions@grab_crotch@std@rps@base"
        RequestAnimDict(giveFact)
        while not HasAnimDictLoaded(giveFact) do
            Citizen.Wait(100)
        end
        TaskPlayAnim(ped, giveFact, "enter", 8.0, 8.0, -1, 50, 0, false, false, false)
        Citizen.Wait(1200)
        ClearPedTasks(ped)
        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(personalmenu.closestPlayer), 'society_mecano', 'mecano', prixReparation) --A TESTER
    else
        myNotification("Facturation: ", "", "Aucun joueur à proximité")
    end
end

function AddMenuMecano(menu)
    personalmenu.factureOption = {
        "facture"
    }
    
	mecaMenu = _menuPool:AddSubMenu(menu, "Menu ~f~Mecano")
	
	local factureItem = NativeUI.CreateListItem("Types de facturation:  ", personalmenu.factureOption, 1)
    mecaMenu.SubMenu:AddItem(factureItem)
    local inspectItem = NativeUI.CreateItem("Inspecter le véhicule", "")
    mecaMenu.SubMenu:AddItem(inspectItem)

    local fixCarOption = NativeUI.CreateItem("Petite Réparation", "")
    mecaMenu.SubMenu:AddItem(fixCarOption)

	mecaMenu.SubMenu.OnListSelect = function(sender, item, index)
	    if index == 1 then
            if not IsPedSittingInAnyVehicle(closestPed) then
                if item == factureItem then
                    factureCarFixRapide()
                end
            end
        end
    end
	
    mecaMenu.SubMenu.OnItemSelect = function(sender, item, index)
        if item == inspectItem then
            getStatsVehicle()
        elseif item == fixCarOption then
            petiteReparationVeh()
        end
    end
end

-------------------------------------------------mecano fin --------------------------------------------------------
-------------------------------------------------police -----------------------------------------------------------
function AddMenuPolice(menu)
	policeSub = _menuPool:AddSubMenu(menu, "Menu ~f~Police")
	
	local facturItem = NativeUI.CreateListItem("Types de facturation:  ", "")
	policeSub.SubMenu:AddItem(facturItem)

	local sacdosItem = NativeUI.CreateItem("sac", "")
    policeSub.SubMenu:AddItem(sacdosItem)

    local menotItem = NativeUI.CreateItem("Menotter", "")
    policeSub.SubMenu:AddItem(menotItem)

    local deMenotItem = NativeUI.CreateItem("Demenotter", "")
	policeSub.SubMenu:AddItem(deMenotItem)

	local radarItem = NativeUI.CreateItem("Radar", "")
    policeSub.SubMenu:AddItem(radarItem)

	policeSub.SubMenu.OnListSelect = function(sender, item, index)
	    if index == 1 then
            _menuPool:CloseAllMenus()
            local quantity = KeyboardInput("Montant", "Montant (1000000$ Maximum):", "", 1000000)

            if quantity ~= nil then
                local post = true
                quantity = tonumber(quantity)

                if type(quantity) == 'number' then
                    quantity = ESX.Math.Round(quantity)

                    if quantity <= 0 then
                        post = false
                    end
                end

                local foundPlayers = false
                personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

                if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
                    foundPlayers = true
                end

                if foundPlayers == true then
                    local closestPed = GetPlayerPed(personalmenu.closestPlayer)

                    if not IsPedSittingInAnyVehicle(closestPed) then
                        if post == true then
                            if item == facturItem then
							----ENVOIE UNE FACTURATION
								local giveFact = "amb@code_human_in_car_mp_actions@grab_crotch@std@rps@base"
								RequestAnimDict(giveFact)
								while not HasAnimDictLoaded(giveFact) do
									Citizen.Wait(100)
								end
								TaskPlayAnim(ped, giveFact, "enter", 8.0, 8.0, -1, 50, 0, false, false, false)
								Citizen.Wait(1200)
								ClearPedTasks(ped)
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(personalmenu.closestPlayer), 'society_police', 'police', quantity) --A TESTER
                                _menuPool:CloseAllMenus()
                            end
                        else
                            myNotification("Facturation: ", "", "~r~Montant Invalide !")
                        end
                    else
                        if item == facturItem then
                            myNotification("Facturation: ", "", "")
                        end
                    end
                else
                    myNotification("Facturation: ", "", "Aucun joueur à proximité")
                end
            end
        end
	end

	policeSub.SubMenu.OnItemSelect = function(sender, item, index)
		if item == sacdosItem then
			opensacpolice()
			_menuPool:CloseAllMenus()
		elseif item == menotItem then
				player, distance = GetClosestPlayer()
				if(distance ~= -1 and distance < 3) then
					MenotterCivil()
				else
					myNotification("Police: ", "", "Aucun joueur à proximité")
				end
			elseif item == deMenotItem then
				DemenotterCivil()
			elseif item == radarItem then
				policeradar()
		end
	end
end

-------------------------------------------------police fin --------------------------------------------------------

function GeneratePersonalMenu()
	
	if ESX.PlayerData.job.name == 'ambulance' then
        AddMenuMedic(mainMenu)
    end

	if ESX.PlayerData.job.name == 'police' then
        AddMenuPolice(mainMenu)
	end

	if ESX.PlayerData.job.name == 'mecano' then
        AddMenuMecano(mainMenu)
    end

	AddMenuInventoryMenu(mainMenu)
	AddMenuWalletMenu(mainMenu)
	AddMenuFacturesMenu(mainMenu)
	AddMenuWeaponMenu(mainMenu)
	AddMenuCleMenu(mainMenu)

	if IsPedSittingInAnyVehicle(plyPed) then
		if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
			AddMenuVehicleMenu(mainMenu)
		end
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		AddMenuBossMenu(mainMenu)
	end

		if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
			AddMenuBossMenu2(mainMenu)
	end

	AddMenuDiversMenu(mainMenu)

	if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
		AddMenuAdminMenu(mainMenu)
	end


	_menuPool:RefreshIndex()
end

Citizen.CreateThread(function()
	while true do
		if IsControlJustReleased(0, Keys["F5"]) then
			if mainMenu ~= nil and not mainMenu:Visible() then
				ESX.PlayerData = ESX.GetPlayerData()
				GeneratePersonalMenu()
				mainMenu:Visible(true)
				Citizen.Wait(10)
			end
		end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while _menuPool ~= nil and _menuPool:IsAnyMenuOpen() do
			Citizen.Wait(0)
			_menuPool:ProcessMenus()
            DisableControlAction(0, 140,true) --DESACTIVE CONTROLL B
            DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT
            DisableControlAction(0, 0,true) --DESACTIVE CONTROLL VIEW
            DisableControlAction(0, 24, true) -- Desative Controll Attack
            DisableControlAction(0, 2, true) -- Look Up and Down
            DisableControlAction(0, 1, true) --Look Left and Right
			

			if not _menuPool:IsAnyMenuOpen() then
				mainMenu:Clear()
				itemMenu:Clear()
				weaponItemMenu:Clear()

				_menuPool:Clear()
				_menuPool:Remove()

				personalmenu = {}

				invItem = {}
				wepItem = {}
				billItem = {}

				collectgarbage()

				_menuPool = NativeUI.CreatePool()

				mainMenu = NativeUI.CreateMenu("Menu Personnel", "~b~MENU INTERACTION")
				itemMenu = NativeUI.CreateMenu("Menu Personnel", "Inventaire: Action")
				weaponItemMenu = NativeUI.CreateMenu("Menu Personnel", "Armes: Action")
				_menuPool:Add(mainMenu)
				_menuPool:Add(itemMenu)
				_menuPool:Add(weaponItemMenu)
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if ESX ~= nil then
			ESX.TriggerServerCallback('vMenuDuarte:Admin_getUsergroup', function(group) playerGroup = group end)

			Citizen.Wait(30 * 1000)
		else
			Citizen.Wait(100)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end

		if noclip then
			local x, y, z = getPosition()
			local dx, dy, dz = getCamDirection()
			local speed = 1.0

			SetEntityVelocity(plyPed, 0.0001, 0.0001, 0.0001)

			if IsControlPressed(0, 32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(0, 269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			SetEntityCoordsNoOffset(plyPed, x, y, z, true, true, true)
		end

		if showname then
			for id = 0, 256 do
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= plyPed then
					local headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(id), (GetPlayerServerId(id) .. ' - ' .. GetPlayerName(id)), false, false, "", false)
				end
			end
		end
		
		Citizen.Wait(0)
	end
end)

--function opensacmedi()
	--TriggerEvent('NB:closeAllSubMenu')
	--TriggerEvent('NB:closeAllMenu')
	--TriggerEvent('NB:closeMenuKey')
	
	--TriggerEvent('NB:medic')
--end

function opensacpolice()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:police')
end