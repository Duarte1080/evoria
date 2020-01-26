local pedId = nil

Locations19 = { -- Cops Men LSPD
{ x = 431.19,   y = -978.44, z = 29.71, heading = 206.50 },	-- Cops
{ x = 431.75,   y = -979.22, z = 29.71, heading = 34.40 },	-- Cops
{ x = 443.30,   y = -981.24, z = 29.69, heading = 0.70 },	-- Cops
--{ x = 454.05,   y = -980.02, z = 29.69, heading = 90.25 },	-- Cops
{ x = 456.33,   y = -988.56, z = 29.69, heading = 2.66 },	-- Cops
{ x = 459.73,   y = -989.61, z = 23.91, heading = 264.81 },	-- Cops
{ x = 467.73,   y = -1016.14,z = 25.45, heading = 276.80 },	-- Cops
--Sandy--
{ x = 1852.67,  y = 3688.85,z = 33.27, heading = 204.98 },	-- Cops
--PB--
{ x = -448.19,  y = 6012.36,z = 30.72, heading = 310.80 }	-- Cops

}

Locations20 = { -- Cops Men LSPD2
{ x = 440.24,   y = -975.67, z = 29.69, heading = 24.28 },	-- Cops
{ x = 437.07,   y = -996.31, z = 29.69, heading = 30.02	},	-- Cops
{ x = 459.84,   y = -988.52, z = 23.91, heading = 230.57 },	-- Cops
--Sandy--
{ x = 1853.15,  y = 3690.16, z = 33.27, heading = 304.32 },	-- Cops
--PB--
{ x = -449.49,  y = 6012.42, z = 30.72, heading = 69.25 }	-- Cops

}

Locations21 = { -- Cops Girl LSPD3
{ x = 437.68,   y = -979.22, z = 29.69, heading = 245.80 },	-- Cops
{ x = 430.80,   y = -979.18, z = 29.71, heading = 277.25 },	-- Cops
{ x = 420.30,   y = -989.65, z = 29.71, heading = 208.18 },	-- Cops
{ x = 452.85,   y = -988.00, z = 25.67, heading = 348.15 },	-- Cops
--Sandy--
{ x = 1854.39,  y = 3688.27, z = 33.27, heading = 97.55 },	-- Cops
--PB--
{ x = -441.35,  y = 6016.41, z = 30.70, heading = 342.40 }	-- Cops

}



-- Cops Men LSPD1
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_y_cop_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_y_cop_01")) do
        Wait(1)
    end
	
	for _, item in pairs(Locations19) do
		local npc = CreatePed(4, 0x5e3da4a4, item.x, item.y, item.z, item.heading, false, true)
		
		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, item.heading)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
		while not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions") do
			Citizen.Wait(1000)
		end
			
	    Citizen.Wait(200)	
		TaskPlayAnim(npc,"anim@heists@prison_heiststation@cop_reactions","cop_a_idle",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	end
end)

-- Cops Men LSPD2
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_y_cop_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_y_cop_01")) do
        Wait(1)
    end
	
	for _, item in pairs(Locations20) do
		local npc = CreatePed(4, 0x5e3da4a4, item.x, item.y, item.z, item.heading, false, true)
		
		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, item.heading)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
		while not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions") do
		Citizen.Wait(1000)
		end
			
	    Citizen.Wait(200)	
		TaskPlayAnim(npc,"anim@heists@prison_heiststation@cop_reactions","cop_b_reaction",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	end
end)

-- Cops Girl LSPD3
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_f_y_cop_01"))
	
    while not HasModelLoaded(GetHashKey("s_f_y_cop_01")) do
        Wait(1)
    end
	
	for _, item in pairs(Locations21) do
		local npc = CreatePed(4, 0x15f8700d, item.x, item.y, item.z, item.heading, false, true)
		
		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, item.heading)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		RequestAnimDict("amb@world_human_cop_idles@female@idle_b")
		while not HasAnimDictLoaded("amb@world_human_cop_idles@female@idle_b") do
		Citizen.Wait(1000)
		end
			
	    Citizen.Wait(200)
		TaskPlayAnim(npc,"amb@world_human_cop_idles@female@idle_b","idle_d",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)	
	end
end)

pilote = {
{ x = 463.50,   y = -991.07, z = 43.69-1, heading = 90.0 },	-- Cops
{ x = -467.1829,   y = 5996.34, z = 31.25-1, heading = 277.25 },	-- Cops
}

-- Pilote 
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_m_pilot_02"))
	
    while not HasModelLoaded(GetHashKey("s_m_m_pilot_02")) do
        Wait(1)
    end
	for _, item in pairs(pilote) do
		local npc = CreatePed(4, GetHashKey("s_m_m_pilot_02"), item.x, item.y, item.z, item.heading, false, true)
		
		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, 90.0)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		RequestAnimDict("amb@world_human_cop_idles@female@idle_b")
		while not HasAnimDictLoaded("amb@world_human_cop_idles@female@idle_b") do
		Citizen.Wait(1000)
		end

		Citizen.Wait(200)
		TaskPlayAnim(npc,"amb@world_human_cop_idles@female@idle_b","idle_d",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	end	
end)


-- ANIMATION DE PRISE D'ARME


ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		RefreshPed()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	RefreshPed()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

GetWeaponByPed = function(hash, type)
	_menuPool:CloseAllMenus()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)


	local Location = { ["x"] = 452.32196044922, ["y"] = -980.03033447266, ["z"] = 30.689582824707, ["h"] = 270.0 }
	local PedLocation = { ["x"] = 454.18048095703, ["y"] = -980.11981201172, ["z"] = 30.689603805542, ["h"] = 90.0, ["hash"] = "s_m_y_cop_01" }

		local anim = type
		local weaponHash = hash



		local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)


		if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.

			ESX.ShowNotification("Essaye de nouveau.")

			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			ESX.ShowNotification("Attendez s'il vous plait.")
			return
		end
		NetworkRequestControlOfEntity(closestPed)
		if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)

			Citizen.Wait(1000)
		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			FreezeEntityPosition(PlayerPedId(), true)
			TaskPlayAnim(closestPed, animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(1100)

			GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 1, false, true)
			SetCurrentPedWeapon(closestPed, GetHashKey(weaponHash), true)
			
			TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(3100)
			FreezeEntityPosition(PlayerPedId(), false)
			RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))

			Citizen.Wait(15)
			GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponHash), 455, false, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponHash), true)
			ClearPedTasks(closestPed)

		end

		UnloadModels()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

end



function DeposeEquipement(hash, type)
	_menuPool:CloseAllMenus()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)


	local Location = { ["x"] = 452.32196044922, ["y"] = -980.03033447266, ["z"] = 30.689582824707, ["h"] = 270.0 }
	local PedLocation = { ["x"] = 454.18048095703, ["y"] = -980.11981201172, ["z"] = 30.689603805542, ["h"] = 90.0, ["hash"] = "s_m_y_cop_01" }

		local anim = type
		local weaponHash = hash



		local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)


		if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.

			ESX.ShowNotification("Essaye de nouveau.")

			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			ESX.ShowNotification("Attendez s'il vous plait.")
			return
		end

		if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)

			Citizen.Wait(1000)
		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(1100)

			--GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 1, false, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponHash), true)

			TaskPlayAnim(closestPed, animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
			
			Citizen.Wait(3100)
			RemoveAllPedWeapons(PlayerPedId(), false)
			RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weaponHash))

			Citizen.Wait(15)
			GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 455, false, true)
			SetCurrentPedWeapon(closestPed, GetHashKey(weaponHash), true)
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(3000)
			RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))

		end

		UnloadModels()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
end

function DeposeObjets()
	_menuPool:CloseAllMenus()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)


	local Location = { ["x"] = 452.32196044922, ["y"] = -980.03033447266, ["z"] = 30.689582824707, ["h"] = 270.0 }
	local PedLocation = { ["x"] = 454.18048095703, ["y"] = -980.11981201172, ["z"] = 30.689603805542, ["h"] = 90.0, ["hash"] = "s_m_y_cop_01" }

		local anim = "rifle"
		local weaponHash = hash



		local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)


		if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.

			ESX.ShowNotification("Essaye de nouveau.")

			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			ESX.ShowNotification("Attendez s'il vous plait.")
			return
		end

		if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)

			Citizen.Wait(1000)
		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(1100)

			GiveWeaponToPed(PlayerPedId(), 0x88C78EB7, 1, false, true)
			SetCurrentPedWeapon(PlayerPedId(), 0x88C78EB7, true)

			TaskPlayAnim(closestPed, animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
			
			Citizen.Wait(3100)

			RemoveWeaponFromPed(PlayerPedId(), 0x88C78EB7)

			Citizen.Wait(15)
			GiveWeaponToPed(closestPed, 0x88C78EB7, 455, false, true)
			SetCurrentPedWeapon(closestPed, 0x88C78EB7, true)
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(3000)
			RemoveWeaponFromPed(closestPed, 0x88C78EB7)
			ClearPedTasks(closestPed)

		end

		UnloadModels()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
end



RefreshPed = function(spawn)

	LoadModels({ GetHashKey("s_m_y_cop_01") })
	ESX.TriggerServerCallback("qalle_policearmory:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
			pedId = CreatePed(5, GetHashKey("s_m_y_cop_01"), 454.18048095703, -980.11981201172, 30.689603805542 - 0.985, 90.0, true)

			SetPedCombatAttributes(pedId, 46, true)                     
			SetPedFleeAttributes(pedId, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId, true)

			SetEntityAsMissionEntity(pedId, true, true)
			SetEntityInvincible(pedId, true)

			SetCanAttackFriendly(pedId, false, true)
			SetPedAsCop(pedId, true)
			SetPedCombatAbility(pedId, 0)
			SetPedCombatAttributes(pedId, 0, 1)
			SetPedCombatAttributes(pedId, 1, 1)
			SetPedCombatAttributes(pedId, 3, 0)
			SetPedCombatAttributes(pedId, 5, 0)
			SetPedCombatAttributes(pedId, 20, 1)
			SetPedCombatAttributes(pedId, 46, 0)
			SetPedCombatAttributes(pedId, 52, 0)
			SetPedCombatRange(pedId, 0)

			FreezeEntityPosition(pedId, true)
		end
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteEntity(pedId)
	end
end)

local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

UnloadModels = function()
	for modelIndex = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end

		table.remove(CachedModels, modelIndex)
	end
end