local stuff = {
    choosing = true,
    peds = {},
    spawnPositions = {
        vector3(409.48, -999.34, -100.0), -- vector3(409.87, -1001.05, -99.0)
        vector3(409.48, -998.06, -100.0), -- vector3(409.81, -1002.03, -99.0)
    },
    characters = {
        false, false
    },
    current = 1,
}

local function CallScaleformMethod (scaleform, method, ...)
	local t
	local args = { ... }

	BeginScaleformMovieMethod(scaleform, method)

	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end

	EndScaleformMovieMethod()
end

CreateBoard = function(ped)
    ClearPedWetness(ped)
    ClearPedBloodDamage(ped)
    ClearPlayerWantedLevel(PlayerId())
    SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), 1)
end

LongHelpText = function(text)
    AddTextEntry("klf_long_help_text", text)
    DisplayHelpTextThisFrame("klf_long_help_text", false)
end

NextCharacter = function()
    local dict = "anim@mp_player_intupperthumbs_up"
    local dicta = "amb@prop_human_muscle_chin_ups@male@idle_a"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(stuff.peds[stuff.current], dicta, "idle_a", 8.0, 8.0, -1, 14, 0, false, false, false)
    if stuff.current == 2 then
        stuff.current = 1
    else
        stuff.current = stuff.current + 1
    end

    TaskPlayAnim(stuff.peds[stuff.current], dict, "enter", 8.0, 8.0, -1, 14, 0, false, false, false)
end


------------------------------------------------------------------------CARTE IDENTITER

function DrawAdvancedText2(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end


Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() or not DoesEntityExist(PlayerPedId()) do Wait(0) end
    ShutdownLoadingScreen()
    Wait(0)
    ShutdownLoadingScreenNui()
    while not IsScreenFadedOut() do Wait(0) DoScreenFadeOut(0) end
    TriggerEvent('skinchanger:loadDefaultModel', true)
    TriggerServerEvent('loaf_character:getChars')

    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if stuff.choosing then
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 415.52, -998.38, -99.4, true) <= 1.5 then
                    SetEntityCoords(PlayerPedId(), 415.52, -998.38, -99.4)
                    SetEntityVisible(PlayerPedId(), false, false)
                end
                for i = 0, 31 do
                    DisableAllControlActions(i)
                end
                for i = 1, #stuff.spawnPositions do
                    SetEntityCoords(stuff.peds[i], stuff.spawnPositions[i])
                end
                if stuff.characters[stuff.current] == false then
                    if GetLastInputMethod(0) then
                        LongHelpText('~INPUT_CELLPHONE_RIGHT~ Switch de personnage\n~INPUT_FRONTEND_RDOWN~ ~y~Nouveau Personnage', false, -1)
                    else
                        LongHelpText('~INPUT_CELLPHONE_RIGHT~ Switch de personnage\n~INPUT_FRONTEND_ACCEPT~ ~y~Nouveau Personnage', false, -1)
                    end
                else
                    local ch = stuff.characters[stuff.current]
                    local name = ('%s %s'):format(stuff.characters[stuff.current].firstname, stuff.characters[stuff.current].lastname)
                    if GetLastInputMethod(0) then
                        DrawRect(0.883000000000001, 0.37, 0.190, 0.325, 0,0,0,220) -- Rectangle Background
                        DrawAdvancedText2(0.975000000000001, 0.239, 0.005, 0.0028, 0.5, "Votre Identité:" , 255, 255, 255, 255, 0, 0)
                        DrawAdvancedText2(0.897000000000001, 0.350, 0.005, 0.0028, 0.3, "Prénom :~g~ "..ch.firstname, 255, 255, 255, 255, 0, 1)
                        DrawAdvancedText2(0.897000000000001, 0.380, 0.005, 0.0028, 0.3, "Nom : ~g~"..ch.lastname, 255, 255, 255, 255, 0, 1)
                        DrawAdvancedText2(0.897000000000001, 0.410, 0.005, 0.0028, 0.3, "Age : ~g~"..ch.age, 255, 255, 255, 255, 0, 1)
                        DrawAdvancedText2(0.897000000000001, 0.440, 0.005, 0.0028, 0.3, "Métier : ~g~"..ch.job, 255, 255, 255, 255, 0, 1)
                        LongHelpText(('~INPUT_CELLPHONE_RIGHT~ Switch de personnage\n~INPUT_FRONTEND_RDOWN~ ~g~Jouer ~w~avec  ~b~%s'):format(name, name), false, -1)
                    else
                        LongHelpText(('~INPUT_CELLPHONE_RIGHT~ Switch de personnage\n~INPUT_FRONTEND_ACCEPT~ ~g~Jouer ~w~ avec  ~b~%s'):format(name, name), false, -1)
                    end
                end
                if IsDisabledControlJustReleased(0, 175) then
                    NextCharacter()
                elseif IsDisabledControlJustReleased(0, 191) then
                    if stuff.characters[stuff.current] == false then
                        stuff.choosing = false
                        DoScreenFadeOut(0)
                        TriggerServerEvent('kashactersS:CharacterChosen', stuff.current, false)
                    else
                        stuff.choosing = false
                        TriggerServerEvent('kashactersS:CharacterChosen', stuff.current, true)
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('loaf_character:loadCharacters')
AddEventHandler('loaf_character:loadCharacters', function(characters, respawning)
    while not IsScreenFadedOut() do Wait(0) DoScreenFadeOut(0) end
    for i = 1, #stuff.spawnPositions do
        ClearAreaOfEverything(stuff.spawnPositions[i], 25.0, false, false, false, false)
        local modelHash = 1885233650
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(0) end
        SetPlayerModel(PlayerId(), modelHash)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetEntityVisible(PlayerPedId(), true, false)
        stuff.peds[i] = CreatePed(5, modelHash, stuff.spawnPositions[i], 270.0, false)
        SetEntityAsMissionEntity(stuff.peds[i], true, true)
        SetEntityInvincible(stuff.peds[i], true)
        SetPedHearingRange(stuff.peds[i], 0.0)
        SetPedSeeingRange(stuff.peds[i], 0.0)
        SetPedAlertness(stuff.peds[i], 0.0)
        SetBlockingOfNonTemporaryEvents(stuff.peds[i], true)
        SetPedCombatAttributes(stuff.peds[i], 46, true)
        SetPedFleeAttributes(stuff.peds[i], 0, 0)

        local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
        TaskPlayAnim(stuff.peds[i], dict, "base", 8.0, 8.0, -1, 14, 0, false, false, false)
    end
    CreateBoard(stuff.peds[stuff.current])
    TaskPlayAnim(stuff.peds[stuff.current], "amb@world_human_hang_out_street@female_arms_crossed@base", "base", 8.0, 8.0, -1, 14, 0, false, false, false)
    for i = 1, #characters do
        local id = tonumber(characters[i].identifier:sub(5,5))
        stuff.characters[id] = characters[i]
        if characters[i].skin == nil then
            characters[i].skin = '{"skin":0,"sex":0,"torso_2":0,"beard_3":0,"complexion_2":0,"bracelets_1":-1,"chest_3":0,"glasses_1":0,"lipstick_1":0,"hair_1":0,"face":0,"bodyb_1":0,"blush_2":0,"decals_1":0,"chest_2":0,"eyebrows_1":0,"bproof_2":0,"hair_color_2":0,"chain_2":0,"beard_4":0,"lipstick_3":0,"makeup_4":0,"blemishes_1":0,"moles_2":0,"sun_1":0,"helmet_2":0,"tshirt_2":0,"eyebrows_3":0,"lipstick_2":0,"blush_1":0,"moles_1":0,"torso_1":0,"eyebrows_2":0,"arms":0,"age_1":0,"eye_color":0,"hair_color_1":0,"complexion_1":0,"helmet_1":-1,"blemishes_2":0,"makeup_3":0,"lipstick_4":0,"ears_2":0,"bracelets_2":0,"shoes_1":0,"beard_2":0,"bodyb_2":0,"watches_1":-1,"pants_1":0,"arms_2":0,"makeup_1":0,"pants_2":0,"shoes_2":0,"tshirt_1":0,"bproof_1":0,"sun_2":0,"bags_1":0,"makeup_2":0,"age_2":0,"watches_2":0,"eyebrows_4":0,"glasses_2":0,"decals_2":0,"blush_3":0,"chain_1":0,"ears_1":-1,"chest_1":0,"beard_1":0,"mask_1":0,"mask_2":0,"bags_2":0,"hair_2":0}'
        end
        local skin = json.decode(characters[i].skin)
        if skin.sex == 1 then
            DeletePed(stuff.peds[id])
            local modelHash = GetHashKey('mp_f_freemode_01')
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do Wait(0) end
            stuff.peds[id] = CreatePed(5, modelHash, stuff.spawnPositions[id], 270.0, false)
            local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do Wait(0) end
            TaskPlayAnim(stuff.peds[id], dict, "base", 8.0, 8.0, -1, 14, 0, false, false, false)
        end
        TriggerEvent('skinchanger:loadPedSkin', stuff.peds[id], skin)
    end
    local cam = {}
    if not respawning then
        cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
        SetCamCoord(cam, 415.54, -998.27, -98.5)
        RenderScriptCams(1, 0, 0, 1, 1)
        PointCamAtCoord(cam, 408.89, -998.42, -99.0)
    end
    local timer = GetGameTimer() + 1500
    while timer >= GetGameTimer() do SetEntityCoords(PlayerPedId(), 415.52, -998.38, -99.4) Wait(50) end
    DoScreenFadeIn(1500)
    if not respawning then
        while GetCamFov(cam) >= 25.0 do
            Wait(0)
            SetCamFov(cam, GetCamFov(cam)-0.05)
        end
    end
end)

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn)
    RenderScriptCams(0, 0, 1, 1, 1)
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    DoScreenFadeOut(0)
    SetEntityVisible(PlayerPedId(), true, false)
    TriggerServerEvent('es:firstJoinProper')
    TriggerEvent('es:allowedToSpawn')
    SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z)
    FreezeEntityPosition(PlayerPedId(), false)
    for i = 1, #stuff.peds do
        DeletePed(stuff.peds[i])
    end
    ESX = nil
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
    end
    while not NetworkIsSessionStarted() or ESX.GetPlayerData().job == nil do Wait(0) end
    DoScreenFadeIn(1500)
end)