local isBleeding = 0
local bleedTickTimer, advanceBleedTimer = 0, 0
local fadeOutTimer, blackoutTimer = 0, 0

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local legCount = 0
local armcount = 0
local headCount = 0

local playerHealth = nil
local playerArmour = nil

local limbNotifId = 'MHOS_LIMBS'
local bleedNotifId = 'MHOS_BLEED'
local bleedMoveNotifId = 'MHOS_BLEEDMOVE'


local BodyParts = {
    ['HEAD'] = { label = 'Head', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'Neck', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'Spine', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'Upper Body', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'Lower Body', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'Left Arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'Left Hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'Left Hand Fingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'Left Leg', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'Left Foot', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'Right Arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'Right Hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'Right Hand Fingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'Right Leg', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'Right Foot', causeLimp = true, isDamaged = false, severity = 0 },
}

local injured = {}

function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end

    return false
end

function IsInjuredOrBleeding()
    if isBleeding > 0 then
        return true
    else
        for k, v in pairs(BodyParts) do
            if v.isDamaged then
                return true
            end
        end
    end

    return false
end

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            ClearEntityLastDamageEntity(ped)
            return v
        end
    end

    return nil
end

function ProcessRunStuff(ped)
    ped = PlayerPedId()
    if IsInjuryCausingLimp()  then
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Citizen.Wait(0)
        end
        SetPedMovementClipset(ped, "move_m@injured", 1 )
        SetPlayerSprint(PlayerId(), false)
        SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        local level = 0
        for k, v in pairs(injured) do
            if v.severity > level then
                level = v.severity
            end
        end

        SetPedMoveRateOverride(ped, Config.MovementRate[level])
    else
        SetPedMoveRateOverride(ped, 1.0)
        ResetPedMovementClipset(ped, 1.0)
    end
end

function ProcessDamage(ped)
    ped = PlayerPedId()
    if not IsEntityDead(ped) then
        for k, v in pairs(injured) do
            
            if (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) or (v.part == 'RARM' and v.severity > 1) or (v.part == 'RHAND' and v.severity > 1) or (v.part == 'RFINGER' and v.severity > 2) then
                if armcount >= Config.ArmInjuryTimer then
                    local chance = math.random(100)

                    if (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) then
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    else
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisableControlAction(0, 25, true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    end

                    armcount = 0
                else
                    armcount = armcount + 1
                end
            end
        end
    end
end

function CheckDamage(ped, bone, weapon)
    ped = PlayerPedId()
    if weapon == nil then return end

    if Config.Bones[bone] ~= nil then
        if not BodyParts[Config.Bones[bone]].isDamaged then
            BodyParts[Config.Bones[bone]].isDamaged = true
            BodyParts[Config.Bones[bone]].severity = 1
            if weapon == Config.WeaponClasses['SMALL_CALIBER'] or weapon == Config.WeaponClasses['MEDIUM_CALIBER'] or weapon == Config.WeaponClasses['CUTTING'] or weapon == Config.WeaponClasses['WILDLIFE'] or weapon == Config.WeaponClasses['OTHER'] or weapon == Config.WeaponClasses['LIGHT_IMPACT'] then
                if (Config.Bones[bone] == 'UPPER_BODY' or Config.Bones[bone] == 'LOWER_BODY' or Config.Bones[bone] == 'SPINE') and (weapon == Config.WeaponClasses['SMALL_CALIBER'] or weapon == Config.WeaponClasses['MEDIUM_CALIBER']) then
                    if GetPedArmour(ped) > 0 then
                        local chance = math.random(100)
                        if chance <= math.ceil(Config.BodyArmorStaggerChance / 2) then
                           
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    else
                        if Config.Bones[bone] == 'SPINE' then
                            
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    end
                end
            elseif weapon == Config.WeaponClasses['HIGH_CALIBER'] or weapon == Config.WeaponClasses['HEAVY_IMPACT'] or weapon == Config.WeaponClasses['SHOTGUN'] or weapon == Config.WeaponClasses['EXPLOSIVE'] then
                if (Config.Bones[bone] == 'UPPER_BODY' or Config.Bones[bone] == 'LOWER_BODY' or Config.Bones[bone] == 'SPINE') and (weapon == Config.WeaponClasses['HIGH_CALIBER'] or weapon == Config.WeaponClasses['SHOTGUN']) then
                    if GetPedArmour(ped) > 0 then
                        local chance = math.random(100)
                        if chance <= math.ceil(Config.BodyArmorStaggerChance) then
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    else
                        if Config.Bones[bone] == 'SPINE' then
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    end
                end
            end

            table.insert(injured, {
                part = Config.Bones[bone],
                label = BodyParts[Config.Bones[bone]].label,
                severity = BodyParts[Config.Bones[bone]].severity
            })

            TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
                limbs = BodyParts,
                isBleeding = tonumber(isBleeding)
            })

            ProcessRunStuff(ped)
        else
            if weapon == Config.WeaponClasses['SMALL_CALIBER'] or weapon == Config.WeaponClasses['MEDIUM_CALIBER'] or weapon == Config.WeaponClasses['CUTTING'] or weapon == Config.WeaponClasses['WILDLIFE'] or weapon == Config.WeaponClasses['OTHER'] or weapon == Config.WeaponClasses['LIGHT_IMPACT'] then
                if (Config.Bones[bone] == 'UPPER_BODY' or Config.Bones[bone] == 'LOWER_BODY' or Config.Bones[bone] == 'SPINE') and (weapon == Config.WeaponClasses['SMALL_CALIBER'] or weapon == Config.WeaponClasses['MEDIUM_CALIBER']) then
                    if GetPedArmour(ped) > 0 then
                        local chance = math.random(100)
                        if chance <= math.ceil(Config.BodyArmorStaggerChance / 2) then
                           

							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    else
                        if Config.Bones[bone] == 'SPINE' then
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    end
                end
            elseif weapon == Config.WeaponClasses['HIGH_CALIBER'] or weapon == Config.WeaponClasses['HEAVY_IMPACT'] or weapon == Config.WeaponClasses['SHOTGUN'] or weapon == Config.WeaponClasses['EXPLOSIVE'] then
                if (Config.Bones[bone] == 'UPPER_BODY' or Config.Bones[bone] == 'LOWER_BODY' or Config.Bones[bone] == 'SPINE') and (weapon == Config.WeaponClasses['HIGH_CALIBER'] or weapon == Config.WeaponClasses['SHOTGUN']) then
                    if GetPedArmour(ped) > 0 then
                        local chance = math.random(100)
                        if chance <= math.ceil(Config.BodyArmorStaggerChance) then
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    else
                        if Config.Bones[bone] == 'SPINE' then
							SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        end
                    end
                end
            end

            if BodyParts[Config.Bones[bone]].severity < 4 then
                BodyParts[Config.Bones[bone]].severity = BodyParts[Config.Bones[bone]].severity + 1
                TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
                    limbs = BodyParts,
                    isBleeding = tonumber(isBleeding)
                })

                for k, v in pairs(injured) do
                    if v.part == Config.Bones[bone] then
                        v.severity = BodyParts[Config.Bones[bone]].severity
                    end
                end
            end

            ProcessRunStuff(ped)
        end
    end
end

RegisterNetEvent('mythic_hospital:client:SyncBleed')
AddEventHandler('mythic_hospital:client:SyncBleed', function(bleedStatus)
    isBleeding = tonumber(bleedStatus)
end)

RegisterNetEvent('mythic_hospital:client:FieldTreatLimbs')
AddEventHandler('mythic_hospital:client:FieldTreatLimbs', function()
    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 1
    end

    for k, v in pairs(injured) do
        if v.part == Config.Bones[bone] then
            v.severity = BodyParts[Config.Bones[bone]].severity
        end
    end

    TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
end)

RegisterNetEvent('mythic_hospital:client:FieldTreatBleed')
AddEventHandler('mythic_hospital:client:FieldTreatBleed', function()
    if isBleeding > 1 then
        isBleeding = tonumber(isBleeding) - 1

        TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
            limbs = BodyParts,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(PlayerPedId())
    end
end)

RegisterNetEvent('mythic_hospital:client:ReduceBleed')
AddEventHandler('mythic_hospital:client:ReduceBleed', function()
    if isBleeding > 0 then
        isBleeding = tonumber(isBleeding) - 1

        TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
            limbs = BodyParts,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(PlayerPedId())
    end
end)


RegisterNetEvent('mythic_hospital:client:ResetLimbs')
AddEventHandler('mythic_hospital:client:ResetLimbs', function()
    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end
    injured = {}

    TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
end)

RegisterNetEvent('mythic_hospital:client:RemoveBleed')
AddEventHandler('mythic_hospital:client:RemoveBleed', function()
    isBleeding = 0

    TriggerServerEvent('mythic_hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
end)

local prevPos = nil
Citizen.CreateThread(function()
    Citizen.Wait(2500)
    prevPos = GetEntityCoords(PlayerPedId(), true)
    while true do
        local player = PlayerPedId()
        if bleedTickTimer >= Config.BleedTickRate then
            if not IsEntityDead(player) then
                if isBleeding > 0 then
                    if fadeOutTimer % Config.FadeOutTimer == 0 then
                        if blackoutTimer >= Config.BlackoutTimer then

                            if not IsPedRagdoll(player) and IsPedOnFoot(player) and not IsPedSwimming(player) then
                                SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end

                            Citizen.Wait(1500)
                            DoScreenFadeIn(1000)
                            blackoutTimer = 0
                        else
                            if isBleeding > 3 then
                                blackoutTimer = blackoutTimer + 2
                            else
                                blackoutTimer = blackoutTimer + 1
                            end
                            fadeOutTimer = 0
                        end
                    else
                        fadeOutTimer = fadeOutTimer + 1
                    end
                end
            end
            bleedTickTimer = 0
        else
            if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
                local currPos = GetEntityCoords(player, true)
                local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                if (moving > 1 and not IsPedInAnyVehicle(player)) and isBleeding > 2 then
                    advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
                    bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
                    prevPos = currPos
                else
                    advanceBleedTimer = advanceBleedTimer + 1
                    bleedTickTimer = bleedTickTimer + 1
                end

            else

            end
            bleedTickTimer = bleedTickTimer + 1
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health and health < (playerHealth - Config.HealthDamage)) -- Players health was damaged

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                local weapon = GetDamagingWeapon(ped)
                if weapon ~= nil then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'LOWER_BODY') and weapon <= Config.WeaponClasses['LIGHT_IMPACT'] and weapon ~= Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end

                    if checkDamage then
                        CheckDamage(ped, bone, weapon)
                    end
                end
            end
        end

        playerHealth = health
        playerArmor = armor
        Citizen.Wait(500)

        ProcessDamage(ped)
        Citizen.Wait(500)
    end
end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    TriggerEvent('mythic_hospital:client:RemoveBleed')
end)

RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    TriggerEvent('mythic_hospital:client:RemoveBleed')
end)

function myNotification(title, subject, msg)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
	UnregisterPedheadshot(mugshot)
end

local ragdoll_chance = 0.3
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600)
				SetPedToRagdoll(ped, 5000, 1, 2)
            else
				Citizen.Wait(2000)
            end
        end
	end
end)

playerMoving = false

Citizen.CreateThread(function()
	while true do Wait(0)
		if not IsPedInAnyVehicle(PlayerPedId(), false) and GetEntitySpeed(PlayerPedId()) >= 0.5 and GetFollowPedCamViewMode() ~= 4 then
			if playerMoving == false then
				ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.15)
				playerMoving = true
			end
		else
			if playerMoving == true then
				StopGameplayCamShaking(false)
				playerMoving = false
			end
		end
	end
end)